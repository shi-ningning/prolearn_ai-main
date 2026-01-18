import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/classroom/v1.dart' as classroom;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'google_sign_in_instance.dart';

class GoogleClassroomService {
  late final GoogleSignIn _googleSignIn;

  GoogleClassroomService() {
    _googleSignIn = GoogleSignInInstance.instance;
  }

  GoogleSignInAccount? _currentUser;
  classroom.ClassroomApi? _classroomApi;

  Future<bool> signIn({bool allowPrompt = true}) async {
    try {
      print('🔍 GoogleClassroom: Checking current Google user...');
      var account = _googleSignIn.currentUser;
      print('GoogleClassroom: Current user: ${account?.email ?? "none"}');
      
      if (account == null) {
        print('🔍 GoogleClassroom: Attempting silent sign-in...');
        try {
          account = await _googleSignIn.signInSilently(suppressErrors: false);
          print('GoogleClassroom: Silent sign-in result: ${account?.email ?? "failed"}');
        } catch (e) {
          print('⚠️ GoogleClassroom: Silent sign-in error: $e');
        }
      }
      
      if (account == null && allowPrompt) {
        print('🔍 GoogleClassroom: Attempting regular sign-in (with prompt)...');
        account = await _googleSignIn.signIn();
        print('GoogleClassroom: Regular sign-in result: ${account?.email ?? "cancelled"}');
      }
      
      if (account == null) {
        print('❌ GoogleClassroom: No Google account available');
        return false;
      }

      print('✅ GoogleClassroom: Google account obtained: ${account.email}');
      _currentUser = account;
      
      print('🔍 GoogleClassroom: Checking if scopes are granted...');
      final hasScopes = await _googleSignIn.canAccessScopes([
        classroom.ClassroomApi.classroomCoursesReadonlyScope,
        classroom.ClassroomApi.classroomCourseworkMeReadonlyScope,
        classroom.ClassroomApi.classroomRostersReadonlyScope,
        'https://www.googleapis.com/auth/classroom.announcements.readonly',
        'https://www.googleapis.com/auth/classroom.courseworkmaterials.readonly',
        'https://www.googleapis.com/auth/classroom.topics.readonly',
      ]);
      
      print('GoogleClassroom: Has required scopes: $hasScopes');
      
      if (!hasScopes && allowPrompt) {
        print('🔍 GoogleClassroom: Requesting additional scopes...');
        try {
          await _googleSignIn.requestScopes([
            classroom.ClassroomApi.classroomCoursesReadonlyScope,
            classroom.ClassroomApi.classroomCourseworkMeReadonlyScope,
            classroom.ClassroomApi.classroomRostersReadonlyScope,
            'https://www.googleapis.com/auth/classroom.announcements.readonly',
            'https://www.googleapis.com/auth/classroom.courseworkmaterials.readonly',
            'https://www.googleapis.com/auth/classroom.topics.readonly',
          ]);
          print('✅ GoogleClassroom: Additional scopes granted');
        } catch (e) {
          print('❌ GoogleClassroom: Failed to request scopes: $e');
          return false;
        }
      } else if (!hasScopes) {
        print('❌ GoogleClassroom: Missing required scopes and prompt not allowed');
        return false;
      }
      
      print('🔍 GoogleClassroom: Getting authenticated client...');
      final httpClient = await _googleSignIn.authenticatedClient();
      if (httpClient == null) {
        print('❌ GoogleClassroom: Failed to get authenticated client');
        print('GoogleClassroom: Trying to refresh authentication...');
        
        try {
          await account.clearAuthCache();
          final refreshedClient = await _googleSignIn.authenticatedClient();
          if (refreshedClient == null) {
            print('❌ GoogleClassroom: Still failed after cache clear');
            return false;
          }
          print('✅ GoogleClassroom: Got client after refresh');
          _classroomApi = classroom.ClassroomApi(refreshedClient);
        } catch (e) {
          print('❌ GoogleClassroom: Error refreshing: $e');
          return false;
        }
      } else {
        print('✅ GoogleClassroom: Authenticated client obtained');
        _classroomApi = classroom.ClassroomApi(httpClient);
      }
      
      print('✅ GoogleClassroom: Classroom API initialized successfully');
      return true;
    } catch (e, stackTrace) {
      print('❌ GoogleClassroom: Error signing in: $e');
      print('GoogleClassroom: Stack trace: $stackTrace');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _classroomApi = null;
  }

  bool get isSignedIn => _currentUser != null;

  Future<String> getTeacherName(String courseId, String userId) async {
    if (_classroomApi == null) {
      final signedIn = await signIn();
      if (!signedIn) return 'Teacher';
    }

    try {
      final teacher = await _classroomApi!.courses.teachers.get(courseId, userId);
      return teacher.profile?.name?.fullName ?? 'Teacher';
    } catch (e) {
      print('Error fetching teacher name: $e');
      return 'Teacher';
    }
  }

  Future<List<GoogleClassroomCourse>> getCourses() async {
    if (_classroomApi == null) {
      final signedIn = await signIn();
      if (!signedIn) return [];
    }

    try {
      final response = await _classroomApi!.courses.list(
        studentId: 'me',
        courseStates: ['ACTIVE'],
      );

      if (response.courses == null) return [];

      final courses = <GoogleClassroomCourse>[];
      
      for (final course in response.courses!) {
        String teacherName = 'Teacher';
        
        try {
          final teachers = await _classroomApi!.courses.teachers.list(course.id!);
          if (teachers.teachers != null && teachers.teachers!.isNotEmpty) {
            final primaryTeacher = teachers.teachers!.first;
            teacherName = primaryTeacher.profile?.name?.fullName ?? 'Teacher';
          }
        } catch (e) {
          print('Error fetching teacher for course ${course.id}: $e');
        }

        courses.add(GoogleClassroomCourse(
          id: course.id ?? '',
          name: course.name ?? 'Unnamed Course',
          section: course.section ?? '',
          descriptionHeading: course.descriptionHeading ?? '',
          description: course.description ?? '',
          room: course.room ?? '',
          ownerId: course.ownerId ?? '',
          courseState: course.courseState ?? '',
          alternateLink: course.alternateLink ?? '',
          teacherName: teacherName,
        ));
      }

      return courses;
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<List<GoogleClassroomAssignment>> getCourseWork(String courseId) async {
    if (_classroomApi == null) {
      final signedIn = await signIn();
      if (!signedIn) return [];
    }

    try {
      final response = await _classroomApi!.courses.courseWork.list(courseId);

      if (response.courseWork == null) return [];

      return response.courseWork!.map((work) {
        return GoogleClassroomAssignment(
          id: work.id ?? '',
          courseId: work.courseId ?? '',
          title: work.title ?? 'Untitled Assignment',
          description: work.description ?? '',
          state: work.state ?? '',
          alternateLink: work.alternateLink ?? '',
          creationTime: work.creationTime != null
              ? DateTime.parse(work.creationTime!)
              : DateTime.now(),
          dueDate: work.dueDate != null
              ? DateTime(
                  work.dueDate!.year ?? DateTime.now().year,
                  work.dueDate!.month ?? DateTime.now().month,
                  work.dueDate!.day ?? DateTime.now().day,
                )
              : null,
          maxPoints: work.maxPoints?.toDouble() ?? 0.0,
          materials: work.materials?.map((m) {
            return GoogleClassroomMaterial(
              driveFile: m.driveFile?.driveFile?.title,
              youtubeVideo: m.youtubeVideo?.title,
              link: m.link?.url,
              form: m.form?.title,
            );
          }).toList() ?? [],
        );
      }).toList();
    } catch (e) {
      print('Error fetching coursework: $e');
      return [];
    }
  }

  Future<List<GoogleClassroomAnnouncement>> getAnnouncements(String courseId) async {
    if (_classroomApi == null) {
      final signedIn = await signIn();
      if (!signedIn) return [];
    }

    try {
      final response = await _classroomApi!.courses.announcements.list(courseId);

      if (response.announcements == null) return [];

      return response.announcements!.map((announcement) {
        return GoogleClassroomAnnouncement(
          id: announcement.id ?? '',
          courseId: announcement.courseId ?? '',
          text: announcement.text ?? '',
          state: announcement.state ?? '',
          alternateLink: announcement.alternateLink ?? '',
          creationTime: announcement.creationTime != null
              ? DateTime.parse(announcement.creationTime!)
              : DateTime.now(),
          updateTime: announcement.updateTime != null
              ? DateTime.parse(announcement.updateTime!)
              : DateTime.now(),
          materials: announcement.materials?.map((m) {
            return GoogleClassroomMaterial(
              driveFile: m.driveFile?.driveFile?.title,
              youtubeVideo: m.youtubeVideo?.title,
              link: m.link?.url,
              form: m.form?.title,
            );
          }).toList() ?? [],
          creatorUserId: announcement.creatorUserId ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching announcements: $e');
      return [];
    }
  }

  Future<List<GoogleClassroomCourseMaterial>> getCourseMaterials(String courseId) async {
    if (_classroomApi == null) {
      final signedIn = await signIn();
      if (!signedIn) return [];
    }

    try {
      final response = await _classroomApi!.courses.courseWorkMaterials.list(courseId);

      if (response.courseWorkMaterial == null) return [];

      return response.courseWorkMaterial!.map((material) {
        return GoogleClassroomCourseMaterial(
          id: material.id ?? '',
          courseId: material.courseId ?? '',
          title: material.title ?? 'Untitled Material',
          description: material.description ?? '',
          state: material.state ?? '',
          alternateLink: material.alternateLink ?? '',
          creationTime: material.creationTime != null
              ? DateTime.parse(material.creationTime!)
              : DateTime.now(),
          materials: material.materials?.map((m) {
            return GoogleClassroomMaterial(
              driveFile: m.driveFile?.driveFile?.title,
              youtubeVideo: m.youtubeVideo?.title,
              link: m.link?.url,
              form: m.form?.title,
            );
          }).toList() ?? [],
        );
      }).toList();
    } catch (e) {
      print('Error fetching course materials: $e');
      return [];
    }
  }

  Future<List<GoogleClassroomTopic>> getTopics(String courseId) async {
    if (_classroomApi == null) {
      final signedIn = await signIn();
      if (!signedIn) return [];
    }

    try {
      final response = await _classroomApi!.courses.topics.list(courseId);

      if (response.topic == null) return [];

      return response.topic!.map((topic) {
        return GoogleClassroomTopic(
          courseId: topic.courseId ?? '',
          topicId: topic.topicId ?? '',
          name: topic.name ?? 'Untitled Topic',
          updateTime: topic.updateTime != null
              ? DateTime.parse(topic.updateTime!)
              : DateTime.now(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching topics: $e');
      return [];
    }
  }
}

class GoogleClassroomCourse {
  final String id;
  final String name;
  final String section;
  final String descriptionHeading;
  final String description;
  final String room;
  final String ownerId;
  final String courseState;
  final String alternateLink;
  final String teacherName;

  GoogleClassroomCourse({
    required this.id,
    required this.name,
    required this.section,
    required this.descriptionHeading,
    required this.description,
    required this.room,
    required this.ownerId,
    required this.courseState,
    required this.alternateLink,
    required this.teacherName,
  });
}

class GoogleClassroomAssignment {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String state;
  final String alternateLink;
  final DateTime creationTime;
  final DateTime? dueDate;
  final double maxPoints;
  final List<GoogleClassroomMaterial> materials;

  GoogleClassroomAssignment({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.state,
    required this.alternateLink,
    required this.creationTime,
    this.dueDate,
    required this.maxPoints,
    required this.materials,
  });
}

class GoogleClassroomMaterial {
  final String? driveFile;
  final String? youtubeVideo;
  final String? link;
  final String? form;

  GoogleClassroomMaterial({
    this.driveFile,
    this.youtubeVideo,
    this.link,
    this.form,
  });
}

class GoogleClassroomAnnouncement {
  final String id;
  final String courseId;
  final String text;
  final String state;
  final String alternateLink;
  final DateTime creationTime;
  final DateTime updateTime;
  final List<GoogleClassroomMaterial> materials;
  final String creatorUserId;

  GoogleClassroomAnnouncement({
    required this.id,
    required this.courseId,
    required this.text,
    required this.state,
    required this.alternateLink,
    required this.creationTime,
    required this.updateTime,
    required this.materials,
    required this.creatorUserId,
  });
}

class GoogleClassroomCourseMaterial {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String state;
  final String alternateLink;
  final DateTime creationTime;
  final List<GoogleClassroomMaterial> materials;

  GoogleClassroomCourseMaterial({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.state,
    required this.alternateLink,
    required this.creationTime,
    required this.materials,
  });
}

class GoogleClassroomTopic {
  final String courseId;
  final String topicId;
  final String name;
  final DateTime updateTime;

  GoogleClassroomTopic({
    required this.courseId,
    required this.topicId,
    required this.name,
    required this.updateTime,
  });
}

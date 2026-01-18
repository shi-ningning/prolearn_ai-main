import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis/classroom/v1.dart' as classroom;

class GoogleSignInInstance {
  static GoogleSignIn? _instance;

  static GoogleSignIn get instance {
    _instance ??= GoogleSignIn(
      clientId: kIsWeb ? '874731895290-48kcg1pleeoikol2dlnur1dek5nufpeq.apps.googleusercontent.com' : null,
      scopes: [
        'email',
        'profile',
        classroom.ClassroomApi.classroomCoursesReadonlyScope,
        classroom.ClassroomApi.classroomCourseworkMeReadonlyScope,
        'https://www.googleapis.com/auth/classroom.announcements.readonly',
        'https://www.googleapis.com/auth/classroom.courseworkmaterials.readonly',
        'https://www.googleapis.com/auth/classroom.topics.readonly',
      ],
    );
    return _instance!;
  }
}

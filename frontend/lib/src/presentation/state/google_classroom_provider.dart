import 'package:flutter/material.dart';
import '../../data/services/google_classroom_service.dart';

class GoogleClassroomProvider extends ChangeNotifier {
  final GoogleClassroomService _classroomService = GoogleClassroomService();
  
  List<GoogleClassroomCourse> _courses = [];
  bool _isLoading = false;
  bool _isSignedIn = false;
  String? _error;

  List<GoogleClassroomCourse> get courses => _courses;
  bool get isLoading => _isLoading;
  bool get isSignedIn => _isSignedIn;
  String? get error => _error;

  Future<void> signIn() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _classroomService.signIn();
      _isSignedIn = success;
      
      if (success) {
        await loadCourses();
      } else {
        _error = 'Failed to sign in to Google Classroom';
      }
    } catch (e) {
      _error = 'Error signing in: $e';
      _isSignedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _classroomService.signOut();
    _isSignedIn = false;
    _courses = [];
    _error = null;
    notifyListeners();
  }

  Future<void> loadCourses() async {
    if (!_isSignedIn && !_classroomService.isSignedIn) {
      await signIn();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _classroomService.getCourses();
    } catch (e) {
      _error = 'Error loading courses: $e';
      _courses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<GoogleClassroomAssignment>> getCourseWork(String courseId) async {
    try {
      return await _classroomService.getCourseWork(courseId);
    } catch (e) {
      _error = 'Error loading coursework: $e';
      return [];
    }
  }

  Future<List<GoogleClassroomAnnouncement>> getAnnouncements(String courseId) async {
    try {
      return await _classroomService.getAnnouncements(courseId);
    } catch (e) {
      _error = 'Error loading announcements: $e';
      return [];
    }
  }

  Future<List<GoogleClassroomCourseMaterial>> getCourseMaterials(String courseId) async {
    try {
      return await _classroomService.getCourseMaterials(courseId);
    } catch (e) {
      _error = 'Error loading materials: $e';
      return [];
    }
  }

  Future<List<GoogleClassroomTopic>> getTopics(String courseId) async {
    try {
      return await _classroomService.getTopics(courseId);
    } catch (e) {
      _error = 'Error loading topics: $e';
      return [];
    }
  }

  Future<String> getTeacherName(String courseId, String userId) async {
    try {
      return await _classroomService.getTeacherName(courseId, userId);
    } catch (e) {
      _error = 'Error loading teacher name: $e';
      return 'Teacher';
    }
  }
}

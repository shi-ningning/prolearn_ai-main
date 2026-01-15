import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../data/models/syllabus_model.dart';
import '../../data/repositories/syllabus_repository.dart';
import '../../data/services/course_seeder.dart';
import '../../utils/logger.dart';

class SyllabusProvider with ChangeNotifier {
  List<SyllabusModel> _syllabi = [];
  final SyllabusRepository _syllabusRepository = SyllabusRepository();
  final CourseSeeder _courseSeeder = CourseSeeder();
  bool _isLoading = false;
  StreamSubscription<List<SyllabusModel>>? _syllabiStreamSubscription;

  List<SyllabusModel> get syllabi => _syllabi;
  bool get isLoading => _isLoading;

  Future<void> loadSyllabi() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Cancel existing stream if any
      await _syllabiStreamSubscription?.cancel();
      
      // Load initial data
      _syllabi = await _syllabusRepository.getSyllabi();
      
      // If no courses exist, seed default courses
      if (_syllabi.isEmpty) {
        Logger.info('No courses found, seeding default courses...');
        await _courseSeeder.seedDefaultCourses();
        // Reload after seeding
        _syllabi = await _syllabusRepository.getSyllabi();
      }
      
      Logger.info('Loaded ${_syllabi.length} courses');
      
      // Set up real-time stream
      _syllabiStreamSubscription = _syllabusRepository
          .getSyllabiStream()
          .listen(
            (syllabi) {
              _syllabi = syllabi;
              _isLoading = false;
              notifyListeners();
              Logger.info('Real-time update: ${syllabi.length} courses');
            },
            onError: (error) {
              Logger.error('Error in syllabi stream', error);
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (e, stackTrace) {
      Logger.error('Error loading syllabi', e, stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _syllabiStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> addSyllabus(SyllabusModel syllabus) async {
    try {
      await _syllabusRepository.saveSyllabus(syllabus);
      _syllabi.add(syllabus);
      notifyListeners();
      Logger.info('Added new syllabus: ${syllabus.title}');
    } catch (e, stackTrace) {
      Logger.error('Error adding syllabus', e, stackTrace);
      rethrow;
    }
  }
}

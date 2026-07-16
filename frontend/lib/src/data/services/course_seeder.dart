import '../models/syllabus_model.dart';
import '../../utils/logger.dart';

/// Service to seed initial course data if none exists
class CourseSeeder {
  /// Default courses to seed if collection is empty
  static List<SyllabusModel> getDefaultCourses() {
    return [];
  }

  /// Seed default courses if collection is empty
  Future<void> seedDefaultCourses() async {
    Logger.info('Course seeding disabled - no default courses to seed');
  }
}

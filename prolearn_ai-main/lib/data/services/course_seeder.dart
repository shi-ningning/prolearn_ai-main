import '../models/syllabus_model.dart';
import 'firebase_service.dart';
import '../../core/utils/logger.dart';

/// Service to seed initial course data if none exists
class CourseSeeder {
  final FirebaseService _firebaseService = FirebaseService();

  /// Default courses to seed if collection is empty
  static List<SyllabusModel> getDefaultCourses() {
    return [
      SyllabusModel(
        id: 'math-101',
        title: 'Mathematics',
        description: 'Learn fundamental mathematics including algebra, geometry, and calculus.',
        topics: [
          'Introduction to Algebra',
          'Linear Equations',
          'Quadratic Equations',
          'Geometry Basics',
          'Trigonometry',
          'Calculus Fundamentals',
          'Statistics and Probability',
        ],
      ),
      SyllabusModel(
        id: 'physics-101',
        title: 'Physics',
        description: 'Explore the fundamental principles of physics and how the universe works.',
        topics: [
          'Mechanics',
          'Thermodynamics',
          'Electromagnetism',
          'Optics',
          'Modern Physics',
          'Quantum Mechanics',
        ],
      ),
      SyllabusModel(
        id: 'chemistry-101',
        title: 'Chemistry',
        description: 'Study the composition, structure, and properties of matter.',
        topics: [
          'Atomic Structure',
          'Chemical Bonding',
          'Organic Chemistry',
          'Inorganic Chemistry',
          'Biochemistry',
          'Chemical Reactions',
        ],
      ),
      SyllabusModel(
        id: 'cs-101',
        title: 'Computer Science',
        description: 'Master programming, algorithms, and software development.',
        topics: [
          'Programming Fundamentals',
          'Data Structures',
          'Algorithms',
          'Object-Oriented Programming',
          'Database Systems',
          'Web Development',
          'Software Engineering',
        ],
      ),
    ];
  }

  /// Seed default courses if collection is empty
  Future<void> seedDefaultCourses() async {
    try {
      // Check if courses already exist
      final existingCourses = await _firebaseService.getDocuments('syllabi');
      
      if (existingCourses.isNotEmpty) {
        Logger.info('Courses already exist, skipping seed');
        return;
      }

      Logger.info('Seeding default courses...');
      final defaultCourses = getDefaultCourses();

      for (final course in defaultCourses) {
        // Use setDocument to preserve the course ID
        final courseData = course.toJson();
        courseData.remove('id'); // Remove id from data as it's used as document ID
        await _firebaseService.setDocument('syllabi', course.id, courseData);
        Logger.info('Seeded course: ${course.title}');
      }

      Logger.info('Successfully seeded ${defaultCourses.length} default courses');
    } catch (e, stackTrace) {
      Logger.error('Error seeding default courses', e, stackTrace);
      rethrow;
    }
  }
}

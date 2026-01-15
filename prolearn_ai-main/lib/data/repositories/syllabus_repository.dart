import '../models/syllabus_model.dart';
import '../services/firebase_service.dart';

class SyllabusRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<SyllabusModel>> getSyllabi() async {
    final docs = await _firebaseService.getDocuments('syllabi');
    return docs.map((doc) {
      final data = doc;
      // Ensure id is included
      if (!data.containsKey('id') || data['id'] == null || data['id'] == '') {
        // If no id in data, try to get from document reference
        // For now, generate a temporary id or use title as fallback
        data['id'] = data['title']?.toString().toLowerCase().replaceAll(' ', '-') ?? 'unknown';
      }
      return SyllabusModel.fromJson(data);
    }).toList();
  }

  Future<void> saveSyllabus(SyllabusModel syllabus) async {
    await _firebaseService.addDocument('syllabi', syllabus.toJson());
  }
}

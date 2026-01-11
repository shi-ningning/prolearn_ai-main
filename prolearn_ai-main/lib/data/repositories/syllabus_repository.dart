import '../models/syllabus_model.dart';
import '../services/firebase_service.dart';

class SyllabusRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<SyllabusModel>> getSyllabi() async {
    final docs = await _firebaseService.getDocuments('syllabi');
    return docs.map((doc) => SyllabusModel.fromJson(doc)).toList();
  }

  Future<void> saveSyllabus(SyllabusModel syllabus) async {
    await _firebaseService.addDocument('syllabi', syllabus.toJson());
  }
}

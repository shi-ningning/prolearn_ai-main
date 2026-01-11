import '../models/task_model.dart';
import '../services/firebase_service.dart';

class TaskRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<TaskModel>> getTasks(String userId) async {
    final docs = await _firebaseService.getDocuments('tasks');
    return docs.where((doc) => doc['userId'] == userId).map((doc) => TaskModel.fromJson(doc)).toList();
  }

  Future<void> saveTask(TaskModel task) async {
    await _firebaseService.addDocument('tasks', task.toJson());
  }
}

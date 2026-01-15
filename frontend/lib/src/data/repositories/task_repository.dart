import '../models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/logger.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      // Try query with orderBy first (requires index)
      try {
        final QuerySnapshot snapshot = await _firestore
            .collection('tasks')
            .where('userId', isEqualTo: userId)
            .orderBy('dueDate', descending: false)
            .get();
        
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return TaskModel.fromJson(data);
        }).toList();
      } on FirebaseException catch (e) {
        // If index error, fall back to query without orderBy
        if (e.code == 'failed-precondition') {
          Logger.warning('Firestore index not found, using fallback query');
          final QuerySnapshot snapshot = await _firestore
              .collection('tasks')
              .where('userId', isEqualTo: userId)
              .get();
          
          final tasks = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return TaskModel.fromJson(data);
          }).toList();
          
          // Sort in memory
          tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
          return tasks;
        }
        rethrow;
      }
    } catch (e, stackTrace) {
      Logger.error('Error loading tasks', e, stackTrace);
      return [];
    }
  }

  /// Get real-time stream of tasks for a user
  Stream<List<TaskModel>> getTasksStream(String userId) {
    // Use query without orderBy to avoid index requirement
    // Sort in memory instead
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final tasks = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return TaskModel.fromJson(data);
      }).toList();
      
      // Sort by due date in memory
      tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
      return tasks;
    }).handleError((error) {
      Logger.error('Error in tasks stream', error);
      return <TaskModel>[];
    });
  }

  Future<String> saveTask(TaskModel task) async {
    try {
      final docRef = await _firestore.collection('tasks').add(task.toJson());
      return docRef.id;
    } catch (e, stackTrace) {
      Logger.error('Error saving task', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _firestore.collection('tasks').doc(task.id).update(task.toJson());
    } catch (e, stackTrace) {
      Logger.error('Error updating task', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e, stackTrace) {
      Logger.error('Error deleting task', e, stackTrace);
      rethrow;
    }
  }
}

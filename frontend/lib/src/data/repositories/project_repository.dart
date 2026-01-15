import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../../utils/logger.dart';

class ProjectRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'projects';

  // Get all projects for a user
  Stream<List<ProjectModel>> getProjectsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProjectModel.fromJson(data);
      }).toList();
    });
  }

  // Get a single project
  Future<ProjectModel?> getProject(String projectId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(projectId).get();
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return ProjectModel.fromJson(data);
      }
      return null;
    } catch (e) {
      Logger.error('Error getting project: $e');
      return null;
    }
  }

  // Create a new project
  Future<String?> createProject(ProjectModel project) async {
    try {
      final docRef = await _firestore.collection(_collection).add(project.toJson());
      Logger.info('Project created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      Logger.error('Error creating project: $e');
      return null;
    }
  }

  // Update a project
  Future<bool> updateProject(String projectId, ProjectModel project) async {
    try {
      await _firestore.collection(_collection).doc(projectId).update(project.toJson());
      Logger.info('Project updated: $projectId');
      return true;
    } catch (e) {
      Logger.error('Error updating project: $e');
      return false;
    }
  }

  // Delete a project
  Future<bool> deleteProject(String projectId) async {
    try {
      await _firestore.collection(_collection).doc(projectId).delete();
      Logger.info('Project deleted: $projectId');
      return true;
    } catch (e) {
      Logger.error('Error deleting project: $e');
      return false;
    }
  }

  // Update project progress
  Future<bool> updateProgress(String projectId, int progress) async {
    try {
      await _firestore.collection(_collection).doc(projectId).update({
        'progress': progress.clamp(0, 100),
      });
      return true;
    } catch (e) {
      Logger.error('Error updating project progress: $e');
      return false;
    }
  }

  // Update project status
  Future<bool> updateStatus(String projectId, ProjectStatus status) async {
    try {
      final Map<String, dynamic> updates = {
        'status': status.name,
      };
      
      if (status == ProjectStatus.completed) {
        updates['completedAt'] = DateTime.now().toIso8601String();
        updates['progress'] = 100;
      }
      
      await _firestore.collection(_collection).doc(projectId).update(updates);
      return true;
    } catch (e) {
      Logger.error('Error updating project status: $e');
      return false;
    }
  }
}

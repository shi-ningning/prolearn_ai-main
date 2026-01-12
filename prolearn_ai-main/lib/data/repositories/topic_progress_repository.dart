import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/topic_progress_model.dart';
import '../../core/utils/logger.dart';

class TopicProgressRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get real-time stream of topic progress for a user and syllabus
  Stream<List<TopicProgressModel>> getTopicProgressStream(
    String userId,
    String syllabusId,
  ) {
    return _firestore
        .collection('topicProgress')
        .where('userId', isEqualTo: userId)
        .where('syllabusId', isEqualTo: syllabusId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TopicProgressModel.fromJson(data);
      }).toList();
    });
  }

  /// Get all topic progress for a user
  Stream<List<TopicProgressModel>> getAllTopicProgressStream(String userId) {
    return _firestore
        .collection('topicProgress')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return TopicProgressModel.fromJson(data);
      }).toList();
    });
  }

  /// Toggle topic completion
  Future<void> toggleTopicCompletion(
    String userId,
    String syllabusId,
    String topicName,
    bool isCompleted,
  ) async {
    try {
      // Find existing progress document
      final query = await _firestore
          .collection('topicProgress')
          .where('userId', isEqualTo: userId)
          .where('syllabusId', isEqualTo: syllabusId)
          .where('topicName', isEqualTo: topicName)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        // Update existing
        await query.docs.first.reference.update({
          'isCompleted': isCompleted,
          'completedAt': isCompleted ? DateTime.now().toIso8601String() : null,
        });
      } else {
        // Create new
        final progress = TopicProgressModel(
          id: '',
          userId: userId,
          syllabusId: syllabusId,
          topicName: topicName,
          isCompleted: isCompleted,
          completedAt: isCompleted ? DateTime.now() : null,
        );
        await _firestore
            .collection('topicProgress')
            .add(progress.toJson());
      }
      Logger.info('Topic progress updated: $topicName - $isCompleted');
    } catch (e, stackTrace) {
      Logger.error('Error toggling topic completion', e, stackTrace);
      rethrow;
    }
  }

  /// Get completed topics for a syllabus
  Future<List<String>> getCompletedTopics(
    String userId,
    String syllabusId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('topicProgress')
          .where('userId', isEqualTo: userId)
          .where('syllabusId', isEqualTo: syllabusId)
          .where('isCompleted', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['topicName'] as String)
          .toList();
    } catch (e, stackTrace) {
      Logger.error('Error getting completed topics', e, stackTrace);
      return [];
    }
  }
}

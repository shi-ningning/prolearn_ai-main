import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/topic_progress_model.dart';
import '../../data/repositories/topic_progress_repository.dart';
import '../../utils/logger.dart';

class TopicProgressProvider with ChangeNotifier {
  final TopicProgressRepository _repository = TopicProgressRepository();
  List<TopicProgressModel> _allProgress = [];
  final Map<String, List<TopicProgressModel>> _progressBySyllabus = {};
  bool _isLoading = false;

  List<TopicProgressModel> get allProgress => _allProgress;
  bool get isLoading => _isLoading;

  /// Get completed topics for a syllabus
  List<String> getCompletedTopics(String syllabusId) {
    return _allProgress
        .where((p) => p.syllabusId == syllabusId && p.isCompleted)
        .map((p) => p.topicName)
        .toList();
  }

  /// Check if a topic is completed
  bool isTopicCompleted(String syllabusId, String topicName) {
    return _allProgress.any(
      (p) =>
          p.syllabusId == syllabusId &&
          p.topicName == topicName &&
          p.isCompleted,
    );
  }

  /// Get progress percentage for a syllabus
  int getSyllabusProgress(String syllabusId, int totalTopics) {
    if (totalTopics == 0) return 0;
    final completed = getCompletedTopics(syllabusId).length;
    return ((completed / totalTopics) * 100).round();
  }

  /// Initialize real-time listener for topic progress
  void initializeProgressStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Logger.warning('No user found, cannot initialize progress stream');
      return;
    }

    _isLoading = true;
    notifyListeners();

    _repository
        .getAllTopicProgressStream(user.uid)
        .listen(
          (progressList) {
            _allProgress = progressList;
            _updateProgressBySyllabus();
            _isLoading = false;
            notifyListeners();
            Logger.info('Updated topic progress: ${progressList.length} items');
          },
          onError: (error) {
            Logger.error('Error in progress stream', error);
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  void _updateProgressBySyllabus() {
    _progressBySyllabus.clear();
    for (final progress in _allProgress) {
      if (!_progressBySyllabus.containsKey(progress.syllabusId)) {
        _progressBySyllabus[progress.syllabusId] = [];
      }
      _progressBySyllabus[progress.syllabusId]!.add(progress);
    }
  }

  /// Toggle topic completion
  Future<void> toggleTopicCompletion(
    String syllabusId,
    String topicName,
    bool isCompleted,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _repository.toggleTopicCompletion(
        user.uid,
        syllabusId,
        topicName,
        isCompleted,
      );
      // Stream will automatically update the UI
    } catch (e, stackTrace) {
      Logger.error('Error toggling topic completion', e, stackTrace);
      rethrow;
    }
  }
}

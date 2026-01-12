class TopicProgressModel {
  final String id;
  final String userId;
  final String syllabusId;
  final String topicName;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;

  TopicProgressModel({
    required this.id,
    required this.userId,
    required this.syllabusId,
    required this.topicName,
    this.isCompleted = false,
    this.completedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TopicProgressModel.fromJson(Map<String, dynamic> json) {
    return TopicProgressModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      syllabusId: json['syllabusId'] ?? '',
      topicName: json['topicName'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'syllabusId': syllabusId,
      'topicName': topicName,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  TopicProgressModel copyWith({
    String? id,
    String? userId,
    String? syllabusId,
    String? topicName,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return TopicProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      syllabusId: syllabusId ?? this.syllabusId,
      topicName: topicName ?? this.topicName,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

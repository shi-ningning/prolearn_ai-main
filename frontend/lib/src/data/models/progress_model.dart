class ProgressModel {
  final String id;
  final String userId;
  final String syllabusId;
  final double percentage;

  ProgressModel({
    required this.id,
    required this.userId,
    required this.syllabusId,
    required this.percentage,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'],
      userId: json['userId'],
      syllabusId: json['syllabusId'],
      percentage: json['percentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'syllabusId': syllabusId,
      'percentage': percentage,
    };
  }
}

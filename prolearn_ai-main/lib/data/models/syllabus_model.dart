class SyllabusModel {
  final String id;
  final String title;
  final String description;
  final List<String> topics;

  SyllabusModel({
    required this.id,
    required this.title,
    required this.description,
    required this.topics,
  });

  factory SyllabusModel.fromJson(Map<String, dynamic> json) {
    return SyllabusModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      topics: List<String>.from(json['topics']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'topics': topics,
    };
  }
}

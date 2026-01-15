enum ProjectStatus { active, completed, onHold, archived }
enum ProjectPriority { low, medium, high, critical }

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final ProjectStatus status;
  final ProjectPriority priority;
  final String userId;
  final DateTime createdAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final int progress; // 0-100
  final List<String> tags;
  final String? color; // Hex color for visual identification

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.status = ProjectStatus.active,
    this.priority = ProjectPriority.medium,
    required this.userId,
    DateTime? createdAt,
    this.dueDate,
    this.completedAt,
    this.progress = 0,
    this.tags = const [],
    this.color,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] != null
          ? ProjectStatus.values.firstWhere(
              (s) => s.name == json['status'],
              orElse: () => ProjectStatus.active,
            )
          : ProjectStatus.active,
      priority: json['priority'] != null
          ? ProjectPriority.values.firstWhere(
              (p) => p.name == json['priority'],
              orElse: () => ProjectPriority.medium,
            )
          : ProjectPriority.medium,
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      progress: json['progress'] ?? 0,
      tags: json['tags'] != null
          ? List<String>.from(json['tags'])
          : [],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'progress': progress,
      'tags': tags,
      'color': color,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    ProjectStatus? status,
    ProjectPriority? priority,
    String? userId,
    DateTime? createdAt,
    DateTime? dueDate,
    DateTime? completedAt,
    int? progress,
    List<String>? tags,
    String? color,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      progress: progress ?? this.progress,
      tags: tags ?? this.tags,
      color: color ?? this.color,
    );
  }
}

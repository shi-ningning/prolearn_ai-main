import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;

  const TaskTile({
    super.key,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyles.body),
      subtitle: Text(description, style: TextStyles.caption),
      trailing: Icon(
        isCompleted ? Icons.check_circle : Icons.circle,
        color: isCompleted ? AppColors.primary : AppColors.onSurface,
      ),
    );
  }
}

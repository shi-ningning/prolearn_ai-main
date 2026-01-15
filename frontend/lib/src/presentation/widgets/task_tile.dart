import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../theme/text_styles.dart';

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
      title: Text(title, style: TextStyles.body(context)),
      subtitle: Text(description, style: TextStyles.caption(context)),
      trailing: Icon(
        isCompleted ? Icons.check_circle : Icons.circle,
        color: isCompleted
            ? AppColors.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

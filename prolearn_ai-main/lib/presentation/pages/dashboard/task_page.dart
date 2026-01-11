import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppText.tasks,
          style: TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        shadowColor: AppColors.shadow,
        iconTheme: IconThemeData(color: AppColors.onPrimary),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Tasks', style: TextStyles.headline),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskCard('Complete Math Assignment', 'Due tomorrow', AppColors.secondary, false),
                  _buildTaskCard('Study Physics Chapter 5', 'Due in 3 days', AppColors.primary, false),
                  _buildTaskCard('Review Chemistry Notes', 'Completed', AppColors.tertiary, true),
                  _buildTaskCard('Practice Coding Problems', 'Due next week', AppColors.primary, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, String subtitle, Color color, bool completed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            completed ? Icons.check_circle : Icons.assignment,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyles.body.copyWith(
            decoration: completed ? TextDecoration.lineThrough : null,
            color: completed ? AppColors.onSurface.withOpacity(0.6) : null,
          ),
        ),
        subtitle: Text(subtitle, style: TextStyles.caption),
        trailing: IconButton(
          icon: Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? AppColors.tertiary : AppColors.onSurface,
          ),
          onPressed: () {
            // TODO: Toggle task completion
          },
        ),
      ),
    );
  }
}

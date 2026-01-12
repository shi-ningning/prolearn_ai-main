import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/animated_card.dart';
import '../../state/syllabus_provider.dart';
import '../../state/task_provider.dart';
import '../../state/topic_progress_provider.dart';
import '../../../data/models/syllabus_model.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final taskProvider = context.read<TaskProvider>();
      // Only load if tasks are empty to avoid unnecessary calls
      if (taskProvider.allTasks.isEmpty) {
        await taskProvider.loadTasks(user.uid);
      }
    }
  }

  int _calculateProgress(
    SyllabusModel syllabus,
    TaskProvider taskProvider,
    TopicProgressProvider progressProvider,
  ) {
    // Use topic progress as primary source (more accurate)
    final totalTopics = syllabus.topics.length;
    if (totalTopics == 0) return 0;

    final progress = progressProvider.getSyllabusProgress(syllabus.id, totalTopics);
    
    // If no topic progress, fall back to task-based calculation
    if (progress == 0) {
      // Get all tasks (completed and pending)
      final allTasks = taskProvider.allTasks;
      
      // If no tasks at all, return 0%
      if (allTasks.isEmpty) {
        return 0;
      }
      
      // Create subject keywords for matching
      final subjectKeywords = [
        syllabus.title.toLowerCase(),
        ...syllabus.title.toLowerCase().split(' ').where((w) => w.length > 3),
        ...syllabus.topics.map((t) => t.toLowerCase()),
      ];
      
      // Count tasks related to this subject
      int matchingCompletedTasks = 0;
      int matchingTotalTasks = 0;
      
      for (final task in allTasks) {
        final taskText = '${task.title} ${task.description}'.toLowerCase();
        final isRelated = subjectKeywords.any((keyword) => 
          keyword.length > 2 && taskText.contains(keyword)
        );
        
        if (isRelated) {
          matchingTotalTasks++;
          if (task.isCompleted) {
            matchingCompletedTasks++;
          }
        }
      }
      
      // If no matching tasks, return 0%
      if (matchingTotalTasks == 0) {
        return 0;
      }
      
      // Calculate progress: completed matching tasks / total matching tasks
      return ((matchingCompletedTasks / matchingTotalTasks) * 100).round().clamp(0, 100);
    }
    
    return progress;
  }

  String _getProgressMessage(int percentage) {
    if (percentage == 0) {
      return 'Start your learning journey!';
    } else if (percentage < 25) {
      return 'Great start! Keep going!';
    } else if (percentage < 50) {
      return 'You\'re making progress!';
    } else if (percentage < 75) {
      return 'Keep up the great work!';
    } else if (percentage < 100) {
      return 'Almost there! You\'re doing amazing!';
    } else {
      return 'Excellent! You\'ve completed this subject!';
    }
  }

  Color _getProgressColor(int percentage) {
    if (percentage == 0) {
      return AppColors.onSurface.withValues(alpha: 0.3);
    } else if (percentage < 50) {
      return AppColors.secondary;
    } else if (percentage < 75) {
      return AppColors.primary;
    } else {
      return AppColors.tertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        showParticles: true,
        child: _buildScaffold(context),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          AppText.progress,
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
      body: Consumer<SyllabusProvider>(
        builder: (context, syllabusProvider, child) {
          final syllabi = syllabusProvider.syllabi;

          if (syllabi.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 80,
                      color: AppColors.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No subjects available',
                      style: TextStyles.headline.copyWith(
                        color: AppColors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Subjects will appear here once they are added',
                      style: TextStyles.body.copyWith(
                        color: AppColors.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Progress', style: TextStyles.headline),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Consumer2<TaskProvider, TopicProgressProvider>(
                      builder: (context, taskProvider, progressProvider, child) {
                        return ListView.builder(
                          itemCount: syllabi.length,
                          itemBuilder: (context, index) {
                            final syllabus = syllabi[index];
                            final progress = _calculateProgress(
                              syllabus,
                              taskProvider,
                              progressProvider,
                            );
                            final color = _getProgressColor(progress);
                            
                            return _buildProgressCard(
                              syllabus.title,
                              progress,
                              color,
                              _getProgressMessage(progress),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(String subject, int percentage, Color color, String message) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        // Navigate to learning page for this subject
        Navigator.pushNamed(context, '/learning');
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subject,
                    style: TextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percentage%',
                  style: TextStyles.body.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyles.caption.copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

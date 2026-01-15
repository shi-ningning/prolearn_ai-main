import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text.dart';
import '../../../theme/text_styles.dart';
import '../../widgets/sidebar.dart';
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

  String _getProgressMessage(BuildContext context, int percentage) {
    if (percentage == 0) {
      return AppText.of(context).progressStart;
    } else if (percentage < 25) {
      return AppText.of(context).progressGreatStart;
    } else if (percentage < 50) {
      return AppText.of(context).progressMaking;
    } else if (percentage < 75) {
      return AppText.of(context).progressKeepUp;
    } else if (percentage < 100) {
      return AppText.of(context).progressAlmost;
    } else {
      return AppText.of(context).progressComplete;
    }
  }

  Color _getProgressColor(BuildContext context, int percentage) {
    if (percentage == 0) {
      return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3);
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
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ProLearn',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorScheme.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: colorScheme.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Text(
              AppText.of(context).progress,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withOpacity(0.6),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorScheme.primary,
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
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
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppText.of(context).noSubjectsAvailable,
                    style: TextStyles.headline(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppText.of(context).subjectsWillAppear,
                      style: TextStyles.body(context).copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
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
                  Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  AppText.of(context).yourProgress,
                  style: TextStyles.headline(context).copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
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
                            final color = _getProgressColor(context, progress);
                            
                            return _buildProgressCard(
                              syllabus.title,
                              progress,
                              color,
                              _getProgressMessage(context, progress),
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
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () {
        // Navigate to learning page for this subject
        Navigator.pushNamed(context, '/learning');
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subject,
                    style: TextStyles.titleMedium(context).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$percentage%',
                    style: TextStyles.body(context).copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: color.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyles.caption(context).copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/animated_card.dart';
import '../../state/task_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await context.read<TaskProvider>().loadTasks(user.uid);
    }
  }
  Widget _buildStatCard(String title, String value, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 80 : 100,
        maxWidth: isSmallScreen ? 120 : 150,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: const Color.fromARGB(255, 97, 150, 224),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () {
        // Add interaction feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Viewing: $title'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyles.body),
        subtitle: Text(time, style: TextStyles.caption),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurface),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
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
          AppText.dashboard,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: const Sidebar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          final padding = isSmallScreen ? 16.0 : 24.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ProLearn AI',
                    style: TextStyles.headline.copyWith(
                      fontSize: isSmallScreen ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.analytics,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Quick Stats',
                                  style: TextStyles.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          Consumer<TaskProvider>(
                            builder: (context, taskProvider, child) {
                              final totalTasks = taskProvider.allTasks.length;
                              final completedTasks = taskProvider.completedTasks.length;
                              final progress = totalTasks > 0
                                  ? ((completedTasks / totalTasks) * 100).round()
                                  : 0;

                              return Wrap(
                                spacing: 12.0,
                                runSpacing: 12.0,
                                alignment: WrapAlignment.spaceEvenly,
                                children: [
                                  AnimatedStatCard(
                                    title: 'Tasks',
                                    value: '$totalTasks',
                                    color: AppColors.secondary,
                                    icon: Icons.assignment,
                                  ),
                                  AnimatedStatCard(
                                    title: 'Completed',
                                    value: '$completedTasks',
                                    color: AppColors.tertiary,
                                    icon: Icons.check_circle,
                                  ),
                                  AnimatedStatCard(
                                    title: 'Progress',
                                    value: '$progress%',
                                    color: AppColors.primary,
                                    icon: Icons.trending_up,
                                  ),
                                ],
                              );
                            },
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recent Activity',
                        style: TextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      final recentTasks = taskProvider.allTasks
                        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                      final displayTasks = recentTasks.take(3).toList();
                      
                      if (displayTasks.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No recent activity',
                            style: TextStyles.body.copyWith(
                              color: AppColors.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: displayTasks.length,
                        itemBuilder: (context, index) {
                          final task = displayTasks[index];
                          final timeAgo = _getTimeAgo(task.createdAt);
                          final icon = task.isCompleted 
                              ? Icons.check_circle 
                              : Icons.assignment;
                          final color = task.isCompleted 
                              ? AppColors.tertiary 
                              : AppColors.primary;
                          final title = task.isCompleted
                              ? 'Completed: ${task.title}'
                              : 'Created: ${task.title}';
                          
                          return _buildActivityItem(title, timeAgo, icon, color);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

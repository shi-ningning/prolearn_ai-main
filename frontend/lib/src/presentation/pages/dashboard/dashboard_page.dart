import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text.dart';
import '../../../theme/text_styles.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/animated_card.dart';
import '../../state/task_provider.dart';
import '../../../routes/app_routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

  Future<void> _loadTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await context.read<TaskProvider>().loadTasks(user.uid);
    }
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return AnimatedCard(
      margin: const EdgeInsets.only(bottom: 8),
      onTap: () {
        // Add interaction feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppText.of(context, listen: false).viewing}: $title',
            ),
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
        title: Text(title, style: TextStyles.body(context)),
        subtitle: Text(time, style: TextStyles.caption(context)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return AppText.of(context).timeAgoDays(difference.inDays);
    } else if (difference.inHours > 0) {
      return AppText.of(context).timeAgoHours(difference.inHours);
    } else if (difference.inMinutes > 0) {
      return AppText.of(context).timeAgoMinutes(difference.inMinutes);
    } else {
      return AppText.of(context).justNow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
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
              AppText.of(context).dashboard,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      FirebaseAuth.instance.currentUser?.displayName
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'U',
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
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
      ),
      drawer: const Sidebar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 800;
          final isMobile = constraints.maxWidth < 600;
          final padding = isMobile ? 12.0 : (isSmallScreen ? 16.0 : 24.0);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Quick Stats (stacked vertically)
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      final totalTasks = taskProvider.allTasks.length;
                      final completedTasks = taskProvider.completedTasks.length;
                      final progress = totalTasks > 0
                          ? ((completedTasks / totalTasks) * 100).round()
                          : 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedStatCard(
                            title: AppText.of(context).tasksLabel,
                            value: '$totalTasks',
                            color: AppColors.secondary,
                            icon: Icons.assignment,
                          ),
                          const SizedBox(height: 12),
                          AnimatedStatCard(
                            title: AppText.of(context).completedLabel,
                            value: '$completedTasks',
                            color: AppColors.tertiary,
                            icon: Icons.check_circle,
                          ),
                          const SizedBox(height: 12),
                          AnimatedStatCard(
                            title: AppText.of(context).progressLabel,
                            value: '$progress%',
                            color: AppColors.primary,
                            icon: Icons.trending_up,
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),

                  /// Recent Activity Header
                  Text(
                    AppText.of(context).recentActivity,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : (isSmallScreen ? 20 : 24),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Recent Tasks - Stacked vertically
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      final recentTasks = taskProvider.allTasks
                        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                      final displayTasks = recentTasks.take(5).toList();

                      if (displayTasks.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            AppText.of(context).noRecentActivity,
                            style: TextStyles.body(context).copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: displayTasks.map((task) {
                          final timeAgo = _getTimeAgo(task.createdAt);
                          final icon = task.isCompleted
                              ? Icons.check_circle
                              : Icons.assignment;
                          final color = task.isCompleted
                              ? AppColors.tertiary
                              : AppColors.primary;
                          final title = task.isCompleted
                              ? '${AppText.of(context).completedPrefix}: ${task.title}'
                              : '${AppText.of(context).createdPrefix}: ${task.title}';

                          return _buildActivityItem(
                            title,
                            timeAgo,
                            icon,
                            color,
                          );
                        }).toList(),
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

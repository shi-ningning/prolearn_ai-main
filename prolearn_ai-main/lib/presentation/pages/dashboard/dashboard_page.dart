import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Widget _buildStatCard(String title, String value, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 80 : 100,
        maxWidth: isSmallScreen ? 120 : 150,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyles.body),
        subtitle: Text(time, style: TextStyles.caption),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurface),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppText.dashboard,
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
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quick Stats', style: TextStyles.titleLarge),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
                            alignment: WrapAlignment.spaceEvenly,
                            children: [
                              _buildStatCard('Tasks', '12', AppColors.secondary, isSmallScreen),
                              _buildStatCard('Completed', '8', AppColors.tertiary, isSmallScreen),
                              _buildStatCard('Progress', '67%', AppColors.primary, isSmallScreen),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  Text('Recent Activity', style: TextStyles.titleMedium),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final activities = [
                        ('Completed Math Quiz', '2 hours ago', Icons.check_circle, AppColors.tertiary),
                        ('Started Physics Lesson', '5 hours ago', Icons.play_circle, AppColors.secondary),
                        ('Updated Task List', '1 day ago', Icons.edit, AppColors.primary),
                      ];
                      final activity = activities[index];
                      return _buildActivityItem(activity.$1, activity.$2, activity.$3, activity.$4);
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

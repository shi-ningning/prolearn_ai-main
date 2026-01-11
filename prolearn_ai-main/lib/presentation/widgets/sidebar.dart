import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text.dart';
import '../../core/theme/text_styles.dart';
import '../../routes/app_routes.dart';
import '../../data/models/syllabus_model.dart';
import '../state/syllabus_provider.dart';
import '../state/app_auth_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Drawer(
          backgroundColor: AppColors.surface,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.surface,
                        size: isSmallScreen ? 24 : 28,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      AppText.appName,
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI-Powered Learning',
                      style: TextStyle(
                        color: AppColors.surface.withOpacity(0.8),
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
                  children: [
                    _buildSidebarItem(
                      context,
                      icon: Icons.dashboard,
                      title: AppText.dashboard,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.dashboard),
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.school,
                      title: AppText.learning,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.learning),
                      isSmallScreen: isSmallScreen,
                    ),
                    Consumer<SyllabusProvider>(
                      builder: (context, syllabusProvider, child) {
                        final syllabi = syllabusProvider.syllabi;
                        return Column(
                          children: syllabi.map((syllabus) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: _buildSyllabusItem(
                                context,
                                syllabus: syllabus,
                                isSmallScreen: isSmallScreen,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.task,
                      title: AppText.tasks,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.tasks),
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.bar_chart,
                      title: AppText.progress,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.settings,
                      title: AppText.settings,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                      isSmallScreen: isSmallScreen,
                    ),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context, isSmallScreen),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceVariant.withOpacity(0.5),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyles.body.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildSyllabusItem(
    BuildContext context, {
    required SyllabusModel syllabus,
    required bool isSmallScreen,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surfaceVariant.withOpacity(0.3),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondary.withOpacity(0.2),
                AppColors.tertiary.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            syllabus.title.isNotEmpty ? syllabus.title[0].toUpperCase() : 'S',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ),
        title: Text(
          syllabus.title,
          style: TextStyles.body.copyWith(
            fontSize: isSmallScreen ? 12 : 14,
            color: AppColors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${syllabus.topics.length} topics',
          style: TextStyles.caption.copyWith(
            color: AppColors.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.learning,
            arguments: syllabus,
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.error.withOpacity(0.1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.logout,
            color: AppColors.error,
            size: isSmallScreen ? 20 : 24,
          ),
        ),
        title: Text(
          'Logout',
          style: TextStyles.body.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => _showLogoutConfirmationDialog(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Logout',
            style: TextStyles.titleLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyles.body.copyWith(
              color: AppColors.onSurface.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _performLogout(context);
              },
              child: Text(
                'Logout',
                style: TextStyles.body.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    // Clear user session/authentication
    final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
    authProvider.logout();

    // Navigate to login page
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }
}

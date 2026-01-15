import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_text.dart';
import '../../routes/app_routes.dart';
import '../../data/models/syllabus_model.dart';
import '../state/syllabus_provider.dart';
import '../state/app_auth_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;

        return Drawer(
          backgroundColor: colorScheme.surface,
          child: Column(
            children: [
              // Simple header without gradient container
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'ProLearn',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'AI',
                          style: TextStyle(
                            color: colorScheme.secondary,
                            fontSize: isSmallScreen ? 24 : 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI-Powered Learning Platform',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: isSmallScreen ? 11 : 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
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
                      title: AppText.of(context).dashboard,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.dashboard),
                      isSmallScreen: isSmallScreen,
                    ),
                    // Learning - Expandable Dropdown
                    _buildExpandableItem(
                      context,
                      icon: Icons.school,
                      title: AppText.of(context).learning,
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.task,
                      title: AppText.of(context).tasks,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.tasks),
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.folder_outlined,
                      title: AppText.of(context).projects,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.projects),
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.bar_chart,
                      title: AppText.of(context).progress,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildSidebarItem(
                      context,
                      icon: Icons.settings,
                      title: AppText.of(context).settings,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
              ),
              // Logout button - sticky at bottom
              _buildLogoutButton(context, isSmallScreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandableItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSmallScreen,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Consumer<SyllabusProvider>(
      builder: (context, syllabusProvider, child) {
        final syllabi = syllabusProvider.syllabi;
        
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: 4,
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: Icon(
                icon,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                size: isSmallScreen ? 22 : 24,
              ),
              title: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              iconColor: colorScheme.primary,
              collapsedIconColor: colorScheme.onSurface.withValues(alpha: 0.6),
              tilePadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 20,
                vertical: 4,
              ),
              childrenPadding: EdgeInsets.only(
                left: isSmallScreen ? 32 : 40,
                bottom: 8,
              ),
            children: [
              // "All Courses" option
              ListTile(
                leading: Icon(
                  Icons.grid_view_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
                title: Text(
                  'All Courses',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, AppRoutes.learning),
                contentPadding: EdgeInsets.zero,
              ),
              // Individual syllabi
              ...syllabi.map((syllabus) {
                return ListTile(
                  leading: Text(
                    syllabus.title.isNotEmpty ? syllabus.title[0].toUpperCase() : 'S',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  title: Text(
                    syllabus.title,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    '${syllabus.topics.length} topics',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.learning,
                      arguments: syllabus,
                    );
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ],
            ),
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
    String? currentRoute,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentRouteName = ModalRoute.of(context)?.settings.name ?? '';
    final isActive = currentRouteName.contains(title.toLowerCase());
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 4,
      ),
      decoration: isActive ? BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ) : null,
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
          size: isSmallScreen ? 22 : 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: 8,
        ),
      ),
    );
  }

  Widget _buildSyllabusItem(
    BuildContext context, {
    required SyllabusModel syllabus,
    required bool isSmallScreen,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: 4,
      ),
      child: ListTile(
        leading: Text(
          syllabus.title.isNotEmpty ? syllabus.title[0].toUpperCase() : 'S',
          style: TextStyle(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        title: Text(
          syllabus.title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${syllabus.topics.length} topics',
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.learning,
            arguments: syllabus,
          );
        },
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: 4,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isSmallScreen) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: Icon(
          Icons.logout_rounded,
          color: colorScheme.error,
          size: isSmallScreen ? 22 : 24,
        ),
        title: Text(
          AppText.of(context).logout,
          style: TextStyle(
            color: colorScheme.error,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        onTap: () => _showLogoutConfirmationDialog(context),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: 8,
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppText.of(context).confirmLogout,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            AppText.of(context).logoutConfirmMessage,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                AppText.of(context).cancel,
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                _performLogout(context);
              },
              child: Text(
                AppText.of(context).logout,
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
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

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/theme/text_styles.dart';
import '../../widgets/sidebar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppText.settings,
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
            Text('Settings', style: TextStyles.headline),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsSection('Account', [
                    _buildSettingsItem('Profile', Icons.person, () {}),
                    _buildSettingsItem('Notifications', Icons.notifications, () {}),
                    _buildSettingsItem('Privacy', Icons.lock, () {}),
                  ]),
                  const SizedBox(height: 16),
                  _buildSettingsSection('Learning', [
                    _buildSettingsItem('Study Goals', Icons.track_changes, () {}),
                    _buildSettingsItem('Reminders', Icons.alarm, () {}),
                    _buildSettingsItem('AI Preferences', Icons.smart_toy, () {}),
                  ]),
                  const SizedBox(height: 16),
                  _buildSettingsSection('App', [
                    _buildSettingsItem('Theme', Icons.palette, () {}),
                    _buildSettingsItem('Language', Icons.language, () {}),
                    _buildSettingsItem('Help & Support', Icons.help, () {}),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles.titleLarge),
            const SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title, style: TextStyles.body),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

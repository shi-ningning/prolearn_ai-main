import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_text.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/profile_dialog.dart';
import '../../state/theme_provider.dart';
import '../../state/language_provider.dart';
import '../../../data/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _prefsStudentId = 'profile_student_id';
  static const _prefsSection = 'profile_section';
  static const _prefsCourse = 'profile_course';
  final FirebaseService _firebaseService = FirebaseService();
  
  // Notifications dropdown state
  bool _notificationsExpanded = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _taskReminders = true;
  
  bool _privacyExpanded = false;
  bool _shareProgress = false;
  bool _publicProfile = false;
  
  bool _themeExpanded = false;

  Future<Map<String, dynamic>> _loadProfileData(User? user) async {
    if (user == null) return const <String, dynamic>{};

    final firestoreData =
        await _firebaseService.getDocument('users', user.uid) ??
            const <String, dynamic>{};

    final prefs = await SharedPreferences.getInstance();
    final prefsStudentId = prefs.getString(_prefsStudentId) ?? '';
    final prefsSection = prefs.getString(_prefsSection) ?? '';
    final prefsCourse = prefs.getString(_prefsCourse) ?? '';

    final merged = <String, dynamic>{...firestoreData};
    merged['studentId'] = (firestoreData['studentId'] ?? '').toString().isNotEmpty
        ? firestoreData['studentId']
        : prefsStudentId;
    merged['section'] = (firestoreData['section'] ?? '').toString().isNotEmpty
        ? firestoreData['section']
        : prefsSection;
    merged['course'] = (firestoreData['course'] ?? '').toString().isNotEmpty
        ? firestoreData['course']
        : prefsCourse;

    // Backfill Firestore if missing values but prefs exist.
    if ((firestoreData['studentId'] ?? '').toString().isEmpty &&
        prefsStudentId.isNotEmpty) {
      merged['studentId'] = prefsStudentId;
    }
    if ((firestoreData['section'] ?? '').toString().isEmpty &&
        prefsSection.isNotEmpty) {
      merged['section'] = prefsSection;
    }
    if ((firestoreData['course'] ?? '').toString().isEmpty &&
        prefsCourse.isNotEmpty) {
      merged['course'] = prefsCourse;
    }

    if ((firestoreData['studentId'] ?? '').toString().isEmpty &&
            prefsStudentId.isNotEmpty ||
        (firestoreData['section'] ?? '').toString().isEmpty &&
            prefsSection.isNotEmpty ||
        (firestoreData['course'] ?? '').toString().isEmpty &&
            prefsCourse.isNotEmpty) {
      await _firebaseService.setDocument('users', user.uid, {
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'studentId': merged['studentId'] ?? '',
        'section': merged['section'] ?? '',
        'course': merged['course'] ?? '',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }

    return merged;
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: const Sidebar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 100,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: colorScheme.onPrimary,
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: colorScheme.onPrimary.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Student',
                  style: TextStyle(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 70),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            _buildSettingsItem(
                              AppText.of(context).profile,
                              Icons.person,
                              colorScheme.primary.withValues(alpha: 0.15),
                              () => _showProfileDialog(context),
                            ),
                            _buildNotificationsDropdown(context),
                            _buildPrivacyDropdown(context),
                            _buildThemeDropdown(context),
                            _buildSettingsItem(
                              AppText.of(context).helpSupport,
                              Icons.help,
                              colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                              () => _showHelpDialog(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: -60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _privacyExpanded = !_privacyExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.lock,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppText.of(context).privacy,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                  Icon(
                    _privacyExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 22,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          if (_privacyExpanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.of(context).privacySettings,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: Text(
                      AppText.of(context).shareProgress,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).shareProgressSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: _shareProgress,
                    onChanged: (value) {
                      setState(() {
                        _shareProgress = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Privacy settings saved'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: colorScheme.primary,
                  ),
                  SwitchListTile(
                    title: Text(
                      AppText.of(context).publicProfile,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).publicProfileSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: _publicProfile,
                    onChanged: (value) {
                      setState(() {
                        _publicProfile = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Privacy settings saved'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppText.of(context).dataManagement,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.download,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      AppText.of(context).exportData,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).exportDataSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppText.of(context, listen: false).exportData,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text(
                      AppText.of(context).deleteAccount,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    subtitle: Text(
                      AppText.of(context).deleteAccountSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    onTap: () {
                      _showDeleteAccountConfirmation(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _themeExpanded = !_themeExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.palette,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppText.of(context).theme,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                  Icon(
                    _themeExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 22,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          if (_themeExpanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  RadioListTile<AppThemeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppText.of(context).light,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).lightSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: AppThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppText.of(context, listen: false).themeChanged(value.name),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    activeColor: colorScheme.primary,
                  ),
                  RadioListTile<AppThemeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppText.of(context).dark,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).darkSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: AppThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppText.of(context, listen: false).themeChanged(value.name),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    activeColor: colorScheme.primary,
                  ),
                  RadioListTile<AppThemeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AppText.of(context).systemDefault,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).systemSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: AppThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppText.of(context, listen: false).themeChanged(value.name),
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    activeColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, Color iconBackgroundColor, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _notificationsExpanded = !_notificationsExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      AppText.of(context).notifications,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                  Icon(
                    _notificationsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    size: 22,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          if (_notificationsExpanded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      AppText.of(context).emailNotifications,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).emailNotificationsSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: _emailNotifications,
                    onChanged: (value) {
                      setState(() {
                        _emailNotifications = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppText.of(context, listen: false).notificationSettingsSaved,
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: colorScheme.primary,
                  ),
                  SwitchListTile(
                    title: Text(
                      AppText.of(context).pushNotifications,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).pushNotificationsSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: _pushNotifications,
                    onChanged: (value) {
                      setState(() {
                        _pushNotifications = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppText.of(context, listen: false).notificationSettingsSaved,
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: colorScheme.primary,
                  ),
                  SwitchListTile(
                    title: Text(
                      AppText.of(context).taskRemindersLabel,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      AppText.of(context).taskRemindersSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    value: _taskReminders,
                    onChanged: (value) {
                      setState(() {
                        _taskReminders = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppText.of(context, listen: false).notificationSettingsSaved,
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.zero,
                    activeColor: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Profile Bottom Sheet
  void _showProfileDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileDialog(
        user: user,
        firebaseService: _firebaseService,
      ),
    );
  }

  // Notifications Dialog
  void _showNotificationsDialog(BuildContext context) {
    bool emailNotifications = true;
    bool pushNotifications = true;
    bool taskReminders = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppText.of(context).notificationsTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text(AppText.of(context).emailNotifications),
                  subtitle: Text(AppText.of(context).emailNotificationsSubtitle),
                  value: emailNotifications,
                  onChanged: (value) {
                    setState(() => emailNotifications = value);
                  },
                ),
                SwitchListTile(
                  title: Text(AppText.of(context).pushNotifications),
                  subtitle: Text(AppText.of(context).pushNotificationsSubtitle),
                  value: pushNotifications,
                  onChanged: (value) {
                    setState(() => pushNotifications = value);
                  },
                ),
                SwitchListTile(
                  title: Text(AppText.of(context).taskRemindersLabel),
                  subtitle: Text(AppText.of(context).taskRemindersSubtitle),
                  value: taskReminders,
                  onChanged: (value) {
                    setState(() => taskReminders = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false).notificationSettingsSaved,
                    ),
                  ),
                );
              },
              child: Text(AppText.of(context).save),
            ),
          ],
        ),
      ),
    );
  }

  // Privacy Dialog
  void _showPrivacyDialog(BuildContext context) {
    bool shareProgress = false;
    bool publicProfile = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppText.of(context).privacyTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.of(context).privacySettings,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(AppText.of(context).shareProgress),
                  subtitle: Text(AppText.of(context).shareProgressSubtitle),
                  value: shareProgress,
                  onChanged: (value) {
                    setState(() => shareProgress = value);
                  },
                ),
                SwitchListTile(
                  title: Text(AppText.of(context).publicProfile),
                  subtitle: Text(AppText.of(context).publicProfileSubtitle),
                  value: publicProfile,
                  onChanged: (value) {
                    setState(() => publicProfile = value);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  AppText.of(context).dataManagement,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: Text(AppText.of(context).exportData),
                  subtitle: Text(AppText.of(context).exportDataSubtitle),
                  trailing: const Icon(Icons.download),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppText.of(context, listen: false).exportData,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(AppText.of(context).deleteAccount),
                  subtitle: Text(AppText.of(context).deleteAccountSubtitle),
                  trailing: const Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    _showDeleteAccountConfirmation(context);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).close),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.of(context).deleteAccount),
        content: Text(AppText.of(context).deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppText.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false).accountDeletionRequested,
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppText.of(context).deleteAccount),
          ),
        ],
      ),
    );
  }

  // Study Goals Dialog
  void _showStudyGoalsDialog(BuildContext context) {
    final hoursController = TextEditingController(text: '2');
    final daysController = TextEditingController(text: '5');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.of(context).studyGoalsTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppText.of(context).dailyStudyGoals),
              const SizedBox(height: 16),
              TextField(
                controller: hoursController,
                decoration: InputDecoration(
                  labelText: AppText.of(context).dailyStudyHours,
                  border: const OutlineInputBorder(),
                  suffixText: AppText.of(context).hours,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: daysController,
                decoration: InputDecoration(
                  labelText: AppText.of(context).studyDaysPerWeek,
                  border: const OutlineInputBorder(),
                  suffixText: AppText.of(context).days,
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppText.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppText.of(context, listen: false).studyGoalsSet(
                      hoursController.text,
                      daysController.text,
                    ),
                  ),
                ),
              );
            },
            child: Text(AppText.of(context).save),
          ),
        ],
      ),
    );
  }

  // Reminders Dialog
  void _showRemindersDialog(BuildContext context) {
    TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);
    bool dailyReminder = true;
    bool taskReminder = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppText.of(context).remindersTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text(AppText.of(context).dailyReminder),
                  subtitle: Text(AppText.of(context).dailyReminderSubtitle),
                  value: dailyReminder,
                  onChanged: (value) {
                    setState(() => dailyReminder = value);
                  },
                ),
                SwitchListTile(
                  title: Text(AppText.of(context).taskReminders),
                  subtitle: Text(AppText.of(context).taskRemindersSubtitle),
                  value: taskReminder,
                  onChanged: (value) {
                    setState(() => taskReminder = value);
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(AppText.of(context).reminderTime),
                  subtitle: Text('${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setState(() => selectedTime = time);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false).reminderSettingsSaved,
                    ),
                  ),
                );
              },
              child: Text(AppText.of(context).save),
            ),
          ],
        ),
      ),
    );
  }

  // AI Preferences Dialog
  void _showAIPreferencesDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String aiLevel = AppText.of(context).medium;
    bool personalizedSuggestions = true;
    bool autoTaskGeneration = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppText.of(context).aiPreferencesTitle,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.of(context).aiAssistanceLevel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: aiLevel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: AppText.of(context).low,
                      child: Text(AppText.of(context).low),
                    ),
                    DropdownMenuItem(
                      value: AppText.of(context).medium,
                      child: Text(AppText.of(context).medium),
                    ),
                    DropdownMenuItem(
                      value: AppText.of(context).high,
                      child: Text(AppText.of(context).high),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => aiLevel = value ?? AppText.of(context).medium);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(AppText.of(context).personalizedSuggestions),
                  subtitle:
                      Text(AppText.of(context).personalizedSuggestionsSubtitle),
                  value: personalizedSuggestions,
                  onChanged: (value) {
                    setState(() => personalizedSuggestions = value);
                  },
                ),
                SwitchListTile(
                  title: Text(AppText.of(context).autoTaskGeneration),
                  subtitle:
                      Text(AppText.of(context).autoTaskGenerationSubtitle),
                  value: autoTaskGeneration,
                  onChanged: (value) {
                    setState(() => autoTaskGeneration = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false).aiPreferencesSaved,
                    ),
                  ),
                );
              },
              child: Text(AppText.of(context).save),
            ),
          ],
        ),
      ),
    );
  }

  // Theme Dialog
  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    AppThemeMode currentMode = themeProvider.themeMode;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppText.of(context).themeTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppThemeMode>(
                title: Text(AppText.of(context).light),
                subtitle: Text(AppText.of(context).lightSubtitle),
                value: AppThemeMode.light,
                groupValue: currentMode,
                onChanged: (value) {
                  setState(() => currentMode = value!);
                },
              ),
              RadioListTile<AppThemeMode>(
                title: Text(AppText.of(context).dark),
                subtitle: Text(AppText.of(context).darkSubtitle),
                value: AppThemeMode.dark,
                groupValue: currentMode,
                onChanged: (value) {
                  setState(() => currentMode = value!);
                },
              ),
              RadioListTile<AppThemeMode>(
                title: Text(AppText.of(context).systemDefault),
                subtitle: Text(AppText.of(context).systemSubtitle),
                value: AppThemeMode.system,
                groupValue: currentMode,
                onChanged: (value) {
                  setState(() => currentMode = value!);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                themeProvider.setThemeMode(currentMode);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false)
                          .themeChanged(currentMode.name),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(AppText.of(context).apply),
            ),
          ],
        ),
      ),
    );
  }

  // Language Dialog
  void _showLanguageDialog(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    AppLanguage selectedLanguage = languageProvider.language;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppText.of(context).languageTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<AppLanguage>(
                title: Text(languageProvider.labelFor(AppLanguage.english)),
                value: AppLanguage.english,
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedLanguage = value);
                },
              ),
              RadioListTile<AppLanguage>(
                title: Text(languageProvider.labelFor(AppLanguage.filipino)),
                value: AppLanguage.filipino,
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedLanguage = value);
                },
              ),
              RadioListTile<AppLanguage>(
                title: Text(languageProvider.labelFor(AppLanguage.bisaya)),
                value: AppLanguage.bisaya,
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedLanguage = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppText.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                languageProvider.setLanguage(selectedLanguage);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false).languageChanged(
                        languageProvider.labelFor(selectedLanguage),
                      ),
                    ),
                  ),
                );
              },
              child: Text(AppText.of(context).apply),
            ),
          ],
        ),
      ),
    );
  }

  // Help & Support Dialog
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.of(context).helpSupportTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.of(context).getHelp,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.book),
                title: Text(AppText.of(context).documentation),
                subtitle: Text(AppText.of(context).documentationSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppText.of(context, listen: false).openingDocumentation,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: Text(AppText.of(context).contactSupport),
                subtitle: Text(AppText.of(context).contactSupportSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppText.of(context, listen: false).openingEmail,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: Text(AppText.of(context).reportBug),
                subtitle: Text(AppText.of(context).reportBugSubtitle),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppText.of(context, listen: false).openingBugReport,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                AppText.of(context).about,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                title: Text(AppText.of(context).version),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                title: Text(AppText.of(context).appName),
                subtitle: Text(AppText.of(context).appTagline),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppText.of(context).close),
          ),
        ],
      ),
    );
  }
}

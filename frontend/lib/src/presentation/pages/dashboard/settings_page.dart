import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_text.dart';
import '../../../theme/text_styles.dart';
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
          // Dark Header Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 80,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 8),
                // User Name
                Text(
                  user?.displayName ?? 'User',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // User Role/Subtitle
                Text(
                  'Student',
                  style: TextStyle(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // White Content Area with Rounded Top Corners
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Content with spacing for profile image
                  Column(
                    children: [
                      const SizedBox(height: 60),
                      // Settings List
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                        _buildSettingsItem(
                          AppText.of(context).profile,
                          Icons.person,
                          colorScheme.primary.withOpacity(0.1),
                          () => _showProfileDialog(context),
                        ),
                        _buildNotificationsDropdown(context),
                        _buildSettingsItem(
                          AppText.of(context).privacy,
                          Icons.lock,
                          colorScheme.secondary.withOpacity(0.1),
                          () => _showPrivacyDialog(context),
                        ),
                        _buildSettingsItem(
                          AppText.of(context).theme,
                          Icons.palette,
                          colorScheme.tertiary.withOpacity(0.1),
                          () => _showThemeDialog(context),
                        ),
                        _buildSettingsItem(
                          AppText.of(context).helpSupport,
                          Icons.help,
                          colorScheme.surfaceContainerHighest.withOpacity(0.3),
                          () => _showHelpDialog(context),
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
                  // Profile Image Overlapping - Positioned on top
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary,
                            width: 4,
                          ),
                          color: colorScheme.primary.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Text(
                            user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
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

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: TextStyles.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, Color iconBackgroundColor, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Colored Icon Background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            // Chevron
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _notificationsExpanded = !_notificationsExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Colored Icon Background
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    AppText.of(context).notifications,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Dropdown Arrow
                Icon(
                  _notificationsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
        if (_notificationsExpanded) ...[
          Padding(
            padding: const EdgeInsets.only(left: 64, right: 4, bottom: 8, top: 4),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    AppText.of(context).emailNotifications,
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    AppText.of(context).emailNotificationsSubtitle,
                    style: TextStyle(fontSize: 12),
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
                ),
                SwitchListTile(
                  title: Text(
                    AppText.of(context).pushNotifications,
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    AppText.of(context).pushNotificationsSubtitle,
                    style: TextStyle(fontSize: 12),
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
                ),
                SwitchListTile(
                  title: Text(
                    AppText.of(context).taskRemindersLabel,
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    AppText.of(context).taskRemindersSubtitle,
                    style: TextStyle(fontSize: 12),
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
                ),
              ],
            ),
          ),
        ],
      ],
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

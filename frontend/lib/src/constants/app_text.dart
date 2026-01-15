import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/state/language_provider.dart';

class AppTextData {
  final Map<String, String> _strings;

  AppTextData(this._strings);

  String get appName => _strings['appName'] ?? 'ProLearn AI';
  String get login => _strings['login'] ?? 'Login';
  String get register => _strings['register'] ?? 'Register';
  String get dashboard => _strings['dashboard'] ?? 'Dashboard';
  String get learning => _strings['learning'] ?? 'Learning';
  String get tasks => _strings['tasks'] ?? 'Tasks';
  String get progress => _strings['progress'] ?? 'Progress';
  String get settings => _strings['settings'] ?? 'Settings';
  String get onboarding => _strings['onboarding'] ?? 'Onboarding';
  String get getStarted => _strings['getStarted'] ?? 'Get Started';
  String get settingsTitle => _strings['settingsTitle'] ?? 'Settings';
  String get sectionAccount => _strings['sectionAccount'] ?? 'Account';
  String get sectionLearning => _strings['sectionLearning'] ?? 'Learning';
  String get sectionApp => _strings['sectionApp'] ?? 'App';
  String get profile => _strings['profile'] ?? 'Profile';
  String get notifications => _strings['notifications'] ?? 'Notifications';
  String get privacy => _strings['privacy'] ?? 'Privacy';
  String get studyGoals => _strings['studyGoals'] ?? 'Study Goals';
  String get reminders => _strings['reminders'] ?? 'Reminders';
  String get aiPreferences => _strings['aiPreferences'] ?? 'AI Preferences';
  String get theme => _strings['theme'] ?? 'Theme';
  String get language => _strings['language'] ?? 'Language';
  String get helpSupport => _strings['helpSupport'] ?? 'Help & Support';
  String get cancel => _strings['cancel'] ?? 'Cancel';
  String get apply => _strings['apply'] ?? 'Apply';
  String get save => _strings['save'] ?? 'Save';
  String get welcomeBack => _strings['welcomeBack'] ?? 'Welcome Back';
  String get signInSubtitle =>
      _strings['signInSubtitle'] ?? 'Sign in to continue your learning journey';
  String get pleaseFillAllFields =>
      _strings['pleaseFillAllFields'] ?? 'Please fill in all fields';
  String get loginFailed => _strings['loginFailed'] ?? 'Login failed';
  String get registrationFailed =>
      _strings['registrationFailed'] ?? 'Registration failed';
  String get errorOccurred => _strings['errorOccurred'] ?? 'An error occurred';
  String get noAccount =>
      _strings['noAccount'] ?? "Don't have an account? Sign Up";
  String get createAccount => _strings['createAccount'] ?? 'Create Account';
  String get fullName => _strings['fullName'] ?? 'Full Name';
  String get nameRequired => _strings['nameRequired'] ?? 'Name is required';
  String get studentId => _strings['studentId'] ?? 'Student ID';
  String get studentIdRequired =>
      _strings['studentIdRequired'] ?? 'Student ID is required';
  String get section => _strings['section'] ?? 'Section';
  String get sectionRequired =>
      _strings['sectionRequired'] ?? 'Section is required';
  String get course => _strings['course'] ?? 'Course';
  String get courseRequired =>
      _strings['courseRequired'] ?? 'Course is required';
  String get creatingAccount =>
      _strings['creatingAccount'] ?? 'Creating Account...';
  String get emailLabel => _strings['emailLabel'] ?? 'Email';
  String get passwordLabel => _strings['passwordLabel'] ?? 'Password';
  String get showPassword => _strings['showPassword'] ?? 'Show password';
  String get hidePassword => _strings['hidePassword'] ?? 'Hide password';
  String get invalidEmail =>
      _strings['invalidEmail'] ?? 'Please enter a valid email address';
  String get passwordTooShort =>
      _strings['passwordTooShort'] ?? 'Password must be at least 6 characters';
  String get success => _strings['success'] ?? 'Success';
  String get accountCreated =>
      _strings['accountCreated'] ??
      'Account created successfully! Please check your email for verification.';
  String get ok => _strings['ok'] ?? 'OK';
  String get verifyEmailTitle =>
      _strings['verifyEmailTitle'] ?? 'Verify your email';
  String get verifyEmailSent =>
      _strings['verifyEmailSent'] ?? 'A verification email has been sent to';
  String get yourEmail => _strings['yourEmail'] ?? 'your email';
  String get verifiedButton =>
      _strings['verifiedButton'] ?? 'I verified my email';
  String get resendVerification =>
      _strings['resendVerification'] ?? 'Resend verification email';
  String get verifyEmailHint =>
      _strings['verifyEmailHint'] ??
      'Please check your email inbox and click the verification link before continuing.';
  String get noUserFound =>
      _strings['noUserFound'] ?? 'No user found. Please register again.';
  String get emailNotVerified =>
      _strings['emailNotVerified'] ??
      'Email not verified yet. Please check your inbox and click the verification link in the email.';
  String get verificationSent =>
      _strings['verificationSent'] ??
      'Verification email sent! Please check your inbox.';
  String get errorSendingVerification =>
      _strings['errorSendingVerification'] ??
      'Error sending verification email';
  String get errorCheckingVerification =>
      _strings['errorCheckingVerification'] ?? 'Error checking verification';
  String get welcomeTitle =>
      _strings['welcomeTitle'] ?? 'Welcome to ProLearn AI';
  String get quickStats => _strings['quickStats'] ?? 'Quick Stats';
  String get recentActivity =>
      _strings['recentActivity'] ?? 'Recent Activity';
  String get noRecentActivity =>
      _strings['noRecentActivity'] ?? 'No recent activity';
  String get viewing => _strings['viewing'] ?? 'Viewing';
  String get tasksLabel => _strings['tasksLabel'] ?? 'Tasks';
  String get completedLabel =>
      _strings['completedLabel'] ?? 'Completed';
  String get progressLabel => _strings['progressLabel'] ?? 'Progress';
  String get createdPrefix => _strings['createdPrefix'] ?? 'Created';
  String get completedPrefix => _strings['completedPrefix'] ?? 'Completed';
  String get justNow => _strings['justNow'] ?? 'Just now';
  String timeAgoDays(int days) => _strings['timeAgoDays'] != null
      ? _strings['timeAgoDays']!.replaceAll('{count}', '$days')
      : '$days day${days > 1 ? 's' : ''} ago';
  String timeAgoHours(int hours) => _strings['timeAgoHours'] != null
      ? _strings['timeAgoHours']!.replaceAll('{count}', '$hours')
      : '$hours hour${hours > 1 ? 's' : ''} ago';
  String timeAgoMinutes(int minutes) => _strings['timeAgoMinutes'] != null
      ? _strings['timeAgoMinutes']!.replaceAll('{count}', '$minutes')
      : '$minutes minute${minutes > 1 ? 's' : ''} ago';
  String get noCoursesAvailable =>
      _strings['noCoursesAvailable'] ?? 'No courses available';
  String get coursesLoading =>
      _strings['coursesLoading'] ??
      'Courses are being loaded. Please refresh or check back soon.';
  String get refresh => _strings['refresh'] ?? 'Refresh';
  String get allSubjects => _strings['allSubjects'] ?? 'All Subjects';
  String topicsCount(int count) => _strings['topicsCount'] != null
      ? _strings['topicsCount']!.replaceAll('{count}', '$count')
      : '$count topics';
  String get topics => _strings['topics'] ?? 'Topics';
  String completedTopics(int completed, int total) =>
      _strings['completedTopics'] != null
          ? _strings['completedTopics']!
              .replaceAll('{completed}', '$completed')
              .replaceAll('{total}', '$total')
          : '$completed of $total topics completed';
  String get progressTitle => _strings['progressTitle'] ?? 'Progress';
  String get topicCompleted =>
      _strings['topicCompleted'] ?? 'Topic marked as completed!';
  String get topicIncomplete =>
      _strings['topicIncomplete'] ?? 'Topic marked as incomplete';
  String get errorPrefix => _strings['errorPrefix'] ?? 'Error';
  String get noSubjectsAvailable =>
      _strings['noSubjectsAvailable'] ?? 'No subjects available';
  String get subjectsWillAppear =>
      _strings['subjectsWillAppear'] ??
      'Subjects will appear here once they are added';
  String get yourProgress => _strings['yourProgress'] ?? 'Your Progress';
  String get progressStart => _strings['progressStart'] ?? 'Start your learning journey!';
  String get progressGreatStart => _strings['progressGreatStart'] ?? 'Great start! Keep going!';
  String get progressMaking => _strings['progressMaking'] ?? "You're making progress!";
  String get progressKeepUp => _strings['progressKeepUp'] ?? 'Keep up the great work!';
  String get progressAlmost => _strings['progressAlmost'] ?? "Almost there! You're doing amazing!";
  String get progressComplete => _strings['progressComplete'] ?? "Excellent! You've completed this subject!";
  String get addTask => _strings['addTask'] ?? 'Add Task';
  String get addNewTask => _strings['addNewTask'] ?? 'Add New Task';
  String get taskTitle => _strings['taskTitle'] ?? 'Task Title';
  String get description => _strings['description'] ?? 'Description';
  String get dueDate => _strings['dueDate'] ?? 'Due Date';
  String get pleaseEnterTaskTitle =>
      _strings['pleaseEnterTaskTitle'] ?? 'Please enter a task title';
  String get taskAdded =>
      _strings['taskAdded'] ?? 'Task added successfully';
  String get editTask => _strings['editTask'] ?? 'Edit Task';
  String get taskUpdated =>
      _strings['taskUpdated'] ?? 'Task updated successfully';
  String get deleteTask => _strings['deleteTask'] ?? 'Delete Task';
  String deleteTaskConfirm(String title) => _strings['deleteTaskConfirm'] != null
      ? _strings['deleteTaskConfirm']!.replaceAll('{title}', title)
      : 'Are you sure you want to delete "$title"?';
  String get taskDeleted =>
      _strings['taskDeleted'] ?? 'Task deleted successfully';
  String get overdue => _strings['overdue'] ?? 'Overdue';
  String get dueToday => _strings['dueToday'] ?? 'Due today';
  String get dueTomorrow => _strings['dueTomorrow'] ?? 'Due tomorrow';
  String dueInDays(int days) => _strings['dueInDays'] != null
      ? _strings['dueInDays']!.replaceAll('{count}', '$days')
      : 'Due in $days days';
  String get priority => _strings['priority'] ?? 'Priority';
  String get high => _strings['high'] ?? 'High';
  String get medium => _strings['medium'] ?? 'Medium';
  String get low => _strings['low'] ?? 'Low';
  String get searchTasks => _strings['searchTasks'] ?? 'Search tasks...';
  String get filter => _strings['filter'] ?? 'Filter';
  String get sort => _strings['sort'] ?? 'Sort';
  String get allTasks => _strings['allTasks'] ?? 'All Tasks';
  String get pending => _strings['pending'] ?? 'Pending';
  String get completed => _strings['completed'] ?? 'Completed';
  String get overdueFilter => _strings['overdueFilter'] ?? 'Overdue';
  String get sortDueDate => _strings['sortDueDate'] ?? 'Due Date';
  String get sortPriority => _strings['sortPriority'] ?? 'Priority';
  String get sortCreated => _strings['sortCreated'] ?? 'Created';
  String get sortTitle => _strings['sortTitle'] ?? 'Title';
  String get noTasksFound => _strings['noTasksFound'] ?? 'No tasks found';
  String get noTasksYet => _strings['noTasksYet'] ?? 'No tasks yet';
  String get tryAdjustSearch =>
      _strings['tryAdjustSearch'] ?? 'Try adjusting your search or filters';
  String get tapPlusToAdd =>
      _strings['tapPlusToAdd'] ?? 'Tap the + button to add your first task';
  String get markIncomplete => _strings['markIncomplete'] ?? 'Mark as incomplete';
  String get markComplete => _strings['markComplete'] ?? 'Mark as complete';
  String get delete => _strings['delete'] ?? 'Delete';
  
  // Projects
  String get projects => _strings['projects'] ?? 'Projects';
  String get yourProjects => _strings['yourProjects'] ?? 'Your Projects';
  String get addProject => _strings['addProject'] ?? 'Add Project';
  String get addNewProject => _strings['addNewProject'] ?? 'Add New Project';
  String get projectTitle => _strings['projectTitle'] ?? 'Project Title';
  String get projectAdded => _strings['projectAdded'] ?? 'Project added successfully';
  String get editProject => _strings['editProject'] ?? 'Edit Project';
  String get projectUpdated => _strings['projectUpdated'] ?? 'Project updated successfully';
  String deleteProjectConfirm(String title) => _strings['deleteProjectConfirm'] != null
      ? _strings['deleteProjectConfirm']!.replaceAll('{title}', title)
      : 'Are you sure you want to delete "$title"?';
  String get projectDeleted => _strings['projectDeleted'] ?? 'Project deleted successfully';
  String get noProjects => _strings['noProjects'] ?? 'No projects yet';
  String get noProjectsSubtitle => _strings['noProjectsSubtitle'] ?? 'Tap + to create your first project';
  String get projectStatus => _strings['projectStatus'] ?? 'Status';
  String get active => _strings['active'] ?? 'Active';
  String get onHold => _strings['onHold'] ?? 'On Hold';
  String get archived => _strings['archived'] ?? 'Archived';
  String get projectProgress => _strings['projectProgress'] ?? 'Progress';
  String get allProjects => _strings['allProjects'] ?? 'All Projects';
  String get activeProjects => _strings['activeProjects'] ?? 'Active';
  String get completedProjects => _strings['completedProjects'] ?? 'Completed';
  String get onHoldProjects => _strings['onHoldProjects'] ?? 'On Hold';
  String get archivedProjects => _strings['archivedProjects'] ?? 'Archived';
  String get tags => _strings['tags'] ?? 'Tags';
  String get addTags => _strings['addTags'] ?? 'Add tags (comma separated)';
  String get critical => _strings['critical'] ?? 'Critical';
  String get searchProjects => _strings['searchProjects'] ?? 'Search projects...';
  
  String get logout => _strings['logout'] ?? 'Logout';
  String get confirmLogout =>
      _strings['confirmLogout'] ?? 'Confirm Logout';
  String get logoutConfirmMessage =>
      _strings['logoutConfirmMessage'] ?? 'Are you sure you want to logout?';
  String get verifyEmail => _strings['verifyEmail'] ?? 'Verify Email';
  String get verifyEmailBody =>
      _strings['verifyEmailBody'] ?? 'Please verify your email address';
  String get resendVerificationEmail =>
      _strings['resendVerificationEmail'] ?? 'Resend Verification Email';
  String get verificationEmailSent =>
      _strings['verificationEmailSent'] ?? 'Verification email sent';
  String get verifiedEmailButton =>
      _strings['verifiedEmailButton'] ?? 'I have verified my email';
  String get profileTitle => _strings['profileTitle'] ?? 'Profile';
  String get nameLabel => _strings['nameLabel'] ?? 'Name';
  String get notificationsTitle =>
      _strings['notificationsTitle'] ?? 'Notifications';
  String get emailNotifications =>
      _strings['emailNotifications'] ?? 'Email Notifications';
  String get emailNotificationsSubtitle =>
      _strings['emailNotificationsSubtitle'] ?? 'Receive updates via email';
  String get pushNotifications =>
      _strings['pushNotifications'] ?? 'Push Notifications';
  String get pushNotificationsSubtitle =>
      _strings['pushNotificationsSubtitle'] ?? 'Receive push notifications';
  String get taskRemindersLabel =>
      _strings['taskRemindersLabel'] ?? 'Task Reminders';
  String get taskRemindersSubtitle =>
      _strings['taskRemindersSubtitle'] ??
      'Get reminded about upcoming tasks';
  String get notificationSettingsSaved =>
      _strings['notificationSettingsSaved'] ??
      'Notification settings saved';
  String get profileUpdated =>
      _strings['profileUpdated'] ?? 'Profile updated successfully';
  String get privacyTitle => _strings['privacyTitle'] ?? 'Privacy';
  String get privacySettings =>
      _strings['privacySettings'] ?? 'Privacy Settings';
  String get shareProgress =>
      _strings['shareProgress'] ?? 'Share Progress';
  String get shareProgressSubtitle =>
      _strings['shareProgressSubtitle'] ?? 'Allow sharing your learning progress';
  String get publicProfile =>
      _strings['publicProfile'] ?? 'Public Profile';
  String get publicProfileSubtitle =>
      _strings['publicProfileSubtitle'] ??
      'Make your profile visible to others';
  String get dataManagement =>
      _strings['dataManagement'] ?? 'Data Management';
  String get exportData => _strings['exportData'] ?? 'Export Data';
  String get exportDataSubtitle =>
      _strings['exportDataSubtitle'] ?? 'Download your data';
  String get deleteAccount => _strings['deleteAccount'] ?? 'Delete Account';
  String get deleteAccountSubtitle =>
      _strings['deleteAccountSubtitle'] ??
      'Permanently delete your account';
  String get deleteAccountConfirm =>
      _strings['deleteAccountConfirm'] ??
      'Are you sure you want to delete your account? This action cannot be undone.';
  String get accountDeletionRequested =>
      _strings['accountDeletionRequested'] ??
      'Account deletion requested. Please contact support.';
  String get close => _strings['close'] ?? 'Close';
  String get studyGoalsTitle =>
      _strings['studyGoalsTitle'] ?? 'Study Goals';
  String get dailyStudyGoals =>
      _strings['dailyStudyGoals'] ?? 'Set your daily study goals';
  String get dailyStudyHours =>
      _strings['dailyStudyHours'] ?? 'Daily Study Hours';
  String get studyDaysPerWeek =>
      _strings['studyDaysPerWeek'] ?? 'Study Days Per Week';
  String get hours => _strings['hours'] ?? 'hours';
  String get days => _strings['days'] ?? 'days';
  String studyGoalsSet(String hours, String days) =>
      _strings['studyGoalsSet'] != null
          ? _strings['studyGoalsSet']!
              .replaceAll('{hours}', hours)
              .replaceAll('{days}', days)
          : 'Study goals set: $hours hours/day, $days days/week';
  String get remindersTitle => _strings['remindersTitle'] ?? 'Reminders';
  String get dailyReminder =>
      _strings['dailyReminder'] ?? 'Daily Reminder';
  String get dailyReminderSubtitle =>
      _strings['dailyReminderSubtitle'] ?? 'Get reminded to study daily';
  String get taskReminders =>
      _strings['taskReminders'] ?? 'Task Reminders';
  String get reminderTime =>
      _strings['reminderTime'] ?? 'Reminder Time';
  String get reminderSettingsSaved =>
      _strings['reminderSettingsSaved'] ?? 'Reminder settings saved';
  String get aiPreferencesTitle =>
      _strings['aiPreferencesTitle'] ?? 'AI Preferences';
  String get aiAssistanceLevel =>
      _strings['aiAssistanceLevel'] ?? 'AI Assistance Level';
  String get personalizedSuggestions =>
      _strings['personalizedSuggestions'] ?? 'Personalized Suggestions';
  String get personalizedSuggestionsSubtitle =>
      _strings['personalizedSuggestionsSubtitle'] ??
      'Get AI-powered learning suggestions';
  String get autoTaskGeneration =>
      _strings['autoTaskGeneration'] ?? 'Auto Task Generation';
  String get autoTaskGenerationSubtitle =>
      _strings['autoTaskGenerationSubtitle'] ??
      'Automatically create tasks from courses';
  String get aiPreferencesSaved =>
      _strings['aiPreferencesSaved'] ?? 'AI preferences saved';
  String get themeTitle => _strings['themeTitle'] ?? 'Theme';
  String get light => _strings['light'] ?? 'Light';
  String get dark => _strings['dark'] ?? 'Dark';
  String get systemDefault =>
      _strings['systemDefault'] ?? 'System Default';
  String get lightSubtitle =>
      _strings['lightSubtitle'] ?? 'Always use light theme';
  String get darkSubtitle =>
      _strings['darkSubtitle'] ?? 'Always use dark theme';
  String get systemSubtitle =>
      _strings['systemSubtitle'] ?? 'Follow system theme';
  String themeChanged(String name) =>
      _strings['themeChanged'] != null
          ? _strings['themeChanged']!.replaceAll('{name}', name)
          : 'Theme changed to $name';
  String get languageTitle => _strings['languageTitle'] ?? 'Language';
  String languageChanged(String name) =>
      _strings['languageChanged'] != null
          ? _strings['languageChanged']!.replaceAll('{name}', name)
          : 'Language changed to $name';
  String get helpSupportTitle =>
      _strings['helpSupportTitle'] ?? 'Help & Support';
  String get getHelp => _strings['getHelp'] ?? 'Get Help';
  String get documentation => _strings['documentation'] ?? 'Documentation';
  String get documentationSubtitle =>
      _strings['documentationSubtitle'] ??
      'View user guide and tutorials';
  String get contactSupport =>
      _strings['contactSupport'] ?? 'Contact Support';
  String get contactSupportSubtitle =>
      _strings['contactSupportSubtitle'] ?? 'Email: support@prolearn.ai';
  String get reportBug => _strings['reportBug'] ?? 'Report a Bug';
  String get reportBugSubtitle =>
      _strings['reportBugSubtitle'] ?? 'Report issues or suggestions';
  String get openingDocumentation =>
      _strings['openingDocumentation'] ?? 'Opening documentation...';
  String get openingEmail =>
      _strings['openingEmail'] ?? 'Opening email client...';
  String get openingBugReport =>
      _strings['openingBugReport'] ?? 'Opening bug report form...';
  String get about => _strings['about'] ?? 'About';
  String get version => _strings['version'] ?? 'Version';
  String get appTagline =>
      _strings['appTagline'] ?? 'Your intelligent learning companion';
  String get onboardingDescription =>
      _strings['onboardingDescription'] ??
      'Your AI-powered learning companion.\nManage syllabi, track tasks, and boost productivity.';
  String get notSet => _strings['notSet'] ?? 'Not set';
}

class AppText {
  static const Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.english: {
      'appName': 'ProLearn AI',
      'login': 'Login',
      'register': 'Register',
      'dashboard': 'Dashboard',
      'learning': 'Learning',
      'tasks': 'Tasks',
      'progress': 'Progress',
      'settings': 'Settings',
      'onboarding': 'Onboarding',
      'getStarted': 'Get Started',
      'settingsTitle': 'Settings',
      'sectionAccount': 'Account',
      'sectionLearning': 'Learning',
      'sectionApp': 'App',
      'profile': 'Profile',
      'notifications': 'Notifications',
      'privacy': 'Privacy',
      'studyGoals': 'Study Goals',
      'reminders': 'Reminders',
      'aiPreferences': 'AI Preferences',
      'theme': 'Theme',
      'language': 'Language',
      'helpSupport': 'Help & Support',
      'cancel': 'Cancel',
      'apply': 'Apply',
      'save': 'Save',
      'welcomeBack': 'Welcome Back',
      'signInSubtitle': 'Sign in to continue your learning journey',
      'pleaseFillAllFields': 'Please fill in all fields',
      'loginFailed': 'Login failed',
      'registrationFailed': 'Registration failed',
      'errorOccurred': 'An error occurred',
      'noAccount': "Don't have an account? Sign Up",
      'createAccount': 'Create Account',
      'fullName': 'Full Name',
      'nameRequired': 'Name is required',
      'studentId': 'Student ID',
      'studentIdRequired': 'Student ID is required',
      'section': 'Section',
      'sectionRequired': 'Section is required',
      'course': 'Course',
      'courseRequired': 'Course is required',
      'creatingAccount': 'Creating Account...',
      'emailLabel': 'Email',
      'passwordLabel': 'Password',
      'showPassword': 'Show password',
      'hidePassword': 'Hide password',
      'invalidEmail': 'Please enter a valid email address',
      'passwordTooShort': 'Password must be at least 6 characters',
      'success': 'Success',
      'accountCreated':
          'Account created successfully! Please check your email for verification.',
      'ok': 'OK',
      'verifyEmailTitle': 'Verify your email',
      'verifyEmailSent': 'A verification email has been sent to',
      'yourEmail': 'your email',
      'verifiedButton': 'I verified my email',
      'resendVerification': 'Resend verification email',
      'verifyEmailHint':
          'Please check your email inbox and click the verification link before continuing.',
      'noUserFound': 'No user found. Please register again.',
      'emailNotVerified':
          'Email not verified yet. Please check your inbox and click the verification link in the email.',
      'verificationSent': 'Verification email sent! Please check your inbox.',
      'errorSendingVerification': 'Error sending verification email',
      'errorCheckingVerification': 'Error checking verification',
      'welcomeTitle': 'Welcome to ProLearn AI',
      'quickStats': 'Quick Stats',
      'recentActivity': 'Recent Activity',
      'noRecentActivity': 'No recent activity',
      'viewing': 'Viewing',
      'tasksLabel': 'Tasks',
      'completedLabel': 'Completed',
      'progressLabel': 'Progress',
      'createdPrefix': 'Created',
      'completedPrefix': 'Completed',
      'justNow': 'Just now',
      'timeAgoDays': '{count} days ago',
      'timeAgoHours': '{count} hours ago',
      'timeAgoMinutes': '{count} minutes ago',
      'noCoursesAvailable': 'No courses available',
      'coursesLoading':
          'Courses are being loaded. Please refresh or check back soon.',
      'refresh': 'Refresh',
      'allSubjects': 'All Subjects',
      'topicsCount': '{count} topics',
      'topics': 'Topics',
      'completedTopics': '{completed} of {total} topics completed',
      'progressTitle': 'Progress',
      'topicCompleted': 'Topic marked as completed!',
      'topicIncomplete': 'Topic marked as incomplete',
      'errorPrefix': 'Error',
      'noSubjectsAvailable': 'No subjects available',
      'subjectsWillAppear': 'Subjects will appear here once they are added',
      'yourProgress': 'Your Progress',
      'progressStart': 'Start your learning journey!',
      'progressGreatStart': 'Great start! Keep going!',
      'progressMaking': "You're making progress!",
      'progressKeepUp': 'Keep up the great work!',
      'progressAlmost': "Almost there! You're doing amazing!",
      'progressComplete': "Excellent! You've completed this subject!",
      'addTask': 'Add Task',
      'addNewTask': 'Add New Task',
      'taskTitle': 'Task Title',
      'description': 'Description',
      'dueDate': 'Due Date',
      'pleaseEnterTaskTitle': 'Please enter a task title',
      'taskAdded': 'Task added successfully',
      'editTask': 'Edit Task',
      'taskUpdated': 'Task updated successfully',
      'deleteTask': 'Delete Task',
      'deleteTaskConfirm': 'Are you sure you want to delete "{title}"?',
      'taskDeleted': 'Task deleted successfully',
      'overdue': 'Overdue',
      'dueToday': 'Due today',
      'dueTomorrow': 'Due tomorrow',
      'dueInDays': 'Due in {count} days',
      'priority': 'Priority',
      'high': 'High',
      'medium': 'Medium',
      'low': 'Low',
      'searchTasks': 'Search tasks...',
      'filter': 'Filter',
      'sort': 'Sort',
      'allTasks': 'All Tasks',
      'pending': 'Pending',
      'completed': 'Completed',
      'overdueFilter': 'Overdue',
      'sortDueDate': 'Due Date',
      'sortPriority': 'Priority',
      'sortCreated': 'Created',
      'sortTitle': 'Title',
      'noTasksFound': 'No tasks found',
      'noTasksYet': 'No tasks yet',
      'tryAdjustSearch': 'Try adjusting your search or filters',
      'tapPlusToAdd': 'Tap the + button to add your first task',
      'markIncomplete': 'Mark as incomplete',
      'markComplete': 'Mark as complete',
      'delete': 'Delete',
      'logout': 'Logout',
      'confirmLogout': 'Confirm Logout',
      'logoutConfirmMessage': 'Are you sure you want to logout?',
      'verifyEmail': 'Verify Email',
      'verifyEmailBody': 'Please verify your email address',
      'resendVerificationEmail': 'Resend Verification Email',
      'verificationEmailSent': 'Verification email sent',
      'verifiedEmailButton': 'I have verified my email',
      'profileTitle': 'Profile',
      'nameLabel': 'Name',
      'notificationsTitle': 'Notifications',
      'emailNotifications': 'Email Notifications',
      'emailNotificationsSubtitle': 'Receive updates via email',
      'pushNotifications': 'Push Notifications',
      'pushNotificationsSubtitle': 'Receive push notifications',
      'taskRemindersLabel': 'Task Reminders',
      'taskRemindersSubtitle': 'Get reminded about upcoming tasks',
      'notificationSettingsSaved': 'Notification settings saved',
      'profileUpdated': 'Profile updated successfully',
      'privacyTitle': 'Privacy',
      'privacySettings': 'Privacy Settings',
      'shareProgress': 'Share Progress',
      'shareProgressSubtitle': 'Allow sharing your learning progress',
      'publicProfile': 'Public Profile',
      'publicProfileSubtitle': 'Make your profile visible to others',
      'dataManagement': 'Data Management',
      'exportData': 'Export Data',
      'exportDataSubtitle': 'Download your data',
      'deleteAccount': 'Delete Account',
      'deleteAccountSubtitle': 'Permanently delete your account',
      'deleteAccountConfirm':
          'Are you sure you want to delete your account? This action cannot be undone.',
      'accountDeletionRequested':
          'Account deletion requested. Please contact support.',
      'close': 'Close',
      'studyGoalsTitle': 'Study Goals',
      'dailyStudyGoals': 'Set your daily study goals',
      'dailyStudyHours': 'Daily Study Hours',
      'studyDaysPerWeek': 'Study Days Per Week',
      'hours': 'hours',
      'days': 'days',
      'studyGoalsSet': 'Study goals set: {hours} hours/day, {days} days/week',
      'remindersTitle': 'Reminders',
      'dailyReminder': 'Daily Reminder',
      'dailyReminderSubtitle': 'Get reminded to study daily',
      'taskReminders': 'Task Reminders',
      'reminderTime': 'Reminder Time',
      'reminderSettingsSaved': 'Reminder settings saved',
      'aiPreferencesTitle': 'AI Preferences',
      'aiAssistanceLevel': 'AI Assistance Level',
      'personalizedSuggestions': 'Personalized Suggestions',
      'personalizedSuggestionsSubtitle': 'Get AI-powered learning suggestions',
      'autoTaskGeneration': 'Auto Task Generation',
      'autoTaskGenerationSubtitle':
          'Automatically create tasks from courses',
      'aiPreferencesSaved': 'AI preferences saved',
      'themeTitle': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'systemDefault': 'System Default',
      'lightSubtitle': 'Always use light theme',
      'darkSubtitle': 'Always use dark theme',
      'systemSubtitle': 'Follow system theme',
      'themeChanged': 'Theme changed to {name}',
      'languageTitle': 'Language',
      'languageChanged': 'Language changed to {name}',
      'helpSupportTitle': 'Help & Support',
      'getHelp': 'Get Help',
      'documentation': 'Documentation',
      'documentationSubtitle': 'View user guide and tutorials',
      'contactSupport': 'Contact Support',
      'contactSupportSubtitle': 'Email: support@prolearn.ai',
      'reportBug': 'Report a Bug',
      'reportBugSubtitle': 'Report issues or suggestions',
      'openingDocumentation': 'Opening documentation...',
      'openingEmail': 'Opening email client...',
      'openingBugReport': 'Opening bug report form...',
      'about': 'About',
      'version': 'Version',
      'appTagline': 'Your intelligent learning companion',
      'onboardingDescription':
          'Your AI-powered learning companion.\nManage syllabi, track tasks, and boost productivity.',
      'notSet': 'Not set',
    },
    AppLanguage.filipino: {
      'appName': 'ProLearn AI',
      'login': 'Mag-login',
      'register': 'Magparehistro',
      'dashboard': 'Dashboard',
      'learning': 'Pagkatuto',
      'tasks': 'Mga Gawain',
      'progress': 'Pag-usad',
      'settings': 'Mga Setting',
      'onboarding': 'Panimula',
      'getStarted': 'Magsimula',
      'settingsTitle': 'Mga Setting',
      'sectionAccount': 'Account',
      'sectionLearning': 'Pagkatuto',
      'sectionApp': 'App',
      'profile': 'Profile',
      'notifications': 'Mga Abiso',
      'privacy': 'Pribasiya',
      'studyGoals': 'Mga Layunin sa Pag-aaral',
      'reminders': 'Mga Paalala',
      'aiPreferences': 'Mga Kagustuhan sa AI',
      'theme': 'Tema',
      'language': 'Wika',
      'helpSupport': 'Tulong at Suporta',
      'cancel': 'Kanselahin',
      'apply': 'Ilapat',
      'save': 'I-save',
      'welcomeBack': 'Muling Pagbabalik',
      'signInSubtitle':
          'Mag-sign in para magpatuloy sa iyong pagkatuto',
      'pleaseFillAllFields': 'Pakiusap punan ang lahat ng field',
      'loginFailed': 'Hindi matagumpay ang pag-login',
      'registrationFailed': 'Hindi matagumpay ang pagpaparehistro',
      'errorOccurred': 'May nangyaring error',
      'noAccount': 'Wala pang account? Mag-sign up',
      'createAccount': 'Gumawa ng Account',
      'fullName': 'Buong Pangalan',
      'nameRequired': 'Kailangan ang pangalan',
      'studentId': 'Student ID',
      'studentIdRequired': 'Kailangan ang Student ID',
      'section': 'Seksyon',
      'sectionRequired': 'Kailangan ang seksyon',
      'course': 'Kurso',
      'courseRequired': 'Kailangan ang kurso',
      'creatingAccount': 'Gumagawa ng Account...',
      'emailLabel': 'Email',
      'passwordLabel': 'Password',
      'showPassword': 'Ipakita ang password',
      'hidePassword': 'Itago ang password',
      'invalidEmail': 'Maglagay ng wastong email address',
      'passwordTooShort': 'Dapat 6 na karakter o higit pa ang password',
      'success': 'Tagumpay',
      'accountCreated':
          'Matagumpay ang paggawa ng account! Pakicheck ang email para sa beripikasyon.',
      'ok': 'OK',
      'verifyEmailTitle': 'I-verify ang email',
      'verifyEmailSent': 'Naipadala ang verification email sa',
      'yourEmail': 'iyong email',
      'verifiedButton': 'Na-verify ko na ang email',
      'resendVerification': 'Ipadala muli ang verification email',
      'verifyEmailHint':
          'Pakicheck ang inbox at i-click ang verification link bago magpatuloy.',
      'noUserFound': 'Walang user. Magparehistro ulit.',
      'emailNotVerified':
          'Hindi pa verified ang email. Pakicheck ang inbox at i-click ang link.',
      'verificationSent': 'Naipadala ang verification email!',
      'errorSendingVerification': 'Error sa pagpadala ng verification email',
      'errorCheckingVerification': 'Error sa pag-check ng verification',
      'welcomeTitle': 'Maligayang pagdating sa ProLearn AI',
      'quickStats': 'Mabilisang Estadistika',
      'recentActivity': 'Kamakailang Aktibidad',
      'noRecentActivity': 'Walang kamakailang aktibidad',
      'viewing': 'Tinitingnan',
      'tasksLabel': 'Mga Gawain',
      'completedLabel': 'Natapos',
      'progressLabel': 'Pag-usad',
      'createdPrefix': 'Nilikha',
      'completedPrefix': 'Natapos',
      'justNow': 'Ngayon lang',
      'timeAgoDays': '{count} araw ang nakalipas',
      'timeAgoHours': '{count} oras ang nakalipas',
      'timeAgoMinutes': '{count} minuto ang nakalipas',
      'noCoursesAvailable': 'Walang available na kurso',
      'coursesLoading':
          'Nilo-load ang mga kurso. Paki-refresh o bumalik mamaya.',
      'refresh': 'I-refresh',
      'allSubjects': 'Lahat ng Asignatura',
      'topicsCount': '{count} paksa',
      'topics': 'Mga Paksa',
      'completedTopics': '{completed} sa {total} paksa ang natapos',
      'progressTitle': 'Pag-usad',
      'topicCompleted': 'Natapos na ang paksa!',
      'topicIncomplete': 'Hindi natapos ang paksa',
      'errorPrefix': 'Error',
      'noSubjectsAvailable': 'Walang asignatura',
      'subjectsWillAppear': 'Lalabas ang mga asignatura kapag naidagdag na',
      'yourProgress': 'Ang Iyong Pag-usad',
      'progressStart': 'Simulan ang iyong pagkatuto!',
      'progressGreatStart': 'Magandang simula! Ituloy lang!',
      'progressMaking': 'Umuusad ka na!',
      'progressKeepUp': 'Ituloy ang magandang trabaho!',
      'progressAlmost': 'Malapit na! Ang galing mo!',
      'progressComplete': 'Mahusay! Natapos mo na ang asignatura!',
      'addTask': 'Magdagdag ng Gawain',
      'addNewTask': 'Magdagdag ng Bagong Gawain',
      'taskTitle': 'Pamagat ng Gawain',
      'description': 'Paglalarawan',
      'dueDate': 'Takdang Petsa',
      'pleaseEnterTaskTitle': 'Maglagay ng pamagat ng gawain',
      'taskAdded': 'Matagumpay na naidagdag ang gawain',
      'editTask': 'I-edit ang Gawain',
      'taskUpdated': 'Matagumpay na na-update ang gawain',
      'deleteTask': 'Tanggalin ang Gawain',
      'deleteTaskConfirm': 'Sigurado ka bang tatanggalin ang "{title}"?',
      'taskDeleted': 'Matagumpay na natanggal ang gawain',
      'overdue': 'Huli na',
      'dueToday': 'Takda ngayon',
      'dueTomorrow': 'Takda bukas',
      'dueInDays': 'Takda sa {count} araw',
      'priority': 'Prayoridad',
      'high': 'Mataas',
      'medium': 'Katamtaman',
      'low': 'Mababa',
      'searchTasks': 'Maghanap ng gawain...',
      'filter': 'Salain',
      'sort': 'Ayusin',
      'allTasks': 'Lahat ng Gawain',
      'pending': 'Hindi pa tapos',
      'completed': 'Tapos na',
      'overdueFilter': 'Huli na',
      'sortDueDate': 'Takdang Petsa',
      'sortPriority': 'Prayoridad',
      'sortCreated': 'Nilikha',
      'sortTitle': 'Pamagat',
      'noTasksFound': 'Walang natagpuang gawain',
      'noTasksYet': 'Wala pang gawain',
      'tryAdjustSearch': 'Subukang ayusin ang paghahanap o mga filter',
      'tapPlusToAdd': 'Pindutin ang + para magdagdag ng gawain',
      'markIncomplete': 'Markahang hindi tapos',
      'markComplete': 'Markahang tapos',
      'delete': 'Tanggalin',
      'logout': 'Mag-logout',
      'confirmLogout': 'Kumpirmahin ang Pag-logout',
      'logoutConfirmMessage': 'Sigurado ka bang magla-logout?',
      'verifyEmail': 'I-verify ang Email',
      'verifyEmailBody': 'Paki-verify ang iyong email address',
      'resendVerificationEmail': 'Ipadala muli ang verification email',
      'verificationEmailSent': 'Naipadala ang verification email',
      'verifiedEmailButton': 'Na-verify ko na ang email',
      'profileTitle': 'Profile',
      'nameLabel': 'Pangalan',
      'notificationsTitle': 'Mga Abiso',
      'emailNotifications': 'Mga Abiso sa Email',
      'emailNotificationsSubtitle': 'Tumanggap ng update via email',
      'pushNotifications': 'Push Notifications',
      'pushNotificationsSubtitle': 'Tumanggap ng push notifications',
      'taskRemindersLabel': 'Mga Paalala sa Gawain',
      'taskRemindersSubtitle': 'Magpaalala sa mga nalalapit na gawain',
      'notificationSettingsSaved': 'Nai-save ang mga setting ng abiso',
      'profileUpdated': 'Matagumpay na na-update ang profile',
      'privacyTitle': 'Pribasiya',
      'privacySettings': 'Mga Setting ng Pribasiya',
      'shareProgress': 'Ibahagi ang Pag-usad',
      'shareProgressSubtitle': 'Payagan ang pagbabahagi ng pag-usad',
      'publicProfile': 'Pampublikong Profile',
      'publicProfileSubtitle': 'Ipakita ang profile sa iba',
      'dataManagement': 'Pamamahala ng Data',
      'exportData': 'I-export ang Data',
      'exportDataSubtitle': 'I-download ang iyong data',
      'deleteAccount': 'Tanggalin ang Account',
      'deleteAccountSubtitle': 'Permanenteng tanggalin ang account',
      'deleteAccountConfirm':
          'Sigurado ka bang tatanggalin ang iyong account? Hindi na ito mababawi.',
      'accountDeletionRequested':
          'Humiling ng pagtanggal ng account. Makipag-ugnayan sa suporta.',
      'close': 'Isara',
      'studyGoalsTitle': 'Mga Layunin sa Pag-aaral',
      'dailyStudyGoals': 'Itakda ang daily study goals',
      'dailyStudyHours': 'Oras ng Pag-aaral bawat Araw',
      'studyDaysPerWeek': 'Araw ng Pag-aaral kada Linggo',
      'hours': 'oras',
      'days': 'araw',
      'studyGoalsSet': 'Naitakda: {hours} oras/araw, {days} araw/linggo',
      'remindersTitle': 'Mga Paalala',
      'dailyReminder': 'Daily Reminder',
      'dailyReminderSubtitle': 'Magpaalala araw-araw',
      'taskReminders': 'Mga Paalala sa Gawain',
      'reminderTime': 'Oras ng Paalala',
      'reminderSettingsSaved': 'Nai-save ang mga setting ng paalala',
      'aiPreferencesTitle': 'Mga Kagustuhan sa AI',
      'aiAssistanceLevel': 'Antas ng Tulong ng AI',
      'personalizedSuggestions': 'Personalized na Suhestiyon',
      'personalizedSuggestionsSubtitle': 'AI-powered na suhestiyon',
      'autoTaskGeneration': 'Auto Task Generation',
      'autoTaskGenerationSubtitle':
          'Awtomatikong gumawa ng gawain mula sa kurso',
      'aiPreferencesSaved': 'Nai-save ang AI preferences',
      'themeTitle': 'Tema',
      'light': 'Maliwanag',
      'dark': 'Madilim',
      'systemDefault': 'Default ng System',
      'lightSubtitle': 'Laging light theme',
      'darkSubtitle': 'Laging dark theme',
      'systemSubtitle': 'Sundin ang tema ng system',
      'themeChanged': 'Nagbago ang tema sa {name}',
      'languageTitle': 'Wika',
      'languageChanged': 'Nagbago ang wika sa {name}',
      'helpSupportTitle': 'Tulong at Suporta',
      'getHelp': 'Kumuha ng Tulong',
      'documentation': 'Dokumentasyon',
      'documentationSubtitle': 'Tingnan ang gabay at tutorial',
      'contactSupport': 'Kontakin ang Suporta',
      'contactSupportSubtitle': 'Email: support@prolearn.ai',
      'reportBug': 'Mag-ulat ng Bug',
      'reportBugSubtitle': 'Iulat ang mga isyu o suhestiyon',
      'openingDocumentation': 'Binubuksan ang dokumentasyon...',
      'openingEmail': 'Binubuksan ang email client...',
      'openingBugReport': 'Binubuksan ang bug report form...',
      'about': 'Tungkol',
      'version': 'Bersyon',
      'appTagline': 'Ang iyong matalinong kasama sa pagkatuto',
      'onboardingDescription':
          'Ang iyong AI-powered na kasama sa pagkatuto.\nPamahalaan ang syllabus, subaybayan ang mga gawain, at pataasin ang produktibidad.',
      'notSet': 'Wala pa',
    },
    AppLanguage.bisaya: {
      'appName': 'ProLearn AI',
      'login': 'Log in',
      'register': 'Pagrehistro',
      'dashboard': 'Dashboard',
      'learning': 'Pagkat-on',
      'tasks': 'Mga Buluhaton',
      'progress': 'Progreso',
      'settings': 'Mga Setting',
      'onboarding': 'Panimula',
      'getStarted': 'Sugdi',
      'settingsTitle': 'Mga Setting',
      'sectionAccount': 'Account',
      'sectionLearning': 'Pagkat-on',
      'sectionApp': 'App',
      'profile': 'Profile',
      'notifications': 'Mga Pahibalo',
      'privacy': 'Pribasiya',
      'studyGoals': 'Mga Tumong sa Pagtuon',
      'reminders': 'Mga Pahinumdom',
      'aiPreferences': 'Mga Setting sa AI',
      'theme': 'Tema',
      'language': 'Pinulongan',
      'helpSupport': 'Tabang ug Suporta',
      'cancel': 'Kanselahon',
      'apply': 'I-apply',
      'save': 'I-save',
      'welcomeBack': 'Maayong pagbalik',
      'signInSubtitle':
          'Pag-sign in aron mapadayon ang imong pagkat-on',
      'pleaseFillAllFields': 'Palihug pun-a ang tanang field',
      'loginFailed': 'Napakyas ang pag-login',
      'registrationFailed': 'Napakyas ang pagrehistro',
      'errorOccurred': 'Adunay sayop nga nahitabo',
      'noAccount': 'Wala pay account? Pag-sign up',
      'createAccount': 'Paghimo og Account',
      'fullName': 'Buong Ngalan',
      'nameRequired': 'Gikinahanglan ang ngalan',
      'studentId': 'Student ID',
      'studentIdRequired': 'Gikinahanglan ang Student ID',
      'section': 'Seksyon',
      'sectionRequired': 'Gikinahanglan ang seksyon',
      'course': 'Kurso',
      'courseRequired': 'Gikinahanglan ang kurso',
      'creatingAccount': 'Nagahimo og Account...',
      'emailLabel': 'Email',
      'passwordLabel': 'Password',
      'showPassword': 'Ipakita ang password',
      'hidePassword': 'Itago ang password',
      'invalidEmail': 'Palihug butangi og sakto nga email',
      'passwordTooShort': 'Kinahanglan 6 ka karakter o labaw pa',
      'success': 'Kalampusan',
      'accountCreated':
          'Malampuson ang paghimo sa account! Palihug i-check ang email para sa verification.',
      'ok': 'OK',
      'verifyEmailTitle': 'I-verify ang email',
      'verifyEmailSent': 'Naipadala ang verification email sa',
      'yourEmail': 'imong email',
      'verifiedButton': 'Na-verify na nako ang email',
      'resendVerification': 'Ipadala pag-usab ang verification email',
      'verifyEmailHint':
          'Palihug i-check ang inbox ug i-klik ang verification link bago magpadayon.',
      'noUserFound': 'Walay user. Palihug pagrehistro pag-usab.',
      'emailNotVerified':
          'Wala pa ma-verify ang email. Palihug i-check ang inbox ug i-klik ang link.',
      'verificationSent': 'Naipadala ang verification email!',
      'errorSendingVerification': 'Sayop sa pagpadala sa verification email',
      'errorCheckingVerification': 'Sayop sa pag-check sa verification',
      'welcomeTitle': 'Maayong pag-abot sa ProLearn AI',
      'quickStats': 'Pas-pas nga Estadistika',
      'recentActivity': 'Bag-ong Aktibidad',
      'noRecentActivity': 'Walay bag-ong aktibidad',
      'viewing': 'Gitan-aw',
      'tasksLabel': 'Mga Buluhaton',
      'completedLabel': 'Nahuman',
      'progressLabel': 'Progreso',
      'createdPrefix': 'Gihimo',
      'completedPrefix': 'Nahuman',
      'justNow': 'Karon lang',
      'timeAgoDays': '{count} ka adlaw ang milabay',
      'timeAgoHours': '{count} ka oras ang milabay',
      'timeAgoMinutes': '{count} ka minuto ang milabay',
      'noCoursesAvailable': 'Walay available nga kurso',
      'coursesLoading':
          'Nag-load ang mga kurso. Palihug i-refresh o balik unya.',
      'refresh': 'I-refresh',
      'allSubjects': 'Tanan nga Asignatura',
      'topicsCount': '{count} ka paksa',
      'topics': 'Mga Paksa',
      'completedTopics': '{completed} sa {total} ka paksa ang nahuman',
      'progressTitle': 'Progreso',
      'topicCompleted': 'Nahuman na ang paksa!',
      'topicIncomplete': 'Wala mahuman ang paksa',
      'errorPrefix': 'Sayop',
      'noSubjectsAvailable': 'Walay asignatura',
      'subjectsWillAppear': 'Mugawas ang asignatura kung madugang na',
      'yourProgress': 'Imong Progreso',
      'progressStart': 'Sugdi ang imong pagkat-on!',
      'progressGreatStart': 'Maayo nga sugod! Padayon!',
      'progressMaking': 'Nag-uswag ka na!',
      'progressKeepUp': 'Padayon sa maayong trabaho!',
      'progressAlmost': 'Hapit na! Nindot kaayo!',
      'progressComplete': 'Nindot! Nahuman nimo ang asignatura!',
      'addTask': 'Idugang ang Buluhaton',
      'addNewTask': 'Idugang Bag-ong Buluhaton',
      'taskTitle': 'Titulo sa Buluhaton',
      'description': 'Deskripsyon',
      'dueDate': 'Takdang Petsa',
      'pleaseEnterTaskTitle': 'Palihug butangi og titulo ang buluhaton',
      'taskAdded': 'Malampuson nga naidugang ang buluhaton',
      'editTask': 'I-edit ang Buluhaton',
      'taskUpdated': 'Malampuson nga na-update ang buluhaton',
      'deleteTask': 'Tangtanga ang Buluhaton',
      'deleteTaskConfirm': 'Sigurado ka nga tangtangon ang "{title}"?',
      'taskDeleted': 'Malampuson nga natangtang ang buluhaton',
      'overdue': 'Naulahi',
      'dueToday': 'Takda karon',
      'dueTomorrow': 'Takda ugma',
      'dueInDays': 'Takda sa {count} ka adlaw',
      'priority': 'Prayoridad',
      'high': 'Taas',
      'medium': 'Tunga-tunga',
      'low': 'Ubos',
      'searchTasks': 'Pangitaa ang buluhaton...',
      'filter': 'Salain',
      'sort': 'Ayos',
      'allTasks': 'Tanan nga Buluhaton',
      'pending': 'Wala pa mahuman',
      'completed': 'Nahuman',
      'overdueFilter': 'Naulahi',
      'sortDueDate': 'Takdang Petsa',
      'sortPriority': 'Prayoridad',
      'sortCreated': 'Gihimo',
      'sortTitle': 'Titulo',
      'noTasksFound': 'Walay nakita nga buluhaton',
      'noTasksYet': 'Wala pay buluhaton',
      'tryAdjustSearch': 'Sulayi ug usba ang pangita o mga filter',
      'tapPlusToAdd': 'Pislita ang + para mudugang og buluhaton',
      'markIncomplete': 'Timailhan nga wala nahuman',
      'markComplete': 'Timailhan nga nahuman',
      'delete': 'Tangtanga',
      'logout': 'Pag-logout',
      'confirmLogout': 'Kumpirmahi ang Pag-logout',
      'logoutConfirmMessage': 'Sigurado ka nga mag-logout?',
      'verifyEmail': 'I-verify ang Email',
      'verifyEmailBody': 'Palihug i-verify ang imong email address',
      'resendVerificationEmail': 'Ipadala pag-usab ang verification email',
      'verificationEmailSent': 'Naipadala ang verification email',
      'verifiedEmailButton': 'Na-verify na nako ang email',
      'profileTitle': 'Profile',
      'nameLabel': 'Ngalan',
      'notificationsTitle': 'Mga Pahibalo',
      'emailNotifications': 'Mga Pahibalo sa Email',
      'emailNotificationsSubtitle': 'Makadawat og update pinaagi sa email',
      'pushNotifications': 'Push Notifications',
      'pushNotificationsSubtitle': 'Makadawat og push notifications',
      'taskRemindersLabel': 'Mga Pahinumdom sa Buluhaton',
      'taskRemindersSubtitle': 'Mahinumdom sa umaabot nga buluhaton',
      'notificationSettingsSaved': 'Na-save ang setting sa pahibalo',
      'profileUpdated': 'Malampuson nga na-update ang profile',
      'privacyTitle': 'Pribasiya',
      'privacySettings': 'Mga Setting sa Pribasiya',
      'shareProgress': 'Ipaambit ang Progreso',
      'shareProgressSubtitle': 'Tugoti ang pagpaambit sa progreso',
      'publicProfile': 'Publikong Profile',
      'publicProfileSubtitle': 'Ipakita ang profile sa uban',
      'dataManagement': 'Pagdumala sa Data',
      'exportData': 'I-export ang Data',
      'exportDataSubtitle': 'I-download ang imong data',
      'deleteAccount': 'Tanggalon ang Account',
      'deleteAccountSubtitle': 'Permanenteng tanggalon ang account',
      'deleteAccountConfirm':
          'Sigurado ka ba nga tangtangon ang imong account? Dili na kini mabawi.',
      'accountDeletionRequested':
          'Nangayo og pagtangtang sa account. Palihug kontaka ang suporta.',
      'close': 'Isira',
      'studyGoalsTitle': 'Mga Tumong sa Pagtuon',
      'dailyStudyGoals': 'I-set ang imong daily study goals',
      'dailyStudyHours': 'Oras sa Pagtuon kada Adlaw',
      'studyDaysPerWeek': 'Araw sa Pagtuon kada Semana',
      'hours': 'oras',
      'days': 'adlaw',
      'studyGoalsSet': 'Na-set: {hours} oras/adlaw, {days} adlaw/semana',
      'remindersTitle': 'Mga Pahinumdom',
      'dailyReminder': 'Adlaw-adlaw nga Pahinumdom',
      'dailyReminderSubtitle': 'Mahinumdom sa adlaw-adlaw nga pagtuon',
      'taskReminders': 'Mga Pahinumdom sa Buluhaton',
      'reminderTime': 'Oras sa Pahinumdom',
      'reminderSettingsSaved': 'Na-save ang setting sa pahinumdom',
      'aiPreferencesTitle': 'Mga Setting sa AI',
      'aiAssistanceLevel': 'Lebel sa Tulong sa AI',
      'personalizedSuggestions': 'Personalized nga Sugyot',
      'personalizedSuggestionsSubtitle': 'AI-powered nga sugyot',
      'autoTaskGeneration': 'Auto Task Generation',
      'autoTaskGenerationSubtitle':
          'Awtomatikong paghimo og buluhaton gikan sa kurso',
      'aiPreferencesSaved': 'Na-save ang AI preferences',
      'themeTitle': 'Tema',
      'light': 'Hayag',
      'dark': 'Itom',
      'systemDefault': 'Default sa System',
      'lightSubtitle': 'Kanunay light theme',
      'darkSubtitle': 'Kanunay dark theme',
      'systemSubtitle': 'Sundon ang tema sa system',
      'themeChanged': 'Nausab ang tema ngadto sa {name}',
      'languageTitle': 'Pinulongan',
      'languageChanged': 'Nausab ang pinulongan ngadto sa {name}',
      'helpSupportTitle': 'Tabang ug Suporta',
      'getHelp': 'Pangayo og Tabang',
      'documentation': 'Dokumentasyon',
      'documentationSubtitle': 'Tan-awa ang giya ug mga tutorial',
      'contactSupport': 'Kontaka ang Suporta',
      'contactSupportSubtitle': 'Email: support@prolearn.ai',
      'reportBug': 'Isugid ang Bug',
      'reportBugSubtitle': 'Isugid ang mga isyu o sugyot',
      'openingDocumentation': 'Gibuksan ang dokumentasyon...',
      'openingEmail': 'Gibuksan ang email client...',
      'openingBugReport': 'Gibuksan ang bug report form...',
      'about': 'Bahin',
      'version': 'Bersyon',
      'appTagline': 'Imong maalamon nga kauban sa pagkat-on',
      'onboardingDescription':
          'Imong AI-powered nga kauban sa pagkat-on.\nPagdumala sa syllabus, subaybayan ang buluhaton, ug pataasa ang produktibidad.',
      'notSet': 'Wala pa',
    },
  };

  static AppTextData of(BuildContext context, {bool listen = true}) {
    final language = Provider.of<LanguageProvider>(context, listen: listen).language;
    final strings = _translations[language] ?? _translations[AppLanguage.english]!;
    return AppTextData(strings);
  }
}

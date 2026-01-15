import 'package:flutter/material.dart';

// AUTH & ONBOARDING
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/onboarding/onboarding_page.dart';

// DASHBOARD PAGES
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/dashboard/learning_page.dart';
import '../presentation/pages/dashboard/task_page.dart';
import '../presentation/pages/dashboard/projects_page.dart';
import '../presentation/pages/dashboard/progress_page.dart';
import '../presentation/pages/dashboard/settings_page.dart';

// 🔐 AUTH GATE
import '../presentation/auth/auth_gate.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String learning = '/learning';
  static const String tasks = '/tasks';
  static const String projects = '/projects';
  static const String progress = '/progress';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingPage(),
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),

    // 🔐 PROTECTED ROUTES
    dashboard: (context) => const AuthGate(
          loggedIn: DashboardPage(),
          loggedOut: LoginPage(),
        ),

    learning: (context) => const AuthGate(
          loggedIn: LearningPage(),
          loggedOut: LoginPage(),
        ),

    tasks: (context) => const AuthGate(
          loggedIn: TaskPage(),
          loggedOut: LoginPage(),
        ),

    projects: (context) => const AuthGate(
          loggedIn: ProjectsPage(),
          loggedOut: LoginPage(),
        ),

    progress: (context) => const AuthGate(
          loggedIn: ProgressPage(),
          loggedOut: LoginPage(),
        ),

    settings: (context) => const AuthGate(
          loggedIn: SettingsPage(),
          loggedOut: LoginPage(),
        ),
  };
}

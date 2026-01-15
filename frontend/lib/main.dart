import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'src/presentation/state/app_auth_provider.dart';
import 'src/presentation/state/syllabus_provider.dart';
import 'src/presentation/state/task_provider.dart';
import 'src/presentation/state/project_provider.dart';
import 'src/presentation/state/theme_provider.dart';
import 'src/presentation/state/topic_progress_provider.dart';
import 'src/presentation/state/language_provider.dart';
import 'src/routes/app_routes.dart';
import 'src/utils/logger.dart';
import 'src/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with error handling
    final options = DefaultFirebaseOptions.currentPlatform;
    Logger.info('Initializing Firebase for platform: ${options.projectId}');
    
    await Firebase.initializeApp(
      options: options,
    );
    
    // Verify Firebase is initialized
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase initialization failed - no apps found');
    }
    
    // Verify Firebase Auth is available
    try {
      FirebaseAuth.instance;
      Logger.info('Firebase Auth instance created successfully');
    } catch (e) {
      Logger.warning('Firebase Auth not available: $e');
    }
    
    Logger.info('Firebase initialized successfully');
  } catch (e, stackTrace) {
    Logger.error('Error initializing Firebase', e, stackTrace);
    // Re-throw to prevent app from running with broken Firebase
    rethrow;
  }

  final syllabusProvider = SyllabusProvider();
  await syllabusProvider.loadSyllabi();

  final topicProgressProvider = TopicProgressProvider();
  topicProgressProvider.initializeProgressStream();

  final themeProvider = ThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => syllabusProvider),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
        ChangeNotifierProvider(create: (_) => topicProgressProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ProLearn AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.flutterThemeMode,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();
            if (!kIsWeb) return child;

            // Workaround for occasional negative viewInsets on web.
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(viewInsets: EdgeInsets.zero),
              child: child,
            );
          },
          initialRoute: AppRoutes.onboarding,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

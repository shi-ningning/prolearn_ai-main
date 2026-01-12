import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'presentation/state/app_auth_provider.dart';
import 'presentation/state/syllabus_provider.dart';
import 'presentation/state/task_provider.dart';
import 'presentation/state/theme_provider.dart';
import 'presentation/state/topic_progress_provider.dart';
import 'routes/app_routes.dart';
import 'core/utils/logger.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => syllabusProvider),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
          theme: themeProvider.themeData,
          initialRoute: AppRoutes.onboarding,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

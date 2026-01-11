import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'presentation/state/app_auth_provider.dart';
import 'presentation/state/syllabus_provider.dart';
import 'presentation/state/task_provider.dart';
import 'presentation/state/theme_provider.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final syllabusProvider = SyllabusProvider();
  await syllabusProvider.loadSyllabi();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => syllabusProvider),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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

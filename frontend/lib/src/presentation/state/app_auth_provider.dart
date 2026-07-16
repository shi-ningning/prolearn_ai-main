import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/services/google_auth_service.dart';
import '../../utils/logger.dart';
import 'google_classroom_provider.dart';

class AppAuthProvider extends ChangeNotifier {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  GoogleClassroomProvider? _classroomProvider;

  // Backend API URL - Update this with your production URL
  static const String _apiBaseUrl = 'http://localhost:8080/api';

  FirebaseAuth get _auth {
    // Ensure Firebase is initialized before accessing Auth
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized. Please restart the app.');
    }
    return FirebaseAuth.instance;
  }

  User? get user => _auth.currentUser;

  /// Save user to MongoDB via backend API
  Future<bool> _saveUserToMongoDB(
    String uid,
    String email,
    String displayName,
    String? idToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode({
          'uid': uid,
          'email': email,
          'displayName': displayName,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Logger.info('MongoDB response: ${data['message']}');
        return true;
      } else {
        Logger.warning(
          'MongoDB save failed: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      Logger.error('Error calling MongoDB API: $e');
      return false;
    }
  }

  Future<void> login(String email, String password) async {
    // Validate inputs before making API call
    if (email.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Email cannot be empty',
      );
    }
    if (password.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password cannot be empty',
      );
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      notifyListeners(); // 🔑 IMPORTANT
    } on FirebaseAuthException catch (e) {
      // Re-throw with more user-friendly messages
      throw FirebaseAuthException(
        code: e.code,
        message: _getErrorMessage(e.code),
      );
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled';
      default:
        return 'Login failed. Please check your credentials';
    }
  }

  Future<void> register(
    String name,
    String studentId,
    String section,
    String course,
    String email,
    String password,
  ) async {
    // Validate inputs before making API call
    final trimmedName = name.trim();
    final trimmedStudentId = studentId.trim();
    final trimmedSection = section.trim();
    final trimmedCourse = course.trim();
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-argument',
        message: 'Name cannot be empty',
      );
    }
    if (trimmedStudentId.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-argument',
        message: 'Student ID cannot be empty',
      );
    }
    if (trimmedSection.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-argument',
        message: 'Section cannot be empty',
      );
    }
    if (trimmedCourse.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-argument',
        message: 'Course cannot be empty',
      );
    }
    if (trimmedEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Email cannot be empty',
      );
    }
    if (trimmedPassword.isEmpty) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password cannot be empty',
      );
    }

    // Additional validation for email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(trimmedEmail)) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Invalid email format',
      );
    }

    // Validate password length (Firebase requires at least 6 characters)
    if (trimmedPassword.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must be at least 6 characters',
      );
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      // Update display name if user was created successfully
      if (credential.user != null) {
        final user = credential.user!;
        await user.updateDisplayName(trimmedName);
        await user.reload();

        // DEVELOPMENT MODE: Email verification disabled
        // Uncomment the code below to re-enable email verification
        /*
        try {
          // Configure action code settings for better email experience
          final actionCodeSettings = ActionCodeSettings(
            url: 'https://prolearn-ai-micha.firebaseapp.com/',
            handleCodeInApp: false,
            androidPackageName: 'com.prolearnai.app',
            androidInstallApp: false,
            iOSBundleId: 'com.example.prolearnAi',
          );
          
          await user.sendEmailVerification(actionCodeSettings);
          Logger.info('Email verification sent successfully to ${user.email}');
        } catch (e) {
          // Log the error but don't fail the registration
          Logger.warning('Failed to send email verification: $e');
          Logger.warning('User can manually request verification later');
          // Email verification failed, but user is still created
          // They can request verification again from the email verification page
        }
        */
        Logger.info(
          '✅ User registered successfully (email verification skipped for development)',
        );

        // Save user to MongoDB via backend API (instead of Firestore)
        try {
          // Get Firebase ID token for authentication
          final idToken = await user.getIdToken();

          // Call backend API to save user to MongoDB
          final response = await _saveUserToMongoDB(
            user.uid,
            trimmedEmail,
            trimmedName,
            idToken,
          );

          if (response) {
            Logger.info('✅ User saved to MongoDB successfully');
          } else {
            Logger.warning(
              '⚠️  Failed to save user to MongoDB, but Firebase Auth succeeded',
            );
          }
        } catch (e) {
          Logger.warning('⚠️  Error saving to MongoDB: $e');
          // Don't fail registration if MongoDB save fails
        }
      }

      notifyListeners(); // 🔑 IMPORTANT
    } on FirebaseAuthException catch (e) {
      // Re-throw with more user-friendly messages
      throw FirebaseAuthException(
        code: e.code,
        message: _getRegisterErrorMessage(e.code),
      );
    }
  }

  String _getRegisterErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters';
      case 'operation-not-allowed':
        return 'Email/Password registration is not enabled';
      default:
        return 'Registration failed. Please try again';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleAuthService.signOut();
    notifyListeners();
  }

  void setClassroomProvider(GoogleClassroomProvider provider) {
    _classroomProvider = provider;
  }

  Future<void> signInWithGoogle() async {
    try {
      final userCredential = await _googleAuthService.signInWithGoogle();

      if (userCredential == null) {
        throw Exception('Google Sign-In was cancelled');
      }

      final user = userCredential.user;
      if (user != null) {
        try {
          final idToken = await user.getIdToken();

          final response = await _saveUserToMongoDB(
            user.uid,
            user.email ?? '',
            user.displayName ?? 'User',
            idToken,
          );

          if (response) {
            Logger.info('✅ User saved to MongoDB successfully');
          } else {
            Logger.warning('⚠️  Failed to save user to MongoDB');
          }
        } catch (e) {
          Logger.warning('⚠️  Error saving to MongoDB: $e');
        }

        if (_classroomProvider != null) {
          try {
            Logger.info('🔄 Waiting for authentication to propagate...');
            await Future.delayed(const Duration(seconds: 1));

            Logger.info('🔄 Automatically signing in to Google Classroom...');
            await _classroomProvider!.signIn();
            if (_classroomProvider!.isSignedIn) {
              Logger.info('✅ Google Classroom sign-in successful');
            } else {
              Logger.warning(
                '⚠️  Google Classroom sign-in failed: ${_classroomProvider!.error}',
              );
            }
          } catch (e) {
            Logger.warning('⚠️  Google Classroom sign-in failed: $e');
          }
        }
      }

      notifyListeners();
    } catch (e) {
      Logger.error('Error signing in with Google: $e');
      rethrow;
    }
  }
}

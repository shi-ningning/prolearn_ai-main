import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AppAuthProvider extends ChangeNotifier {
  FirebaseAuth get _auth {
    // Ensure Firebase is initialized before accessing Auth
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized. Please restart the app.');
    }
    return FirebaseAuth.instance;
  }

  User? get user => _auth.currentUser;

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
    String email,
    String password,
  ) async {
    // Validate inputs before making API call
    final trimmedName = name.trim();
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();

    if (trimmedName.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-argument',
        message: 'Name cannot be empty',
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
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
        await credential.user!.updateDisplayName(trimmedName);
        await credential.user!.reload();
        await credential.user!.sendEmailVerification();
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
    notifyListeners(); // 🔑 IMPORTANT
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners(); // 🔑 IMPORTANT
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);
    await credential.user?.sendEmailVerification();

    notifyListeners(); // 🔑 IMPORTANT
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners(); // 🔑 IMPORTANT
  }
}

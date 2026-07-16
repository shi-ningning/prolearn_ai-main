import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  final Widget loggedIn;
  final Widget loggedOut;

  const AuthGate({super.key, required this.loggedIn, required this.loggedOut});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // final user = snapshot.data!;

          // DEVELOPMENT MODE: Email verification disabled
          // Comment out the line below to re-enable email verification
          // if (!user.emailVerified) {
          //   return const EmailVerificationPage();
          // }

          return loggedIn;
        }

        return loggedOut;
      },
    );
  }
}

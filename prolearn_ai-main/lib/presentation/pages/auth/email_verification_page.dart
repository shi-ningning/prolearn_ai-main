import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.email, size: 80),
              const SizedBox(height: 16),
              const Text(
                'Verify your email',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'A verification email has been sent to ${user?.email}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await user?.reload();
                  if (FirebaseAuth.instance.currentUser!.emailVerified) {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  }
                },
                child: const Text('I verified my email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

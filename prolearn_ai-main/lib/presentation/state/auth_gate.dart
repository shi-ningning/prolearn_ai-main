import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email, size: 80),
            const SizedBox(height: 24),
            const Text(
              'Please verify your email address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              user?.email ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                await user?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Verification email sent'),
                  ),
                );
              },
              child: const Text('Resend Verification Email'),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () async {
                await user?.reload();
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
              child: const Text('I have verified my email'),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_text.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.of(context).verifyEmail),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.email_rounded,
                size: 60,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              AppText.of(context).verifyEmailBody,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              user?.email ?? '',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                await user?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppText.of(context, listen: false).verificationEmailSent,
                    ),
                  ),
                );
              },
              child: Text(AppText.of(context).resendVerificationEmail),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () async {
                await user?.reload();
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
              child: Text(AppText.of(context).verifiedEmailButton),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: Text(AppText.of(context).logout),
            ),
          ],
        ),
      ),
    );
  }
}

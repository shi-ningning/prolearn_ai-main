import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/app_text.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/custom_button.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool _isChecking = false;
  bool _isResending = false;

  Future<void> _checkVerification() async {
    if (_isChecking) {
      return;
    }

    setState(() {
      _isChecking = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppText.of(context, listen: false).noUserFound),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushReplacementNamed(context, '/register');
        return;
      }

      // Reload user to get latest verification status
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser?.emailVerified == true) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppText.of(context, listen: false).emailNotVerified),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppText.of(context, listen: false).errorCheckingVerification}: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _resendVerification() async {
    setState(() {
      _isResending = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Configure action code settings for better email experience
        final actionCodeSettings = ActionCodeSettings(
          url: 'https://prolearn-ai-micha.firebaseapp.com/',
          handleCodeInApp: false,
          androidPackageName: 'com.prolearnai.app',
          androidInstallApp: false,
          iOSBundleId: 'com.example.prolearnAi',
        );
        
        await user.sendEmailVerification(actionCodeSettings);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppText.of(context, listen: false).verificationSent),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String errorMessage = AppText.of(context, listen: false).errorSendingVerification;
      
      // Provide specific messages for common errors
      if (e.code == 'too-many-requests') {
        errorMessage = 'Too many requests. Please wait a few minutes before trying again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address. Please check your email.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'User not found. Please register again.';
      } else if (e.message?.contains('400') == true || e.message?.contains('INVALID_') == true) {
        errorMessage = 'Email service is temporarily unavailable. Please try again later or contact support.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: 'Info',
            textColor: Colors.white,
            onPressed: () {
              // Show more detailed error in a dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Email Verification Error'),
                  content: Text(
                    'Error Code: ${e.code}\n\n'
                    'This might be a temporary issue with the email service. '
                    'You can:\n'
                    '1. Wait a few minutes and try again\n'
                    '2. Check your spam folder for previous emails\n'
                    '3. Contact support if the issue persists\n\n'
                    'You can still proceed to use the app, but some features may require email verification.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        showParticles: true,
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8, right: 24),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: colorScheme.onSurface,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Go back',
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: AnimatedCard(
                padding: const EdgeInsets.all(32),
                useGlassmorphism: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
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
                      AppText.of(context).verifyEmailTitle,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppText.of(context).verifyEmailSent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.email ?? AppText.of(context).yourEmail,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_isChecking)
                      const SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      CustomButton(
                        text: AppText.of(context).verifiedButton,
                        onPressed: _checkVerification,
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isResending ? null : _resendVerification,
                      child: _isResending
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(AppText.of(context).resendVerification),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppText.of(context).verifyEmailHint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

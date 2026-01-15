import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/firebase_service.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../state/app_auth_provider.dart';
import '../../widgets/animated_background.dart';
import '../../widgets/animated_card.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _sectionController = TextEditingController();
  final _courseController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final FirebaseService _firebaseService = FirebaseService();
  static const _prefsStudentId = 'profile_student_id';
  static const _prefsSection = 'profile_section';
  static const _prefsCourse = 'profile_course';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _studentIdController.dispose();
    _sectionController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        showParticles: true,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  
                  /// Back Button
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
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  /// Title with gradient
                  Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        AppText.of(context).createAccount,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  /// Form Card with glassmorphism
                  AnimatedCard(
                    padding: const EdgeInsets.all(28),
                    useGlassmorphism: true,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _nameController,
                          label: AppText.of(context).fullName,
                          validator: (v) =>
                              v == null || v.isEmpty
                                  ? AppText.of(context).nameRequired
                                  : null,
                          prefixIcon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _studentIdController,
                          label: AppText.of(context).studentId,
                          validator: (v) => v == null || v.isEmpty
                              ? AppText.of(context).studentIdRequired
                              : null,
                          prefixIcon: Icons.badge_outlined,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _sectionController,
                          label: AppText.of(context).section,
                          validator: (v) => v == null || v.isEmpty
                              ? AppText.of(context).sectionRequired
                              : null,
                          prefixIcon: Icons.group_outlined,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _courseController,
                          label: AppText.of(context).course,
                          validator: (v) => v == null || v.isEmpty
                              ? AppText.of(context).courseRequired
                              : null,
                          prefixIcon: Icons.school_outlined,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _emailController,
                          label: AppText.of(context).emailLabel,
                          validator: Validators.email,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                        ),

                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _passwordController,
                          label: AppText.of(context).passwordLabel,
                          obscureText: _obscurePassword,
                          validator: Validators.password,
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? AppText.of(context).showPassword
                                : AppText.of(context).hidePassword,
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                        ),

                        const SizedBox(height: 24),

                        CustomButton(
                          text: _isLoading
                              ? AppText.of(context).creatingAccount
                              : AppText.of(context).register,
                          onPressed: _isLoading ? null : _register,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    // Prevent multiple submissions
    if (_isLoading) return;

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get and validate inputs
    final name = _nameController.text.trim();
    final studentId = _studentIdController.text.trim();
    final section = _sectionController.text.trim();
    final course = _courseController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    // Additional validation
    if (name.isEmpty ||
        studentId.isEmpty ||
        section.isEmpty ||
        course.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.of(context, listen: false).pleaseFillAllFields,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate email format more strictly
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.of(context, listen: false).invalidEmail,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate password length
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppText.of(context, listen: false).passwordTooShort,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<AppAuthProvider>().register(
        name,
        studentId,
        section,
        course,
        email,
        password,
      );

      // Persist locally for profile fallback.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsStudentId, studentId);
      await prefs.setString(_prefsSection, section);
      await prefs.setString(_prefsCourse, course);

      // Ensure Firestore has the profile data (in case of partial writes).
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firebaseService.setDocument('users', user.uid, {
          'uid': user.uid,
          'name': name,
          'email': email,
          'studentId': studentId,
          'section': section,
          'course': course,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppText.of(context, listen: false).success),
          content: Text(AppText.of(context, listen: false).accountCreated),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(AppText.of(context, listen: false).ok),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                AppText.of(context, listen: false).registrationFailed,
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppText.of(context, listen: false).errorOccurred}: ${e.toString()}',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}

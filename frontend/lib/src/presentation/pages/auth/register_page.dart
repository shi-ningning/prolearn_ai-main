import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/validators.dart';
import '../../state/app_auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _sectionController = TextEditingController();
  final _courseController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _studentIdController.dispose();
    _sectionController.dispose();
    _courseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 480,
                minHeight: size.height - 40,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Text
                    Text(
                      'Create Account',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontSize: 32,
                          ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Sign up to get started',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      icon: Icons.person_outline_rounded,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Name is required' : null,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 16),

                    // Student ID Field
                    _buildTextField(
                      controller: _studentIdController,
                      label: 'Student ID',
                      hint: 'Enter your student ID',
                      icon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty
                          ? 'Student ID is required'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Section Field
                    _buildTextField(
                      controller: _sectionController,
                      label: 'Section',
                      hint: 'Enter your section',
                      icon: Icons.group_outlined,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Section is required' : null,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Course Field
                    _buildTextField(
                      controller: _courseController,
                      label: 'Course',
                      hint: 'Enter your course',
                      icon: Icons.school_outlined,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Course is required' : null,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Email Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      icon: Icons.email_outlined,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Create a strong password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      validator: Validators.password,
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Register Button
                    FilledButton(
                      onPressed: _isLoading ? null : _register,
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 14,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputAction? textInputAction,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              size: 22,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
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
      _showSnackBar('Please fill in all fields', isError: true);
      return;
    }

    // Validate email format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      _showSnackBar('Please enter a valid email address', isError: true);
      return;
    }

    // Validate password length
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters', isError: true);
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

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Show success message
      _showSnackBar(
        'Account created successfully! Redirecting...',
        isError: false,
      );

      // Navigate to dashboard
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      String errorMessage = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already registered';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address';
      } else if (e.message != null) {
        errorMessage = e.message!;
      }

      _showSnackBar(errorMessage, isError: true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('An error occurred: ${e.toString()}', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_text.dart';
import '../../data/services/firebase_service.dart';

class ProfileDialog extends StatefulWidget {
  final User user;
  final FirebaseService firebaseService;

  const ProfileDialog({
    super.key,
    required this.user,
    required this.firebaseService,
  });

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;
  late TextEditingController _sectionController;
  late TextEditingController _courseController;
  
  bool _isEditMode = false;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
    _studentIdController = TextEditingController();
    _sectionController = TextEditingController();
    _courseController = TextEditingController();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    _sectionController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    
    try {
      final firestoreData = await widget.firebaseService.getDocument('users', widget.user.uid) ?? {};
      final prefs = await SharedPreferences.getInstance();
      
      final studentId = firestoreData['studentId']?.toString() ?? 
                       prefs.getString('profile_student_id') ?? '';
      final section = firestoreData['section']?.toString() ?? 
                     prefs.getString('profile_section') ?? '';
      final course = firestoreData['course']?.toString() ?? 
                    prefs.getString('profile_course') ?? '';
      
      setState(() {
        _studentIdController.text = studentId;
        _sectionController.text = section;
        _courseController.text = course;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppText.of(context, listen: false).nameRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Update Firebase Auth display name
      await widget.user.updateDisplayName(_nameController.text.trim());
      await widget.user.reload();

      // Prepare data for Firestore
      final updateData = <String, dynamic>{
        'uid': widget.user.uid,
        'name': _nameController.text.trim(),
        'email': widget.user.email,
        'studentId': _studentIdController.text.trim(),
        'section': _sectionController.text.trim(),
        'course': _courseController.text.trim(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Save to Firestore
      await widget.firebaseService.setDocument('users', widget.user.uid, updateData);

      // Save to SharedPreferences as backup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_student_id', _studentIdController.text.trim());
      await prefs.setString('profile_section', _sectionController.text.trim());
      await prefs.setString('profile_course', _courseController.text.trim());

      if (mounted) {
        setState(() {
          _isEditMode = false;
          _isSaving = false;
        });
        
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppText.of(context, listen: false).profileUpdated),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.of(context).profile,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!_isEditMode && !_isLoading)
                  IconButton(
                    icon: Icon(Icons.edit, color: colorScheme.primary),
                    tooltip: 'Edit Profile',
                    onPressed: () => setState(() => _isEditMode = true),
                  ),
              ],
            ),
          ),
          // Content
          Flexible(
            child: _isLoading
                ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                  // Profile Avatar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  TextField(
                    controller: _nameController,
                    enabled: _isEditMode,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).nameLabel,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Field (Always Disabled)
                  TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).emailLabel,
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Student ID Field
                  TextField(
                    controller: _studentIdController,
                    enabled: _isEditMode,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).studentId,
                      prefixIcon: const Icon(Icons.badge),
                      border: const OutlineInputBorder(),
                      hintText: _isEditMode ? 'Enter Student ID' : null,
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section Field
                  TextField(
                    controller: _sectionController,
                    enabled: _isEditMode,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).section,
                      prefixIcon: const Icon(Icons.group),
                      border: const OutlineInputBorder(),
                      hintText: _isEditMode ? 'Enter Section' : null,
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Course Field
                  TextField(
                    controller: _courseController,
                    enabled: _isEditMode,
                    decoration: InputDecoration(
                      labelText: AppText.of(context).course,
                      prefixIcon: const Icon(Icons.school),
                      border: const OutlineInputBorder(),
                      hintText: _isEditMode ? 'Enter Course' : null,
                      filled: !_isEditMode,
                      fillColor: !_isEditMode ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
                    ),
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                      ],
                    ),
                  ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isEditMode) ...[
                  TextButton(
                    onPressed: _isSaving ? null : () {
                      setState(() => _isEditMode = false);
                      _loadProfileData(); // Reload original data
                    },
                    child: Text(
                      AppText.of(context).cancel,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(AppText.of(context).save),
                  ),
                ],
              ],
            ),
          ),
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

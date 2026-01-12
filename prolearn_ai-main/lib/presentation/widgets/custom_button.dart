import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'interactive_button.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isFullWidth: true,
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
    letterSpacing: -0.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.onBackground,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.onSurface,
    letterSpacing: 0.4,
  );

  // Additional modern text styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
    letterSpacing: -0.25,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
    letterSpacing: 0.15,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    letterSpacing: 0.1,
  );
}

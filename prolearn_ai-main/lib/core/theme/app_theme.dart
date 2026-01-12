import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.onBackground),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.onBackground),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.onBackground),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.onBackground),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.onBackground),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.onSurface),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        shadowColor: AppColors.shadow,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      shadowColor: AppColors.shadow,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      shadowColor: AppColors.shadow,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surface,
      shadowColor: AppColors.shadow,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      tertiary: AppColors.darkTertiary,
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      error: AppColors.darkError,
      onPrimary: AppColors.darkOnPrimary,
      onSecondary: AppColors.darkOnSecondary,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.onError,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkOnBackground),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.darkOnBackground),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.darkOnBackground),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.darkOnBackground),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.darkOnBackground),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.darkOnSurface),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        shadowColor: AppColors.darkShadow,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkCardBackground,
      shadowColor: AppColors.darkShadow,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkOnSurface,
      elevation: 0,
      shadowColor: AppColors.darkShadow,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.darkSurface,
      shadowColor: AppColors.darkShadow,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
    ),
  );
}

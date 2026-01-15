import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle headline(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineSmall ??
        const TextStyle(fontSize: 24);
    return base.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    );
  }

  static TextStyle body(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyLarge ??
        const TextStyle(fontSize: 16);
    return base.copyWith(
      fontSize: 16,
      height: 1.5,
    );
  }

  static TextStyle caption(BuildContext context) {
    final base = Theme.of(context).textTheme.bodySmall ??
        const TextStyle(fontSize: 12);
    return base.copyWith(
      fontSize: 12,
      letterSpacing: 0.4,
    );
  }

  // Additional modern text styles
  static TextStyle titleLarge(BuildContext context) {
    final base = Theme.of(context).textTheme.titleLarge ??
        const TextStyle(fontSize: 22);
    return base.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.25,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    final base = Theme.of(context).textTheme.titleMedium ??
        const TextStyle(fontSize: 16);
    return base.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    );
  }

  static TextStyle labelLarge(BuildContext context) {
    final base = Theme.of(context).textTheme.labelLarge ??
        const TextStyle(fontSize: 14);
    return base.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.primary,
      letterSpacing: 0.1,
    );
  }
}

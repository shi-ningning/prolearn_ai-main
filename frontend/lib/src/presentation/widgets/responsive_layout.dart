import 'package:flutter/material.dart';

/// Responsive layout widget that adapts to screen size
/// Use this to create responsive UIs that work on mobile, tablet, and desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Check if current screen is mobile size (< 600px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// Check if current screen is tablet size (600-1200px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  /// Check if current screen is desktop size (>= 1200px)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  /// Get current breakpoint
  static Breakpoint getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return Breakpoint.desktop;
    if (width >= 600) return Breakpoint.tablet;
    return Breakpoint.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop: >= 1200px
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        }
        // Tablet: 600-1199px
        else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        }
        // Mobile: < 600px
        else {
          return mobile;
        }
      },
    );
  }
}

/// Screen size breakpoints
enum Breakpoint {
  mobile,  // < 600px
  tablet,  // 600-1199px
  desktop, // >= 1200px
}

/// Extension to get responsive values based on screen size
extension ResponsiveValues on BuildContext {
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final width = MediaQuery.of(this).size.width;
    if (width >= 1200) return desktop ?? tablet ?? mobile;
    if (width >= 600) return tablet ?? mobile;
    return mobile;
  }
}

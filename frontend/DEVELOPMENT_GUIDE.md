# Frontend Development Guide

## 🎯 Where to Work: The `lib/` Folder

**All your development happens in the `lib/` folder.** This is your single, unified codebase that works across all platforms.

```
lib/                          ← WORK HERE! Your responsive, cross-platform code
├── core/                     ← Foundation code
├── data/                     ← Business logic & data
├── presentation/             ← UI components
├── routes/                   ← Navigation
└── main.dart                 ← App entry
```

## 🚫 Folders to Ignore

These folders are **Flutter infrastructure** (like `node_modules/` or `.git/`):

```
android/      ← Ignore (Flutter manages this)
ios/          ← Ignore (Flutter manages this)
web/          ← Ignore (Flutter manages this)
linux/        ← Ignore (Flutter manages this)
macos/        ← Ignore (Flutter manages this)
windows/      ← Ignore (Flutter manages this)
build/        ← Ignore (generated files)
```

**You rarely (if ever) need to touch these folders!**

---

## 📱 Responsive Design is Already Built-In

Your `lib/` code automatically adapts to all screen sizes:

### Example: Responsive Layout

```dart
// lib/presentation/widgets/responsive_layout.dart
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

### Usage in Your Pages

```dart
// lib/presentation/pages/dashboard/dashboard_page.dart
@override
Widget build(BuildContext context) {
  return ResponsiveLayout(
    mobile: MobileDashboard(),
    tablet: TabletDashboard(),
    desktop: DesktopDashboard(),
  );
}
```

---

## 🎨 Development Workflow

### 1. **Add New Features in `lib/`**

```
lib/
└── presentation/
    └── pages/
        └── your_new_page/
            ├── your_new_page.dart        ← Create here
            └── widgets/                   ← Page-specific widgets
                └── custom_widget.dart
```

### 2. **Test on Any Platform**

```bash
# Web (fastest for development)
flutter run -d chrome

# Mobile
flutter run -d android
flutter run -d ios

# Desktop
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

**Same code, different platforms!** No changes needed.

### 3. **Platform Folders Update Automatically**

When you run `flutter run`, Flutter automatically:
- Updates platform configurations
- Manages dependencies
- Handles native code

**You don't touch these folders manually!**

---

## 📂 Your Development Structure (Clean & Simple)

```
frontend/
│
├── lib/                           ← YOUR WORKSPACE ✅
│   ├── core/                      ← Add utilities here
│   ├── data/                      ← Add models/services here
│   ├── presentation/              ← Add UI here
│   │   ├── pages/                 ← Add new pages here
│   │   ├── widgets/               ← Add reusable widgets here
│   │   └── state/                 ← Add state providers here
│   └── routes/                    ← Add routes here
│
├── pubspec.yaml                   ← Add packages here
├── .gitignore                     ← Ignores platform folders
│
└── [platform folders]             ← IGNORE THESE ❌
    ├── android/                   ← Auto-managed by Flutter
    ├── ios/                       ← Auto-managed by Flutter
    ├── web/                       ← Auto-managed by Flutter
    ├── linux/                     ← Auto-managed by Flutter
    ├── macos/                     ← Auto-managed by Flutter
    └── windows/                   ← Auto-managed by Flutter
```

---

## ✨ Key Benefits of This Structure

### ✅ Single Source of Truth
- Write code ONCE in `lib/`
- Runs on ALL platforms automatically
- No code duplication

### ✅ Responsive by Default
- Use `MediaQuery`, `LayoutBuilder`, `ResponsiveLayout`
- Adapts to any screen size
- Works on mobile, tablet, desktop

### ✅ Clean Separation
- Your code: `lib/`
- Flutter infrastructure: `[platform folders]`
- Clear and simple

### ✅ Easy to Maintain
- Only maintain ONE codebase
- Platform folders auto-update
- Focus on features, not infrastructure

---

## 🎯 Quick Reference

| Need to... | Work in... |
|-----------|-----------|
| Add new page | `lib/presentation/pages/` |
| Add widget | `lib/presentation/widgets/` |
| Add model | `lib/data/models/` |
| Add service | `lib/data/services/` |
| Add provider | `lib/presentation/state/` |
| Change theme | `lib/core/theme/` |
| Add constants | `lib/core/constants/` |
| Add utility | `lib/core/utils/` |
| Configure app | `pubspec.yaml` |

**Never need to touch:** `android/`, `ios/`, `web/`, etc.

---

## 🚀 Building for Production

```bash
# Web
flutter build web

# Android
flutter build apk --release

# iOS (requires macOS)
flutter build ios --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

Flutter automatically uses the platform folders during build. You don't configure them manually!

---

## 📝 Best Practices

1. **Keep all logic in `lib/`** - Never write code in platform folders
2. **Use responsive widgets** - Make UI adapt to screen size
3. **Test on multiple platforms** - Ensure consistent experience
4. **Ignore platform folders in IDE** - Focus on `lib/`
5. **Use version control** - Commit `lib/` changes, platform folders auto-update

---

## 🎉 Summary

Your frontend IS already a "one folder" structure:

- **`lib/`** = Your development workspace (one folder, all code!)
- **Platform folders** = Infrastructure (ignore, rarely touch)
- **Responsive design** = Built into Flutter, works automatically
- **Cross-platform** = Handled by Flutter, no extra work needed

**Focus on `lib/`, build great features, and let Flutter handle the rest!** 🚀

# Frontend - ProLearnAI Flutter App

A cross-platform learning management application built with Flutter.

## 📱 Supported Platforms

- 🌐 **Web** (Chrome, Firefox, Safari, Edge)
- 📱 **Android** (Android 5.0+)
- 📱 **iOS** (iOS 12.0+)
- 💻 **Windows** (Windows 10+)
- 💻 **macOS** (macOS 10.14+)
- 💻 **Linux** (Ubuntu 18.04+)

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Android Studio / Xcode (for mobile development)
- Chrome (for web development)

### Installation

```bash
# Navigate to frontend directory
cd frontend

# Get dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome

# Run on Android emulator
flutter run

# Run on iOS simulator (macOS only)
flutter run -d "iPhone 14"
```

## 🏗️ Project Structure

```
frontend/
├── lib/
│   ├── core/                  # Core utilities & constants
│   │   ├── constants/         # App-wide constants
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text.dart
│   │   │   └── app_assets.dart
│   │   ├── theme/             # App theming
│   │   │   ├── app_theme.dart
│   │   │   └── text_styles.dart
│   │   └── utils/             # Helper utilities
│   │       ├── logger.dart
│   │       ├── validators.dart
│   │       └── helpers.dart
│   │
│   ├── data/                  # Data layer
│   │   ├── models/            # Data models
│   │   │   ├── user_model.dart
│   │   │   ├── project_model.dart
│   │   │   ├── task_model.dart
│   │   │   └── syllabus_model.dart
│   │   ├── repositories/      # Data access layer
│   │   │   ├── user_repository.dart
│   │   │   ├── project_repository.dart
│   │   │   └── task_repository.dart
│   │   └── services/          # Business logic services
│   │       ├── firebase_service.dart
│   │       ├── ai_service.dart
│   │       └── course_seeder.dart
│   │
│   ├── presentation/          # UI layer
│   │   ├── pages/             # App screens
│   │   │   ├── auth/          # Authentication pages
│   │   │   ├── dashboard/     # Dashboard pages
│   │   │   └── onboarding/    # Onboarding pages
│   │   ├── widgets/           # Reusable widgets
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_textfield.dart
│   │   │   ├── animated_card.dart
│   │   │   └── animated_background.dart
│   │   └── state/             # State management
│   │       ├── app_auth_provider.dart
│   │       ├── project_provider.dart
│   │       ├── task_provider.dart
│   │       └── theme_provider.dart
│   │
│   ├── routes/                # Navigation
│   │   └── app_routes.dart
│   │
│   ├── firebase_options.dart  # Firebase configuration
│   └── main.dart              # App entry point
│
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
├── web/                       # Web-specific code
├── windows/                   # Windows-specific code
├── macos/                     # macOS-specific code
├── linux/                     # Linux-specific code
│
├── test/                      # Unit & widget tests
├── pubspec.yaml               # Dependencies
└── README.md                  # This file
```

## ✨ Features

### Authentication
- ✅ Email/Password registration
- ✅ Email verification
- ✅ Login with email
- ✅ Password validation
- ✅ User profile management

### Project Management
- ✅ Create/Edit/Delete projects
- ✅ Progress tracking (0-100%)
- ✅ Priority levels (Low, Medium, High, Critical)
- ✅ Status management (Active, Completed, On Hold, Archived)
- ✅ Due date tracking
- ✅ Tags and descriptions
- ✅ Filter and sort options

### Task Management
- ✅ Create/Edit/Delete tasks
- ✅ Mark tasks as complete
- ✅ Priority levels
- ✅ Due date reminders
- ✅ Search and filter
- ✅ Sort by multiple criteria

### Learning Features
- ✅ Course/Syllabus tracking
- ✅ Topic progress monitoring
- ✅ Learning analytics
- ✅ Progress visualization

### UI/UX
- ✅ Animated backgrounds with particles
- ✅ Glassmorphism design
- ✅ Dark/Light theme
- ✅ Responsive design
- ✅ Smooth animations
- ✅ Multi-language support (English, Filipino, Bisaya)

## 🎨 Tech Stack

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** Provider
- **Backend:** Firebase
  - Firebase Auth
  - Cloud Firestore
  - Firebase Storage
- **UI Libraries:**
  - Custom animated widgets
  - Material Design 3
- **Navigation:** Named routes
- **Local Storage:** SharedPreferences

## 🔧 Configuration

### Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create or select your project: `prolearn-ai-micha`
3. Download configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
4. Enable Authentication → Email/Password
5. Create Firestore database
6. Update security rules

### Environment Configuration

Firebase options are configured in:
```
lib/firebase_options.dart
```

## 📱 Running the App

### Web Development
```bash
flutter run -d chrome
```

### Android Development
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS Development (macOS only)
```bash
# Run on simulator
flutter run -d "iPhone 14"

# Build for iOS
flutter build ios --release
```

### Desktop Development

**Windows:**
```bash
flutter run -d windows
flutter build windows --release
```

**macOS:**
```bash
flutter run -d macos
flutter build macos --release
```

**Linux:**
```bash
flutter run -d linux
flutter build linux --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test
flutter test test/widget_test.dart
```

## 🐛 Debugging

### Hot Reload
Press `r` in the terminal while the app is running.

### Hot Restart
Press `R` in the terminal while the app is running.

### DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## 📦 Building for Production

### Web
```bash
flutter build web --release
# Output: build/web/
```

### Android
```bash
flutter build apk --release --split-per-abi
# Output: build/app/outputs/flutter-apk/
```

### iOS
```bash
flutter build ipa --release
# Output: build/ios/ipa/
```

## 🚀 Deployment

### Web Hosting (Firebase)
```bash
firebase init hosting
firebase deploy --only hosting
```

### Play Store (Android)
1. Build app bundle: `flutter build appbundle`
2. Sign the bundle
3. Upload to Play Console

### App Store (iOS)
1. Build IPA: `flutter build ipa`
2. Upload via Xcode or Transporter
3. Submit for review

## 🔍 Troubleshooting

### Common Issues

**Issue:** `firebase_core` initialization error
```bash
flutter pub get
flutter clean
flutter run
```

**Issue:** Android build fails
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter run
```

**Issue:** iOS pod install fails
```bash
cd ios
pod install --repo-update
cd ..
flutter run
```

## 📚 Documentation

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Provider State Management](https://pub.dev/packages/provider)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly on all platforms
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

ProLearnAI Development Team

## 📞 Support

For frontend issues, open an issue or contact: support@prolearnai.com

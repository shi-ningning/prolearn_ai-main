# Frontend Refactored Structure

## ✅ New Simplified Structure

The frontend has been refactored to use a cleaner, more standard Dart structure with everything organized under `lib/src/`.

```
frontend/
└── lib/
    └── src/                        ← All source code here
        ├── constants/              ← App constants (formerly core/constants)
        │   ├── app_assets.dart
        │   ├── app_colors.dart
        │   └── app_text.dart
        │
        ├── theme/                  ← App theme (formerly core/theme)
        │   ├── app_theme.dart
        │   └── text_styles.dart
        │
        ├── utils/                  ← Utilities (formerly core/utils)
        │   ├── helpers.dart
        │   ├── logger.dart
        │   ├── theme_helper.dart
        │   └── validators.dart
        │
        ├── data/                   ← Data layer
        │   ├── models/             ← 6 data models
        │   ├── repositories/       ← 5 repositories
        │   └── services/           ← 6 services
        │
        ├── presentation/           ← UI layer
        │   ├── auth/               ← Auth components
        │   ├── pages/              ← All screens
        │   │   ├── auth/           ← Auth pages
        │   │   ├── dashboard/      ← Dashboard pages
        │   │   └── onboarding/     ← Onboarding
        │   ├── state/              ← State management (8 providers)
        │   └── widgets/            ← Reusable widgets (12 widgets)
        │
        ├── routes/                 ← App navigation
        │   └── app_routes.dart
        │
        ├── main.dart               ← App entry point
        └── firebase_options.dart   ← Firebase configuration
```

## 📝 What Changed

### **Before:**
```
lib/
├── core/                    ← Extra nesting
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/
├── presentation/
├── routes/
├── main.dart
└── firebase_options.dart
```

### **After:**
```
lib/
└── src/                     ← Everything in one organized src/ folder
    ├── constants/           ← Flattened from core/constants
    ├── theme/               ← Flattened from core/theme
    ├── utils/               ← Flattened from core/utils
    ├── data/
    ├── presentation/
    ├── routes/
    ├── main.dart
    └── firebase_options.dart
```

## ✨ Benefits

### ✅ Cleaner Structure
- All source code in one `src/` folder
- No unnecessary `core/` nesting
- Standard Dart project layout

### ✅ Better Organization
- Related files grouped logically
- Flatter hierarchy = easier navigation
- Clear separation of concerns

### ✅ Easier Imports
```dart
// Before
import '../../../core/utils/logger.dart';
import '../../../core/theme/app_theme.dart';

// After  
import '../../utils/logger.dart';
import '../../theme/app_theme.dart';
```

## 🎯 Folder Purposes

| Folder | Purpose | Examples |
|--------|---------|----------|
| `constants/` | App-wide constants | Colors, assets, text strings |
| `theme/` | Theme configuration | App theme, text styles |
| `utils/` | Helper utilities | Logger, validators, helpers |
| `data/` | Data layer | Models, repositories, services |
| `presentation/` | UI layer | Pages, widgets, state |
| `routes/` | Navigation | Route definitions |

## 🚀 Development Workflow

### Adding New Features

```
lib/src/
├── presentation/
│   ├── pages/
│   │   └── your_new_page/
│   │       └── your_page.dart       ← Add new pages here
│   │
│   ├── widgets/
│   │   └── your_widget.dart         ← Add reusable widgets here
│   │
│   └── state/
│       └── your_provider.dart       ← Add state management here
│
├── data/
│   ├── models/
│   │   └── your_model.dart          ← Add data models here
│   │
│   ├── repositories/
│   │   └── your_repository.dart     ← Add repositories here
│   │
│   └── services/
│       └── your_service.dart        ← Add services here
│
├── constants/
│   └── Add app-wide constants here
│
├── theme/
│   └── Modify app theme here
│
└── utils/
    └── Add utility functions here
```

### Import Examples

```dart
// Importing from same directory
import 'user_model.dart';

// Importing from sibling directory
import '../models/user_model.dart';

// Importing from utils
import '../../utils/logger.dart';

// Importing from theme
import '../../theme/app_theme.dart';

// Importing from constants
import '../../constants/app_colors.dart';
```

## 📦 All Your Code is Still in One Place

Remember: The platform folders (`android/`, `ios/`, `web/`, etc.) are still Flutter infrastructure.

```
frontend/
├── lib/
│   └── src/              ← YOUR WORKSPACE ✅
│       └── [all your code]
│
└── [platform folders]    ← INFRASTRUCTURE (ignore)
    ├── android/
    ├── ios/
    ├── web/
    ├── linux/
    ├── macos/
    └── windows/
```

**Your development happens in `lib/src/` - focus there!**

## ✅ Migration Complete

All imports have been automatically updated to reflect the new structure. Your app should work exactly as before, just with a cleaner organization.

---

**Last Updated:** 2026-01-15

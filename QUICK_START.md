# ProLearnAI - Quick Start Guide

This guide will help you get ProLearnAI up and running quickly.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.x or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Node.js** (18.x or higher) - [Install Node.js](https://nodejs.org/)
- **Firebase CLI** - Install with: `npm install -g firebase-tools`
- **Git** - [Install Git](https://git-scm.com/)
- **VS Code** or **Android Studio** (recommended for Flutter development)

## 🚀 Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/prolearn_ai.git
cd prolearn_ai-main
```

### 2. Frontend Setup (Flutter)

```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Run the app (choose your platform)
flutter run                 # For connected device/emulator
flutter run -d chrome       # For web
flutter run -d windows      # For Windows desktop
```

**Important Frontend Files:**
- `lib/firebase_options.dart` - Firebase configuration
- `lib/main.dart` - App entry point
- `pubspec.yaml` - Dependencies

**Frontend Structure:**
```
frontend/lib/
├── core/           # Constants, theme, utilities
├── data/           # Models, repositories, services
├── presentation/   # UI pages, widgets, state
└── routes/         # App navigation
```

### 3. Backend Setup

#### Install Backend Dependencies

```bash
# Navigate to backend directory
cd backend

# Install API dependencies
npm install

# Install Functions dependencies
cd src/functions
npm install
cd ../..
```

#### Setup REST API (Express.js)

```bash
# From backend directory
cd backend

# Create environment file
cp env.example .env

# Edit .env and add your credentials
# Required: FIREBASE_PROJECT_ID, FIREBASE_PRIVATE_KEY, etc.

# Run in development mode
npm run dev
```

API will be available at: `http://localhost:3000`

#### Setup Cloud Functions

```bash
# Navigate to functions directory
cd backend/src/functions

# Login to Firebase
firebase login

# Initialize Firebase (if needed)
firebase init

# Start local emulators
cd ../  # Back to backend root
firebase emulators:start
```

Emulator UI will be available at: `http://localhost:4000`

### 4. Database Setup

#### Firestore Security Rules

```bash
cd backend

# Deploy Firestore rules and indexes
firebase deploy --only firestore:rules,firestore:indexes
```

#### Seed Sample Data

```bash
cd backend/database/firestore/seed

# Run seed script (requires Firebase Admin SDK setup)
npx ts-node seed-data.ts
```

## 🧪 Testing

### Frontend Tests

```bash
cd frontend
flutter test
```

### Backend Tests

```bash
# Test API
cd backend
npm test

# Test Functions
cd backend/functions
npm test
```

## 📱 Running the App

### Mobile (Android/iOS)

1. Connect your device or start an emulator
2. Run:
```bash
cd frontend
flutter run
```

### Web

```bash
cd frontend
flutter run -d chrome
```

### Desktop (Windows/Linux/macOS)

```bash
cd frontend
flutter run -d windows  # or linux, macos
```

## 🔧 Development Workflow

### Frontend Development

```bash
cd frontend

# Hot reload is enabled by default
flutter run

# Build for production
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
```

### Backend Development

#### API Development

```bash
cd backend

# Development mode with hot reload
npm run dev

# Build for production
npm run build

# Run production build
npm start
```

#### Functions Development

```bash
cd backend

# Start emulators
firebase emulators:start

# Deploy functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:functionName
```

## 📊 Accessing Services

### Frontend
- **Mobile/Desktop App**: Run with Flutter
- **Web App**: http://localhost:8080 (when running `flutter run -d chrome`)

### Backend
- **API**: http://localhost:3000
- **API Health Check**: http://localhost:3000/health
- **API Docs**: http://localhost:3000/api

### Firebase Emulators
- **Emulator UI**: http://localhost:4000
- **Firestore**: http://localhost:8080
- **Functions**: http://localhost:5001
- **Auth**: http://localhost:9099

## 🐛 Troubleshooting

### Flutter Issues

**Problem:** "Flutter SDK not found"
```bash
flutter doctor
```

**Problem:** Dependencies not installing
```bash
flutter clean
flutter pub get
```

### Backend Issues

**Problem:** "Cannot find module"
```bash
cd backend/api  # or backend/functions
rm -rf node_modules
npm install
```

**Problem:** Firebase authentication error
- Ensure `.env` file has correct Firebase credentials
- Check Firebase project ID in `.firebaserc`

### Common Errors

**Port already in use:**
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:3000 | xargs kill -9
```

**Firebase CLI not authenticated:**
```bash
firebase logout
firebase login
```

## 📚 Next Steps

1. **Read the Documentation**
   - [Project Structure](PROJECT_STRUCTURE.md)
   - [Frontend README](frontend/README.md)
   - [Backend README](backend/README.md)

2. **Explore the Code**
   - Frontend: `frontend/lib/`
   - Backend API: `backend/src/` (controllers, routes, middleware)
   - Cloud Functions: `backend/src/functions/src/`
   - Database: `backend/src/database/`

3. **Customize**
   - Update Firebase configuration
   - Modify app theme in `frontend/lib/core/theme/`
   - Add new API endpoints in `backend/src/routes/`
   - Modify database rules in `backend/src/database/firestore/firestore.rules`

4. **Deploy**
   - Frontend: `flutter build web` → Firebase Hosting
   - Backend: `firebase deploy --only functions`

## 🆘 Getting Help

- **Documentation**: See `PROJECT_STRUCTURE.md` for detailed architecture
- **Issues**: Open an issue on GitHub
- **Email**: support@prolearnai.com

## ✅ Checklist

Before starting development, make sure you have:

- [ ] Flutter SDK installed and configured
- [ ] Node.js and npm installed
- [ ] Firebase CLI installed
- [ ] Firebase project created
- [ ] Frontend dependencies installed (`flutter pub get`)
- [ ] Backend API dependencies installed (`cd backend && npm install`)
- [ ] Backend Functions dependencies installed (`cd backend/src/functions && npm install`)
- [ ] Environment variables configured (`backend/.env`)
- [ ] Firebase emulators tested
- [ ] App runs successfully on at least one platform

## 🎉 You're Ready!

Congratulations! You now have ProLearnAI running locally. Happy coding!

---

**Need more help?** Check out the detailed [Project Structure](PROJECT_STRUCTURE.md) documentation.

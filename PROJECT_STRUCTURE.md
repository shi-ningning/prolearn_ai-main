# ProLearnAI - Project Structure

Complete project structure for the ProLearnAI learning management system.

## 📁 Directory Structure

```
prolearn_ai-main/
│
├── frontend/                    # Flutter Mobile & Web Application
│   ├── lib/
│   │   ├── core/               # Core utilities and constants
│   │   │   ├── constants/      # App-wide constants
│   │   │   ├── theme/          # Theme configuration
│   │   │   └── utils/          # Helper functions
│   │   │
│   │   ├── data/               # Data layer
│   │   │   ├── models/         # Data models
│   │   │   ├── repositories/   # Repository pattern implementations
│   │   │   └── services/       # External services (Firebase, AI, etc.)
│   │   │
│   │   ├── presentation/       # Presentation layer
│   │   │   ├── pages/          # App screens/pages
│   │   │   ├── widgets/        # Reusable widgets
│   │   │   └── state/          # State management (Providers)
│   │   │
│   │   ├── routes/             # App routing
│   │   └── main.dart           # App entry point
│   │
│   ├── android/                # Android platform files
│   ├── ios/                    # iOS platform files
│   ├── web/                    # Web platform files
│   ├── linux/                  # Linux platform files
│   ├── macos/                  # macOS platform files
│   ├── windows/                # Windows platform files
│   │
│   ├── pubspec.yaml            # Flutter dependencies
│   ├── analysis_options.yaml  # Dart linter rules
│   └── README.md               # Frontend documentation
│
├── backend/                     # Backend Services
│   │
│   ├── src/                    # All Backend Source Code
│   │   ├── controllers/        # REST API request handlers
│   │   ├── middleware/         # REST API middleware
│   │   ├── routes/             # REST API routes
│   │   ├── validators/         # Request validation schemas
│   │   ├── index.ts            # API entry point
│   │   │
│   │   ├── database/           # Database Schemas & Configuration
│   │   │   ├── firestore/      # Firestore (NoSQL)
│   │   │   │   ├── seed/       # Seed data scripts
│   │   │   │   ├── schema.md   # Schema documentation
│   │   │   │   ├── firestore.rules      # Security rules
│   │   │   │   └── firestore.indexes.json
│   │   │   ├── postgres/       # PostgreSQL (future)
│   │   │   │   ├── migrations/ # Database migrations
│   │   │   │   ├── seeds/      # Seed data
│   │   │   │   └── schema.sql  # SQL schema
│   │   │   └── README.md
│   │   │
│   │   └── functions/          # Firebase Cloud Functions
│   │   ├── src/
│   │   │   ├── auth/           # Authentication triggers
│   │   │   ├── firestore/      # Firestore triggers
│   │   │   ├── http/           # HTTP callable functions
│   │   │   ├── scheduled/      # Scheduled functions
│   │   │   └── index.ts        # Functions entry point
│   │   │
│   │   ├── package.json        # Functions dependencies
│   │   ├── tsconfig.json       # TypeScript configuration
│   │   ├── .gitignore
│   │   └── README.md           # Functions documentation
│   │
│   ├── database/               # Database Schemas & Configuration
│   │   ├── firestore/          # Firestore (NoSQL)
│   │   │   ├── seed/           # Seed data scripts
│   │   │   ├── schema.md       # Schema documentation
│   │   │   ├── firestore.rules # Security rules
│   │   │   └── firestore.indexes.json
│   │   │
│   │   ├── postgres/           # PostgreSQL (future use)
│   │   │   ├── migrations/     # Database migrations
│   │   │   ├── seeds/          # Seed data
│   │   │   └── schema.sql      # SQL schema
│   │   │
│   │   └── README.md           # Database documentation
│   │
│   ├── dist/                   # Compiled JavaScript (generated)
│   ├── package.json            # Dependencies and scripts
│   ├── tsconfig.json           # TypeScript configuration
│   ├── firebase.json           # Firebase configuration
│   ├── .firebaserc             # Firebase project config
│   ├── .gitignore
│   ├── .prettierrc
│   ├── env.example             # Environment variables template
│   └── README.md               # Backend documentation
│
└── README.md                    # Main project documentation
```

## 🎯 Architecture Overview

### Frontend (Flutter)

The frontend follows a **clean architecture** pattern with clear separation of concerns:

- **Core Layer**: Contains constants, themes, utilities
- **Data Layer**: Models, repositories, and services
- **Presentation Layer**: UI screens, widgets, and state management
- **Routing**: Centralized navigation configuration

**Tech Stack:**
- Flutter SDK
- Provider (State Management)
- Firebase SDK
- Material Design 3

### Backend (Node.js/TypeScript)

The backend is split into three main components:

#### 1. REST API (`backend/src/` - root level)

Express.js REST API for custom business logic:
- User authentication and management
- Project and task operations
- Analytics and reporting
- Admin operations

**Tech Stack:**
- Express.js
- TypeScript
- Firebase Admin SDK
- PostgreSQL (planned)
- Redis (planned)

**API Structure:**
```
src/
├── controllers/    # Request handlers (auth, user, project, task, analytics, admin)
├── routes/         # API endpoints
├── middleware/     # Authentication, validation, error handling
├── validators/     # Input validation schemas
└── index.ts        # API entry point
```

#### 2. Cloud Functions (`backend/src/functions/`)

Serverless functions for automated tasks:
- Authentication triggers
- Database triggers
- Scheduled tasks (cron jobs)
- HTTP endpoints

**Tech Stack:**
- Firebase Cloud Functions
- TypeScript
- Firebase Admin SDK

#### 3. Database (`backend/src/database/`)

Database schemas and configurations:
- **Firestore**: Primary NoSQL database
- **PostgreSQL**: Future analytics database

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (3.x or higher)
- **Node.js** (18.x or higher)
- **npm** or **yarn**
- **Firebase CLI** (`npm install -g firebase-tools`)
- **Git**

### Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

### Backend Setup

#### Install Dependencies
```bash
# Backend API
cd backend
npm install

# Cloud Functions
cd src/functions
npm install
```

#### Run API Locally
```bash
cd backend
npm run dev
```

API will be available at `http://localhost:3000`

#### Run Cloud Functions Locally
```bash
cd backend
firebase emulators:start
```

## 📦 Key Features

### Frontend Features
- ✅ User Authentication (Email/Password)
- ✅ Email Verification
- ✅ Dashboard with Analytics
- ✅ Project Management
- ✅ Task Tracking
- ✅ Progress Monitoring
- ✅ Syllabus/Course Management
- ✅ Multi-language Support (EN, FIL, CEB)
- ✅ Dark/Light Theme
- ✅ Responsive Design (Mobile & Web)

### Backend Features
- ✅ RESTful API
- ✅ Firebase Authentication
- ✅ Cloud Firestore Database
- ✅ Cloud Functions
- ✅ Automated Email Notifications
- ✅ Scheduled Tasks
- ✅ Analytics & Reporting
- 🚧 PostgreSQL Integration (Planned)
- 🚧 Redis Caching (Planned)

## 🔐 Security

- Firebase Authentication with email verification
- Firestore Security Rules
- JWT token validation
- CORS configuration
- Rate limiting (planned)
- Input validation and sanitization

## 📝 Environment Variables

### Frontend

Configure in `frontend/lib/firebase_options.dart`:
- Firebase project configuration (auto-generated)

### Backend API

Create `backend/.env`:
```env
NODE_ENV=development
PORT=3000
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_CLIENT_EMAIL=your-service-account@...
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n..."
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
```

### Cloud Functions

Configure via Firebase:
```bash
firebase functions:config:set sendgrid.api_key="YOUR_KEY"
```

## 🧪 Testing

### Frontend Tests
```bash
cd frontend
flutter test
```

### Backend Tests
```bash
# API tests
cd backend
npm test

# Functions tests
cd backend/src/functions
npm test
```

## 🚀 Deployment

### Frontend Deployment

**Web:**
```bash
cd frontend
flutter build web
firebase deploy --only hosting
```

**Mobile:**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Backend Deployment

**API:**
```bash
cd backend
npm run build
# Deploy to your preferred platform (Heroku, AWS, Google Cloud Run, etc.)
```

**Cloud Functions:**
```bash
cd backend
firebase deploy --only functions
```

**Database Rules:**
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

## 📚 Documentation

- [Frontend README](frontend/README.md)
- [Backend README](backend/README.md)
- [Functions Documentation](backend/src/functions/README.md)
- [Database Schema](backend/src/database/README.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

ProLearnAI Development Team

## 📞 Support

For support, email support@prolearnai.com or open an issue.

---

**Last Updated:** 2026-01-15

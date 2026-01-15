# Backend - ProLearnAI

Backend services for the ProLearnAI learning management system.

## 📁 Structure

```
backend/
├── src/                    # Backend source code
│   ├── controllers/        # API request handlers
│   ├── routes/             # API endpoints
│   ├── middleware/         # API middleware
│   ├── validators/         # Input validation
│   ├── index.ts            # API entry point
│   ├── database/           # Database schemas and rules
│   └── functions/          # Firebase Cloud Functions
├── dist/                   # Compiled JavaScript (generated)
├── package.json            # Dependencies and scripts
├── tsconfig.json           # TypeScript configuration
├── firebase.json           # Firebase configuration
└── README.md               # This file
```

## 🔥 Current Setup: Firebase (BaaS)

The project currently uses **Firebase** as Backend-as-a-Service:

### Services Used:
- **Firebase Authentication** - User authentication & email verification
- **Cloud Firestore** - NoSQL database for:
  - Users
  - Projects
  - Tasks
  - Syllabi/Courses
  - Topic Progress
- **Firebase Storage** - File storage (future use)
- **Firebase Hosting** - Web app hosting

### Firebase Configuration

The Firebase configuration is in the Flutter app:
- `frontend/lib/firebase_options.dart`
- `frontend/firebase.json`
- `frontend/android/app/google-services.json`

## 🚀 Backend Services

### 1. REST API

Location: `backend/src/` (root level files)

**Purpose:**
- Custom business logic
- User authentication and authorization
- Project and task management
- Third-party integrations
- Admin operations
- Analytics and reporting

**Tech Stack:**
- Node.js + Express.js
- TypeScript
- Firebase Admin SDK
- PostgreSQL (planned for analytics)
- Redis (planned for caching)

**API Structure:**
```
src/
├── controllers/    # Request handlers (auth, user, project, task, analytics, admin)
├── routes/         # API endpoints
├── middleware/     # Auth, validation, error handling
├── validators/     # Request validation schemas
└── index.ts        # API entry point
```

### 2. Cloud Functions

Location: `backend/src/functions/`

**Use Cases:**
- Automated email notifications
- Data aggregation
- Scheduled tasks
- Webhooks
- AI/ML inference

### 3. Database

Location: `backend/src/database/`

**Contents:**
- Firestore schema documentation
- Security rules
- Firestore indexes
- Data migration scripts

## 🛠️ Setup Instructions

### Firebase Cloud Functions

```bash
cd src/functions
npm install
npm run build
cd ../..
firebase deploy --only functions
```

### REST API

```bash
# Install dependencies
npm install

# Create environment file
cp env.example .env
# Edit .env with your Firebase credentials

# Run in development mode
npm run dev

# Build for production
npm run build

# Run production build
npm start
```

API will be available at: `http://localhost:3000`

## 📊 Database Schema

### Firestore Collections

#### `users`
```json
{
  "uid": "string",
  "email": "string",
  "name": "string",
  "studentId": "string",
  "section": "string",
  "course": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### `projects`
```json
{
  "id": "string",
  "userId": "string",
  "title": "string",
  "description": "string",
  "status": "active|completed|onHold|archived",
  "priority": "low|medium|high|critical",
  "progress": "number (0-100)",
  "tags": ["string"],
  "createdAt": "timestamp",
  "dueDate": "timestamp",
  "completedAt": "timestamp"
}
```

#### `tasks`
```json
{
  "id": "string",
  "userId": "string",
  "title": "string",
  "description": "string",
  "isCompleted": "boolean",
  "priority": "low|medium|high",
  "dueDate": "timestamp",
  "createdAt": "timestamp",
  "completedAt": "timestamp"
}
```

#### `syllabi`
```json
{
  "id": "string",
  "title": "string",
  "description": "string",
  "topics": [
    {
      "id": "string",
      "title": "string",
      "description": "string"
    }
  ],
  "createdAt": "timestamp"
}
```

## 🔐 Security Rules

Firestore security rules are managed through Firebase Console.

**Current Rules:**
- Users can only read/write their own data
- Authentication required for all operations
- Email verification required for certain features

## 🧪 Testing

```bash
# API tests
npm test
npm run test:watch
npm run test:coverage

# Firebase emulators
npm run emulators

# Functions tests
cd src/functions && npm test
```

## 📝 Environment Variables

Create a `.env` file in the backend directory:

```env
# Firebase Admin SDK
FIREBASE_PROJECT_ID=prolearn-ai-micha
FIREBASE_CLIENT_EMAIL=your-service-account@prolearn-ai-micha.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY=your-private-key

# API Configuration
PORT=3000
NODE_ENV=development

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/prolearn

# External APIs
OPENAI_API_KEY=your-openai-key
```

## 📚 Documentation

- [Firebase Console](https://console.firebase.google.com/project/prolearn-ai-micha)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Cloud Functions Documentation](https://firebase.google.com/docs/functions)

## 🔄 Deployment

### REST API
```bash
# Build the API
npm run build

# Deploy to your preferred hosting service
# e.g., Heroku, AWS, Google Cloud Run, etc.
```

### Firebase Functions
```bash
npm run deploy:functions
```

### Database Rules & Indexes
```bash
npm run deploy:rules
```

## 📞 Support

For backend-related issues, contact the development team or open an issue.

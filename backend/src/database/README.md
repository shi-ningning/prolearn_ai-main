# Database - Schema & Configuration

Database schemas, security rules, and migration scripts for ProLearnAI.

## 🗄️ Database Types

### 1. Cloud Firestore (Primary)
- **Type:** NoSQL Document Database
- **Use:** Main application data
- **Provider:** Firebase/Google Cloud

### 2. PostgreSQL (Planned)
- **Type:** Relational Database
- **Use:** Complex queries, reporting, analytics
- **Provider:** Cloud SQL / Supabase

## 📁 Structure

```
database/
├── firestore/
│   ├── schema.md          # Firestore collections schema
│   ├── rules.rules        # Security rules
│   ├── indexes.json       # Composite indexes
│   └── seed/              # Seed data scripts
├── postgres/
│   ├── schema.sql         # SQL schema
│   ├── migrations/        # Database migrations
│   └── seeds/             # Seed data
└── README.md              # This file
```

## 🔥 Firestore Schema

### Collections Overview

```
firestore/
├── users/                 # User profiles
├── projects/              # User projects
├── tasks/                 # User tasks
├── syllabi/               # Course syllabi
├── topicProgress/         # Topic completion tracking
└── stats/                 # User statistics
```

### Detailed Schema

#### `users` Collection
```javascript
{
  uid: string,              // Firebase Auth UID (document ID)
  email: string,
  name: string,
  studentId: string,
  section: string,
  course: string,
  createdAt: timestamp,
  updatedAt: timestamp,
  emailVerified: boolean,
  photoURL: string?,
  preferences: {
    theme: 'light' | 'dark' | 'system',
    language: 'en' | 'fil' | 'ceb',
    notifications: boolean
  }
}
```

#### `projects` Collection
```javascript
{
  id: string,               // Auto-generated
  userId: string,           // Owner user ID
  title: string,
  description: string,
  status: 'active' | 'completed' | 'onHold' | 'archived',
  priority: 'low' | 'medium' | 'high' | 'critical',
  progress: number,         // 0-100
  tags: string[],
  color: string?,           // Hex color
  createdAt: timestamp,
  updatedAt: timestamp,
  dueDate: timestamp?,
  completedAt: timestamp?
}
```

#### `tasks` Collection
```javascript
{
  id: string,
  userId: string,
  title: string,
  description: string,
  isCompleted: boolean,
  priority: 'low' | 'medium' | 'high',
  dueDate: timestamp?,
  createdAt: timestamp,
  completedAt: timestamp?,
  projectId: string?        // Optional link to project
}
```

#### `syllabi` Collection
```javascript
{
  id: string,
  title: string,
  description: string,
  courseCode: string,
  topics: [
    {
      id: string,
      title: string,
      description: string,
      order: number
    }
  ],
  createdAt: timestamp,
  updatedAt: timestamp
}
```

#### `topicProgress` Collection
```javascript
{
  id: string,
  userId: string,
  syllabusId: string,
  topicId: string,
  completed: boolean,
  completedAt: timestamp?,
  notes: string?
}
```

## 🔐 Security Rules

### Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Projects collection
    match /projects/{projectId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               resource.data.userId == request.auth.uid;
    }
    
    // Tasks collection
    match /tasks/{taskId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && 
                       request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               resource.data.userId == request.auth.uid;
    }
    
    // Syllabi collection (public read)
    match /syllabi/{syllabusId} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only (via backend)
    }
    
    // Topic progress
    match /topicProgress/{progressId} {
      allow read: if request.auth != null && 
                     resource.data.userId == request.auth.uid;
      allow write: if request.auth != null && 
                      request.resource.data.userId == request.auth.uid;
    }
  }
}
```

## 📊 Composite Indexes

Required for complex queries:

```json
{
  "indexes": [
    {
      "collectionGroup": "projects",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "projects",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "tasks",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "userId", "order": "ASCENDING" },
        { "fieldPath": "isCompleted", "order": "ASCENDING" },
        { "fieldPath": "dueDate", "order": "ASCENDING" }
      ]
    }
  ]
}
```

## 🌱 Seed Data

### Development Seed Script

```bash
# Run seed script
firebase emulators:start --import=./seed-data
```

### Sample Data

```javascript
// Sample users
const sampleUsers = [
  {
    uid: 'user1',
    email: 'student@example.com',
    name: 'Sample Student',
    studentId: '2024-0001',
    section: 'CS-3A',
    course: 'Computer Science'
  }
];

// Sample projects
const sampleProjects = [
  {
    userId: 'user1',
    title: 'Final Year Project',
    description: 'Complete final year thesis',
    status: 'active',
    priority: 'high',
    progress: 35,
    tags: ['thesis', 'research']
  }
];
```

## 🔄 Migrations

### Firestore Data Migration

```typescript
// Example migration script
async function migrateUserData() {
  const users = await admin.firestore().collection('users').get();
  
  const batch = admin.firestore().batch();
  users.docs.forEach(doc => {
    batch.update(doc.ref, {
      emailVerified: false, // Add new field
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
  });
  
  await batch.commit();
  console.log('Migration complete!');
}
```

## 📚 Documentation

- [Firestore Data Model](https://firebase.google.com/docs/firestore/data-model)
- [Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Indexes](https://firebase.google.com/docs/firestore/query-data/indexing)

## 🛠️ Tools

### Backup & Restore
```bash
# Export Firestore data
gcloud firestore export gs://backup-bucket/

# Import Firestore data
gcloud firestore import gs://backup-bucket/[EXPORT_PREFIX]/
```

### Query Testing
```bash
# Start Firestore emulator
firebase emulators:start --only firestore

# Access emulator UI
open http://localhost:4000
```

## 📞 Support

For database schema questions, contact the backend team.

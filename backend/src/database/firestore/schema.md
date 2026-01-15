# Firestore Database Schema

## Overview

This document describes the Firestore database schema for ProLearnAI.

## Collections

### 1. `users`

User profiles and account information.

**Document ID:** Firebase Auth UID

```typescript
interface User {
  uid: string;
  email: string;
  name: string;
  studentId: string;
  section: string;
  course: string;
  emailVerified: boolean;
  photoURL?: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;
  preferences: {
    theme: 'light' | 'dark' | 'system';
    language: 'en' | 'fil' | 'ceb';
    notifications: boolean;
  };
}
```

**Indexes:**
- `email` (ASC)
- `createdAt` (DESC)

---

### 2. `projects`

User projects and their details.

**Document ID:** Auto-generated

```typescript
interface Project {
  id: string;
  userId: string;
  title: string;
  description: string;
  status: 'active' | 'completed' | 'onHold' | 'archived';
  priority: 'low' | 'medium' | 'high' | 'critical';
  progress: number; // 0-100
  tags: string[];
  color?: string; // Hex color code
  createdAt: Timestamp;
  updatedAt: Timestamp;
  dueDate?: Timestamp;
  completedAt?: Timestamp;
}
```

**Indexes:**
- `userId` (ASC), `status` (ASC), `createdAt` (DESC)
- `userId` (ASC), `createdAt` (DESC)
- `userId` (ASC), `dueDate` (ASC)

---

### 3. `tasks`

Individual tasks for users.

**Document ID:** Auto-generated

```typescript
interface Task {
  id: string;
  userId: string;
  title: string;
  description: string;
  isCompleted: boolean;
  priority: 'low' | 'medium' | 'high';
  dueDate?: Timestamp;
  createdAt: Timestamp;
  completedAt?: Timestamp;
  projectId?: string; // Optional link to project
}
```

**Indexes:**
- `userId` (ASC), `isCompleted` (ASC), `dueDate` (ASC)
- `userId` (ASC), `createdAt` (DESC)
- `projectId` (ASC), `isCompleted` (ASC)

---

### 4. `syllabi`

Course syllabi and topics.

**Document ID:** Auto-generated

```typescript
interface Syllabus {
  id: string;
  title: string;
  description: string;
  courseCode: string;
  topics: Topic[];
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

interface Topic {
  id: string;
  title: string;
  description: string;
  order: number;
}
```

**Indexes:**
- `courseCode` (ASC)
- `createdAt` (DESC)

---

### 5. `topicProgress`

User progress tracking for syllabus topics.

**Document ID:** Auto-generated

```typescript
interface TopicProgress {
  id: string;
  userId: string;
  syllabusId: string;
  topicId: string;
  completed: boolean;
  completedAt?: Timestamp;
  notes?: string;
}
```

**Indexes:**
- `userId` (ASC), `syllabusId` (ASC)
- `userId` (ASC), `completed` (ASC)
- `syllabusId` (ASC), `topicId` (ASC)

---

### 6. `stats`

User statistics and metrics.

**Document ID:** User ID

```typescript
interface Stats {
  userId: string;
  projectsCount: number;
  projectsCompleted: number;
  tasksCompleted: number;
  totalTasks: number;
  studyStreak: number; // Days
  lastActivityDate?: Timestamp;
  joinedAt: Timestamp;
}
```

**Indexes:**
- `studyStreak` (DESC)
- `projectsCompleted` (DESC)

---

### 7. `analytics` (Admin only)

System-wide analytics data.

**Document ID:** Auto-generated

```typescript
interface Analytics {
  week: string; // ISO date string
  totalUsers: number;
  totalProjects: number;
  totalTasks: number;
  totalCompletedTasks: number;
  completionRate: number; // Percentage
  createdAt: Timestamp;
}
```

---

## Security Rules

See `firestore.rules` for detailed security rules.

**Key Principles:**
- Users can only access their own data
- Authentication required for all operations
- Admin operations handled via Cloud Functions
- Syllabi are read-only for regular users

---

## Data Relationships

```
User (1) ──── (n) Projects
User (1) ──── (n) Tasks
User (1) ──── (n) TopicProgress
User (1) ──── (1) Stats

Syllabus (1) ──── (n) TopicProgress
Project (1) ──── (n) Tasks (optional)
```

---

## Best Practices

1. **Use batch writes** for multiple related operations
2. **Implement pagination** for large collections
3. **Use subcollections** sparingly (none in current schema)
4. **Index frequently queried fields**
5. **Use server timestamps** for consistency
6. **Validate data** on client and server
7. **Implement soft deletes** where appropriate

---

## Migration Strategy

When schema changes are needed:

1. Create migration script in `migrations/`
2. Test in development environment
3. Run migration in staging
4. Deploy to production with monitoring
5. Document changes in this file

---

Last updated: 2026-01-15

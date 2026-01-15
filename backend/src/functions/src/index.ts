/**
 * Firebase Cloud Functions for ProLearnAI
 * 
 * This file exports all cloud functions for the application.
 */

import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK
admin.initializeApp();

// Export all function modules
export * from './auth/onUserCreate';
export * from './auth/onUserDelete';
export * from './firestore/onProjectUpdate';
export * from './firestore/onTaskComplete';
export * from './http/sendVerificationReminder';
export * from './http/generateReport';
export * from './scheduled/dailyProgressReport';
export * from './scheduled/cleanupExpiredSessions';
export * from './scheduled/weeklyAnalytics';

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Trigger: When a new user is created in Firebase Auth
 * Action: Create user profile in Firestore and send welcome email
 */
export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  const { uid, email, displayName } = user;

  try {
    // Create user document in Firestore
    await admin.firestore().collection('users').doc(uid).set({
      uid,
      email: email || '',
      name: displayName || '',
      emailVerified: user.emailVerified || false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      studentId: '',
      section: '',
      course: '',
      preferences: {
        theme: 'system',
        language: 'en',
        notifications: true
      }
    });

    // Initialize user statistics
    await admin.firestore().collection('stats').doc(uid).set({
      userId: uid,
      projectsCount: 0,
      tasksCompleted: 0,
      totalTasks: 0,
      studyStreak: 0,
      joinedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    // TODO: Send welcome email
    console.log(`✅ User profile created for ${email}`);

    return { success: true };
  } catch (error) {
    console.error('Error creating user profile:', error);
    throw error;
  }
});

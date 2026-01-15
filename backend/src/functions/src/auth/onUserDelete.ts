import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Trigger: When a user is deleted from Firebase Auth
 * Action: Clean up all user data from Firestore
 */
export const onUserDelete = functions.auth.user().onDelete(async (user) => {
  const { uid } = user;

  try {
    const db = admin.firestore();
    const batch = db.batch();

    // Delete user profile
    batch.delete(db.collection('users').doc(uid));

    // Delete user stats
    batch.delete(db.collection('stats').doc(uid));

    // Delete user projects
    const projects = await db.collection('projects').where('userId', '==', uid).get();
    projects.docs.forEach(doc => batch.delete(doc.ref));

    // Delete user tasks
    const tasks = await db.collection('tasks').where('userId', '==', uid).get();
    tasks.docs.forEach(doc => batch.delete(doc.ref));

    // Delete topic progress
    const progress = await db.collection('topicProgress').where('userId', '==', uid).get();
    progress.docs.forEach(doc => batch.delete(doc.ref));

    // Commit batch delete
    await batch.commit();

    console.log(`✅ User data cleaned up for ${uid}`);
    return { success: true };
  } catch (error) {
    console.error('Error deleting user data:', error);
    throw error;
  }
});

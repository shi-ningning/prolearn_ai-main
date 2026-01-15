import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Trigger: When a task document is updated
 * Action: Update statistics when task is completed
 */
export const onTaskComplete = functions.firestore
  .document('tasks/{taskId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    try {
      // Check if task was just completed
      if (!before.isCompleted && after.isCompleted) {
        const userId = after.userId;
        
        // Update user stats
        const statsRef = admin.firestore().collection('stats').doc(userId);
        await statsRef.update({
          tasksCompleted: admin.firestore.FieldValue.increment(1)
        });

        console.log(`✅ Task completed by user ${userId}`);
        // TODO: Check for achievements/streaks
      }

      return { success: true };
    } catch (error) {
      console.error('Error handling task completion:', error);
      throw error;
    }
  });

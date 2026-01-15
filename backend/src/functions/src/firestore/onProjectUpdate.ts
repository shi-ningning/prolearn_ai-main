import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Trigger: When a project document is updated
 * Action: Update user statistics and send notifications if needed
 */
export const onProjectUpdate = functions.firestore
  .document('projects/{projectId}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    const { projectId } = context.params;

    try {
      // Check if project was completed
      if (before.status !== 'completed' && after.status === 'completed') {
        const userId = after.userId;
        
        // Update user stats
        const statsRef = admin.firestore().collection('stats').doc(userId);
        await statsRef.update({
          projectsCompleted: admin.firestore.FieldValue.increment(1)
        });

        console.log(`✅ Project ${projectId} completed by user ${userId}`);
        // TODO: Send completion notification
      }

      return { success: true };
    } catch (error) {
      console.error('Error handling project update:', error);
      throw error;
    }
  });

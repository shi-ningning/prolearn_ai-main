import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Scheduled Function: Compile and send weekly analytics
 * Schedule: Every Sunday at 9:00 AM
 */
export const weeklyAnalytics = functions.pubsub
  .schedule('0 9 * * 0')
  .timeZone('Asia/Manila')
  .onRun(async (context) => {
    try {
      const db = admin.firestore();
      
      // Get all users
      const usersSnapshot = await db.collection('users').get();
      
      console.log(`📊 Generating weekly analytics for ${usersSnapshot.size} users`);

      // Calculate platform-wide statistics
      let totalProjects = 0;
      let totalTasks = 0;
      let totalCompletedTasks = 0;

      const statsSnapshot = await db.collection('stats').get();
      
      statsSnapshot.docs.forEach(doc => {
        const data = doc.data();
        totalProjects += data.projectsCount || 0;
        totalTasks += data.totalTasks || 0;
        totalCompletedTasks += data.tasksCompleted || 0;
      });

      const analytics = {
        week: new Date().toISOString(),
        totalUsers: usersSnapshot.size,
        totalProjects,
        totalTasks,
        totalCompletedTasks,
        completionRate: totalTasks > 0 ? (totalCompletedTasks / totalTasks) * 100 : 0
      };

      // Store analytics in Firestore
      await db.collection('analytics').add({
        ...analytics,
        createdAt: admin.firestore.FieldValue.serverTimestamp()
      });

      console.log('✅ Weekly analytics generated:', analytics);
      
      // TODO: Send analytics email to admins
      
      return null;
    } catch (error) {
      console.error('Error generating weekly analytics:', error);
      throw error;
    }
  });

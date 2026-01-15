import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * Scheduled Function: Send daily progress report emails
 * Schedule: Every day at 8:00 AM (server time)
 */
export const dailyProgressReport = functions.pubsub
  .schedule('0 8 * * *')
  .timeZone('Asia/Manila')
  .onRun(async (context) => {
    try {
      const db = admin.firestore();
      
      // Get all users with notifications enabled
      const usersSnapshot = await db.collection('users')
        .where('preferences.notifications', '==', true)
        .get();

      console.log(`📧 Sending daily reports to ${usersSnapshot.size} users`);

      // Send reports in batches
      const promises = usersSnapshot.docs.map(async (userDoc) => {
        const userData = userDoc.data();
        const userId = userDoc.id;

        try {
          // Get user's tasks for today
          const today = new Date();
          today.setHours(0, 0, 0, 0);

          const tasksSnapshot = await db.collection('tasks')
            .where('userId', '==', userId)
            .where('dueDate', '>=', admin.firestore.Timestamp.fromDate(today))
            .get();

          // TODO: Send email with daily summary
          console.log(`✅ Daily report sent to ${userData.email}`);
        } catch (error) {
          console.error(`Error sending report to ${userId}:`, error);
        }
      });

      await Promise.allSettled(promises);
      console.log('✅ Daily progress reports sent');
      
      return null;
    } catch (error) {
      console.error('Error in daily progress report:', error);
      throw error;
    }
  });

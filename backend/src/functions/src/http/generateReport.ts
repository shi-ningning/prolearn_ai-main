import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * HTTP Endpoint: Generate user progress report
 * URL: GET /generateReport?userId={userId}
 */
export const generateReport = functions.https.onRequest(async (req, res) => {
  // Enable CORS
  res.set('Access-Control-Allow-Origin', '*');
  
  if (req.method === 'OPTIONS') {
    res.set('Access-Control-Allow-Methods', 'GET');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.status(204).send('');
    return;
  }

  if (req.method !== 'GET') {
    res.status(405).json({
      success: false,
      error: { code: 'METHOD_NOT_ALLOWED', message: 'Only GET requests are allowed' }
    });
    return;
  }

  try {
    const { userId } = req.query;

    if (!userId || typeof userId !== 'string') {
      res.status(400).json({
        success: false,
        error: { code: 'MISSING_USER_ID', message: 'User ID is required' }
      });
      return;
    }

    const db = admin.firestore();

    // Fetch user data
    const [userDoc, statsDoc, projects, tasks] = await Promise.all([
      db.collection('users').doc(userId).get(),
      db.collection('stats').doc(userId).get(),
      db.collection('projects').where('userId', '==', userId).get(),
      db.collection('tasks').where('userId', '==', userId).get()
    ]);

    if (!userDoc.exists) {
      res.status(404).json({
        success: false,
        error: { code: 'USER_NOT_FOUND', message: 'User not found' }
      });
      return;
    }

    // Generate report data
    const report = {
      user: userDoc.data(),
      stats: statsDoc.exists ? statsDoc.data() : {},
      projects: {
        total: projects.size,
        completed: projects.docs.filter(doc => doc.data().status === 'completed').length,
        active: projects.docs.filter(doc => doc.data().status === 'active').length
      },
      tasks: {
        total: tasks.size,
        completed: tasks.docs.filter(doc => doc.data().isCompleted).length,
        pending: tasks.docs.filter(doc => !doc.data().isCompleted).length
      },
      generatedAt: new Date().toISOString()
    };

    res.status(200).json({
      success: true,
      data: report,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error generating report:', error);
    res.status(500).json({
      success: false,
      error: { code: 'INTERNAL_ERROR', message: 'Failed to generate report' }
    });
  }
});

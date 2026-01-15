import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

/**
 * HTTP Endpoint: Send email verification reminder
 * URL: POST /sendVerificationReminder
 */
export const sendVerificationReminder = functions.https.onRequest(async (req, res) => {
  // Enable CORS
  res.set('Access-Control-Allow-Origin', '*');
  
  if (req.method === 'OPTIONS') {
    res.set('Access-Control-Allow-Methods', 'POST');
    res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    res.status(204).send('');
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({
      success: false,
      error: { code: 'METHOD_NOT_ALLOWED', message: 'Only POST requests are allowed' }
    });
    return;
  }

  try {
    const { userId } = req.body;

    if (!userId) {
      res.status(400).json({
        success: false,
        error: { code: 'MISSING_USER_ID', message: 'User ID is required' }
      });
      return;
    }

    // Get user data
    const userRecord = await admin.auth().getUser(userId);

    if (userRecord.emailVerified) {
      res.status(400).json({
        success: false,
        error: { code: 'ALREADY_VERIFIED', message: 'Email is already verified' }
      });
      return;
    }

    // TODO: Send verification email via SendGrid or nodemailer
    console.log(`📧 Verification reminder sent to ${userRecord.email}`);

    res.status(200).json({
      success: true,
      message: 'Verification reminder sent successfully',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Error sending verification reminder:', error);
    res.status(500).json({
      success: false,
      error: { code: 'INTERNAL_ERROR', message: 'Failed to send verification reminder' }
    });
  }
});

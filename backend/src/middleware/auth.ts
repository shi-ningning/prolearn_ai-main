import { Request, Response, NextFunction } from 'express';
import admin from 'firebase-admin';

// Initialize Firebase Admin SDK (optional for development)
let firebaseInitialized = false;

try {
  if (!admin.apps.length) {
    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n');

    if (projectId && clientEmail && privateKey && !privateKey.includes('Your-Private-Key-Here')) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          clientEmail,
          privateKey
        })
      });
      firebaseInitialized = true;
      console.log('✅ Firebase Admin SDK initialized');
    } else {
      console.warn('⚠️  Firebase credentials not configured. Authentication will be disabled.');
      console.warn('   Add Firebase credentials to .env to enable authentication.');
    }
  }
} catch (error) {
  console.error('❌ Failed to initialize Firebase:', error);
  console.warn('⚠️  Running without Firebase authentication');
}

/**
 * Authenticate user using Firebase ID token
 */
export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    // Skip authentication if Firebase is not initialized (development mode)
    if (!firebaseInitialized) {
      console.warn('⚠️  Authentication bypassed (Firebase not configured)');
      (req as any).user = {
        uid: 'dev-user-123',
        email: 'dev@prolearn.ai',
        emailVerified: true
      };
      next();
      return;
    }

    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'No authorization token provided'
        }
      });
      return;
    }

    const token = authHeader.split('Bearer ')[1];

    // Verify Firebase ID token
    const decodedToken = await admin.auth().verifyIdToken(token);
    
    // Attach user info to request
    (req as any).user = {
      uid: decodedToken.uid,
      email: decodedToken.email,
      emailVerified: decodedToken.email_verified
    };

    next();
  } catch (error) {
    console.error('Authentication error:', error);
    res.status(401).json({
      success: false,
      error: {
        code: 'UNAUTHORIZED',
        message: 'Invalid or expired token'
      }
    });
  }
};

/**
 * Require admin role
 */
export const requireAdmin = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const user = (req as any).user;

    if (!user) {
      res.status(401).json({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
          message: 'Authentication required'
        }
      });
      return;
    }

    // Check if user is admin
    const userRecord = await admin.auth().getUser(user.uid);
    const isAdmin = userRecord.customClaims?.admin === true;

    if (!isAdmin) {
      res.status(403).json({
        success: false,
        error: {
          code: 'FORBIDDEN',
          message: 'Admin access required'
        }
      });
      return;
    }

    next();
  } catch (error) {
    console.error('Authorization error:', error);
    res.status(403).json({
      success: false,
      error: {
        code: 'FORBIDDEN',
        message: 'Access denied'
      }
    });
  }
};

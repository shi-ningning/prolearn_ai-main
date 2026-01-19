import * as admin from 'firebase-admin';

let firebaseInitialized = false;

export const initializeFirebase = (): void => {
  if (firebaseInitialized) {
    return;
  }

  try {
    if (!process.env.FIREBASE_PROJECT_ID) {
      throw new Error('Firebase configuration is missing. Please check your .env file.');
    }

    const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n');

    admin.initializeApp({
      credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: privateKey,
      }),
    });

    firebaseInitialized = true;
    console.log('✅ Firebase Admin initialized successfully');
  } catch (error) {
    console.error('❌ Error initializing Firebase Admin:', error);
    throw error;
  }
};

export const getAuth = () => admin.auth();
export const getFirestore = () => admin.firestore();

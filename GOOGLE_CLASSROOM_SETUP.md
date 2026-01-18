# Google Classroom Sign-In Setup Guide

This guide will help you configure Google Classroom sign-in for your ProLearn AI application.

## Prerequisites

- Google Cloud Project: `prolearn-ai-micha`
- Firebase project already configured

## Step 1: Get Google OAuth 2.0 Web Client ID

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project: `prolearn-ai-micha`
3. Navigate to: **APIs & Services > Credentials**
4. Look for an OAuth 2.0 Client ID with type **Web application**
   - If you don't have one, click **+ CREATE CREDENTIALS > OAuth 2.0 Client ID**
   - Application type: **Web application**
   - Name: `ProLearn AI Web Client`
   - Authorized JavaScript origins:
     - `http://localhost` (for development)
     - `http://localhost:3000`
     - Your production URL when deployed
   - Authorized redirect URIs:
     - `http://localhost`
     - `http://localhost:3000`
     - Your production URL when deployed
5. Copy the Client ID (format: `392971587776-XXXXXXXXX.apps.googleusercontent.com`)

## Step 2: Enable Required APIs

In Google Cloud Console, enable these APIs:
1. Navigate to **APIs & Services > Library**
2. Enable the following APIs:
   - **Google Classroom API**
   - **Google+ API** (required for sign-in)

## Step 3: Configure OAuth Consent Screen

1. Navigate to **APIs & Services > OAuth consent screen**
2. Configure:
   - User Type: **External** (or Internal if using Google Workspace)
   - App name: `ProLearn AI`
   - User support email: Your email
   - Developer contact: Your email
3. Add scopes:
   - `email`
   - `profile`
   - `https://www.googleapis.com/auth/classroom.courses.readonly`
   - `https://www.googleapis.com/auth/classroom.coursework.me.readonly`
4. Add test users (if in testing mode)

## Step 4: Update Frontend Configuration

Replace `YOUR_WEB_CLIENT_ID` with your actual Client ID in these files:

### File 1: `frontend/web/index.html` (Line 21)
```html
<meta name="google-signin-client_id" content="392971587776-YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com">
```

### File 2: `frontend/lib/src/data/services/google_auth_service.dart` (Line 9)
```dart
clientId: kIsWeb ? '392971587776-YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com' : null,
```

## Step 5: Update Backend Configuration

Ensure your Firebase Admin SDK is properly configured in `backend/.env`:

```env
FIREBASE_PROJECT_ID=prolearn-ai-micha
FIREBASE_CLIENT_EMAIL=your-service-account@prolearn-ai-micha.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY=-----BEGIN PRIVATE KEY-----\nYour-Key-Here\n-----END PRIVATE KEY-----\n
```

## Step 6: Test the Integration

1. Start the backend server:
   ```bash
   cd backend
   npm run dev
   ```

2. Start the Flutter web app:
   ```bash
   cd frontend
   flutter run -d chrome
   ```

3. Click "Sign in with Google" on the login page
4. Complete the OAuth flow in the popup
5. Grant permissions for Classroom access

## Troubleshooting

### Issue: "popup_closed" error
**Solution**: Make sure you're not closing the popup before completing sign-in. The updated code tries `signInSilently` first to avoid popups when possible.

### Issue: "ClientID not set" error
**Solution**: Ensure you've replaced `YOUR_WEB_CLIENT_ID` in both files mentioned in Step 4.

### Issue: "Access blocked" error
**Solution**: 
- Add your email to test users in OAuth consent screen
- Make sure all required scopes are added
- Verify the OAuth consent screen is published (if in production)

### Issue: "Unauthorized" on backend
**Solution**: Ensure Firebase Admin SDK credentials are correctly set in `.env` file.

## API Endpoints

The backend provides this endpoint for Google Classroom authentication:

**POST** `/api/auth/google-classroom`

Request body:
```json
{
  "idToken": "firebase-id-token-here"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "uid": "user-id",
    "email": "user@example.com",
    "name": "User Name",
    "customToken": "custom-token",
    "message": "Successfully signed in with Google Classroom"
  }
}
```

## Security Notes

- Never commit your actual Client ID to public repositories
- Use environment variables for sensitive data
- Keep Firebase Admin SDK credentials secure
- Regularly rotate credentials
- Use HTTPS in production

## Additional Resources

- [Google Sign-In for Web](https://developers.google.com/identity/sign-in/web)
- [Google Classroom API](https://developers.google.com/classroom)
- [Firebase Authentication](https://firebase.google.com/docs/auth)

# Fixing "approval_state" Error - OAuth Consent Screen Configuration

## Current Error
```
POST https://accounts.google.com/gsi/issue... 400 (Bad Request)
[GSI_LOGGER]: Parameter approval_state is not set correctly.
Error: issue_credential_failed
```

This error means the OAuth Consent Screen is not properly configured for the scopes you're requesting.

## Step-by-Step Fix

### 1. Configure OAuth Consent Screen

Go to [Google Cloud Console](https://console.cloud.google.com) → Select your project → **APIs & Services → OAuth consent screen**

#### A. App Information
- **App name**: `ProLearn AI`
- **User support email**: Your email address
- **App logo**: (Optional for testing)
- **Application home page**: Leave blank or add `http://localhost`
- **Application privacy policy link**: Leave blank for testing
- **Application terms of service link**: Leave blank for testing
- **Authorized domains**: Leave blank for localhost testing
- **Developer contact information**: Your email address

Click **SAVE AND CONTINUE**

#### B. Scopes Configuration (MOST IMPORTANT)

Click **ADD OR REMOVE SCOPES**

**In the scopes list, check these boxes:**
- `./auth/userinfo.email` - See your primary Google Account email address
- `./auth/userinfo.profile` - See your personal info, including any personal info you've made publicly available
- `openid` - Associate you with your personal info on Google

**Then manually add these restricted scopes:**

In the "Manually add scopes" text box at the bottom, paste EXACTLY:
```
https://www.googleapis.com/auth/classroom.courses.readonly
```
Click **ADD TO TABLE**

Then paste:
```
https://www.googleapis.com/auth/classroom.coursework.me.readonly
```
Click **ADD TO TABLE**

**Your scopes list should now have 5 scopes total:**
1. `../auth/userinfo.email`
2. `../auth/userinfo.profile`
3. `openid`
4. `https://www.googleapis.com/auth/classroom.courses.readonly`
5. `https://www.googleapis.com/auth/classroom.coursework.me.readonly`

Click **UPDATE** → **SAVE AND CONTINUE**

#### C. Test Users (CRITICAL FOR TESTING)

**You MUST add your Google account as a test user:**

1. Click **+ ADD USERS**
2. Enter your Google email address (the one you use to sign in)
3. Click **ADD**
4. Click **SAVE AND CONTINUE**

**Important**: Only users listed here can sign in while the app is in Testing mode.

#### D. Summary

Review your settings and click **BACK TO DASHBOARD**

### 2. Enable Required APIs

Go to **APIs & Services → Library**

Search for and enable these APIs:
- ✅ **Google Classroom API** - ENABLE
- ✅ **Google+ API** - ENABLE (may already be enabled)
- ✅ **Google Identity Toolkit API** - Should already be enabled

### 3. Update OAuth Client Configuration

Go to **APIs & Services → Credentials** → Click on your OAuth 2.0 Client ID:
`152821135455-1fd5oatd4npevfv0ual36qmtvgk2ngbt`

**Authorized JavaScript origins** - Add ALL these URLs:
```
http://localhost
http://localhost:55796
http://localhost:3000
http://localhost:8080
```

**Authorized redirect URIs** - Add ALL these URLs:
```
http://localhost
http://localhost:55796
http://localhost:3000
http://localhost:8080
```

Click **SAVE**

### 4. Clear Browser Cache

Important! Google caches OAuth settings:

**In Chrome:**
1. Press `Ctrl+Shift+Delete` (or `Cmd+Shift+Delete` on Mac)
2. Select "All time"
3. Check:
   - Cookies and other site data
   - Cached images and files
4. Click **Clear data**

**Or use Incognito/Private browsing** for testing.

### 5. Restart Your Application

```bash
# Stop the running Flutter app (Ctrl+C)

# Clear Flutter build cache (optional but recommended)
flutter clean

# Run again
flutter run -d chrome
```

### 6. Test the Sign-In Flow

1. Click "Sign in with Google"
2. You should see the Google account selector
3. Select your account
4. **You should now see a consent screen listing the permissions:**
   - View your email address
   - View your basic profile info
   - View your Google Classroom classes
   - View your coursework and grades in Google Classroom
5. Click **Continue** or **Allow**

## Common Issues and Solutions

### Issue 1: "This app isn't verified"
**Solution**: 
- This is normal for apps in Testing mode
- Click **Advanced** → **Go to ProLearn AI (unsafe)**
- This only appears for unverified apps requesting sensitive scopes

### Issue 2: "Access blocked: This app's request is invalid"
**Solution**:
- Make sure you're signed in with the email you added to Test Users
- Verify all scopes are added correctly in the OAuth consent screen
- Check that Classroom API is enabled

### Issue 3: Still getting "approval_state" error
**Solution**:
- Wait 5-10 minutes for Google's changes to propagate
- Clear browser cache completely
- Try in Incognito/Private mode
- Make sure you added yourself as a Test User

### Issue 4: "insufficient_scope" error
**Solution**:
- Revoke the previous authorization: https://myaccount.google.com/permissions
- Clear cookies
- Try signing in again

## Verification Checklist

Before testing again, verify:
- ✅ OAuth Consent Screen configured with all 5 scopes
- ✅ Your email added to Test Users
- ✅ Google Classroom API enabled
- ✅ OAuth Client has correct redirect URIs for localhost
- ✅ Browser cache cleared
- ✅ App restarted with `flutter run -d chrome`

## For Production Deployment

When ready for production:
1. Request OAuth verification from Google
2. Complete security questionnaire
3. Demonstrate your app's functionality
4. Wait for approval (can take weeks)
5. Once approved, change OAuth consent screen from "Testing" to "Published"

## Need More Help?

If you're still having issues:
1. Check the browser console for specific error messages
2. Look at the Network tab in DevTools for the exact API call failing
3. Verify your Test User email is correct
4. Try with a different Google account (add it to Test Users first)

# Cleanup Mock Data from Firebase

The mock courses (Mathematics, Physics, Chemistry, Computer Science) that were seeded into your Firebase database need to be manually deleted.

## Option 1: Delete via Firebase Console (Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Firestore Database** in the left menu
4. Navigate to the `syllabi` collection
5. Delete the following documents:
   - `math-101`
   - `physics-101`
   - `chemistry-101`
   - `cs-101`

## Option 2: Delete via Flutter App

Add this temporary cleanup method to your app and call it once:

```dart
// Add this method to your main.dart or any appropriate location
Future<void> cleanupMockCourses() async {
  final firestore = FirebaseFirestore.instance;
  
  final mockCourseIds = [
    'math-101',
    'physics-101',
    'chemistry-101',
    'cs-101',
  ];
  
  for (final courseId in mockCourseIds) {
    try {
      await firestore.collection('syllabi').doc(courseId).delete();
      print('Deleted mock course: $courseId');
    } catch (e) {
      print('Error deleting $courseId: $e');
    }
  }
  
  print('Mock data cleanup complete!');
}

// Call this once in your app (perhaps in initState of a debug screen)
// Then remove this code after cleanup is done
```

## Option 3: Using Firebase CLI

If you have Firebase CLI installed:

```bash
# Install Firebase CLI if you haven't
npm install -g firebase-tools

# Login to Firebase
firebase login

# Use Firebase shell or write a script to delete documents
```

## After Cleanup

Once you've deleted the mock courses:
1. Restart your app
2. The "All Subjects" page should now only show courses from Google Classroom
3. Each Google Classroom course will display the actual teacher's name

## Verification

To verify the cleanup was successful:
- Open your app
- Navigate to the Learning page
- You should only see courses imported from Google Classroom
- No Mathematics, Physics, Chemistry, or Computer Science courses should appear unless they're from Google Classroom

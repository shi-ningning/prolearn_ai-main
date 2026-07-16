import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'google_sign_in_instance.dart';
import '../../utils/logger.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final GoogleSignIn _googleSignIn;

  GoogleAuthService() {
    _googleSignIn = GoogleSignInInstance.instance;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser;

      Logger.info('GoogleAuth: Starting Google sign-in...');
      if (kIsWeb) {
        Logger.info(
          'GoogleAuth: Web platform detected, trying silent sign-in first',
        );
        googleUser = await _googleSignIn.signInSilently();
        if (googleUser != null) {
          Logger.info(
            'GoogleAuth: Silent sign-in successful: ${googleUser.email}',
          );
        } else {
          Logger.info('GoogleAuth: Silent sign-in failed, showing popup');
          googleUser = await _googleSignIn.signIn();
        }
      } else {
        Logger.info('GoogleAuth: Mobile platform, showing sign-in dialog');
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser == null) {
        Logger.error('GoogleAuth: Sign-in was cancelled by user');
        return null;
      }

      Logger.info('GoogleAuth: Google user signed in: ${googleUser.email}');
      Logger.info('GoogleAuth: Getting authentication tokens...');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      Logger.info(
        'GoogleAuth: Access token: ${googleAuth.accessToken != null ? "present (${googleAuth.accessToken?.substring(0, 20)}...)" : "null"}',
      );
      Logger.info(
        'GoogleAuth: ID token: ${googleAuth.idToken != null ? "present" : "null"}',
      );

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (googleAuth.idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }

      Logger.info('GoogleAuth: Attempting Firebase sign in...');
      final userCredential = await _auth.signInWithCredential(credential);
      Logger.info(
        'GoogleAuth: Firebase sign in successful for ${userCredential.user?.email}',
      );
      Logger.info(
        'GoogleAuth: GoogleSignIn currentUser after auth: ${_googleSignIn.currentUser?.email}',
      );

      return userCredential;
    } catch (e, stackTrace) {
      Logger.error('GoogleAuth: Error signing in with Google', e, stackTrace);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  User? get currentUser => _auth.currentUser;

  bool get isSignedIn => _auth.currentUser != null;

  GoogleSignInAccount? get currentGoogleUser => _googleSignIn.currentUser;
}

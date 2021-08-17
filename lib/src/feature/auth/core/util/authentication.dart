import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static Future<FirebaseApp> init() async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    final User? user = FirebaseAuth.instance.currentUser;

    final bool isGuest = false; //TODO: Implement geust login mechanism

    if (isGuest || user != null) {
      //TODO: navigate to the home screen
    } else {
      //TODO: navigate to the login screen
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle(
      {required void Function(String message) onAuthFailure}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    if (kIsWeb) {
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (error) {
        onAuthFailure('Error occurred using Google Sign-In. Try again.');
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (error) {
          if (error.code == 'account-exists-with-different-credential') {
            onAuthFailure(
                'The account already exists with a different credential.');
          } else if (error.code == 'invalid-credential') {
            onAuthFailure(
                'Error occurred while accessing credentials. Try again.');
          }
          onAuthFailure(error.message ?? error.code);
        } catch (error) {
          // handle the error here
          onAuthFailure('Error occurred using Google Sign-In. Try again.');
        }
      }
    }

    return user;
  }

  static Future<void> signOut(
      {required void Function(String message) onSignOutFailure}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (error) {
      onSignOutFailure('Error signing out. Try again.');
    }
  }
}

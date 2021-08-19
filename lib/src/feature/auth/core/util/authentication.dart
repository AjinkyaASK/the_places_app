import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/datasource/local/user_datasource_local.dart';
import '../../data/model/user.dart';
import '../local_database_keys.dart';

class Authentication {
  static final UserDatasourceLocal _datasourceLocal = UserDatasourceLocal();

  static Future<PlacesAppUser?> init() async {
    final bool isGuest =
        _datasourceLocal.get(UserLocalDatabaseKeys.guestSignedIn);

    PlacesAppUser? placesAppUser;

    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final FirebaseApp firebaseApp = await Firebase.initializeApp();

      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null)
        placesAppUser = PlacesAppUser(
            name: firebaseUser.displayName ?? '',
            pictureUrl: firebaseUser.photoURL ?? '');
    }

    if (isGuest)
      placesAppUser = PlacesAppUser(
        isGuest: true,
        name: 'Guest',
        pictureUrl: '',
      );

    return placesAppUser;
  }

  static Future<PlacesAppUser?> signInWithGoogle(
      {required void Function(String message) onAuthFailure}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;
    PlacesAppUser? placesAppUser;

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

    if (user != null)
      placesAppUser = PlacesAppUser(
        name: user.displayName ?? '',
        pictureUrl: user.photoURL ?? '',
      );

    return placesAppUser;
  }

  static Future<PlacesAppUser> signInAsGuest(
      {required void Function(String message) onAuthFailure}) async {
    await _datasourceLocal.set(
      key: UserLocalDatabaseKeys.guestSignedIn,
      value: true,
    );
    return PlacesAppUser(
      isGuest: true,
      name: 'Guest',
      pictureUrl: '',
    );
  }

  static Future<void> signOut({
    required void Function() onComplete,
    required void Function(String message) onFailure,
  }) async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      try {
        if (!kIsWeb) await googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
      } catch (error) {
        onFailure('Error signing out. Try again.');
      }
    }
    if (_datasourceLocal.get(UserLocalDatabaseKeys.guestSignedIn))
      await _datasourceLocal.set(
        key: UserLocalDatabaseKeys.guestSignedIn,
        value: false,
      );
    onComplete();
  }
}

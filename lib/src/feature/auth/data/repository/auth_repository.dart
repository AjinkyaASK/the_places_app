import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/exception/general_exception.dart';
import '../../core/local_database_keys.dart';
import '../../data/datasource/local/user_datasource_local.dart';
import '../../data/model/user.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepository implements AuthRepositoryBase {
  AuthRepository(this.datasource);

  final UserDatasourceLocal datasource;

  static Future<PlacesAppUser?> init(UserDatasourceLocal datasource) async {
    final bool isGuest = datasource.get(UserLocalDatabaseKeys.guestSignedIn);

    PlacesAppUser? placesAppUser;

    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final FirebaseApp firebaseApp = await Firebase.initializeApp();

      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      final AccessToken? facebookAccessToken =
          await FacebookAuth.instance.accessToken;

      if (firebaseUser != null) {
        placesAppUser = PlacesAppUser(
            name: firebaseUser.displayName ?? '',
            pictureUrl: firebaseUser.photoURL ?? '');
      } else if (facebookAccessToken != null) {
        // user is logged
        final Map<String, dynamic> userData =
            await FacebookAuth.instance.getUserData();

        placesAppUser = PlacesAppUser(
          name: userData['name'],
          pictureUrl: ((userData['picture'] as Map<String, dynamic>)['data']
              as Map<String, dynamic>)['url'],
        );
      }
    }

    if (placesAppUser == null && isGuest)
      placesAppUser = PlacesAppUser(
        isGuest: true,
        name: 'Guest',
        pictureUrl: '',
      );

    return placesAppUser;
  }

  Future<PlacesAppUser?> signInWithGoogle(
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
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );

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

  Future<PlacesAppUser?> signInWithFacebook(
      {required void Function(String message) onAuthFailure}) async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      final Map<String, dynamic> userData =
          await FacebookAuth.instance.getUserData();

      final placesAppUser = PlacesAppUser(
        name: userData['name'],
        pictureUrl: ((userData['picture'] as Map<String, dynamic>)['data']
            as Map<String, dynamic>)['url'],
      );
      return placesAppUser;
    }
  }

  Future<PlacesAppUser> signInAsGuest() async {
    try {
      await datasource.set(
        key: UserLocalDatabaseKeys.guestSignedIn,
        value: true,
      );
      final user = PlacesAppUser(
        isGuest: true,
        name: 'Guest',
        pictureUrl: '',
      );
      return user;
    } catch (error) {
      throw GeneralException(
        source: 'source',
        message: 'Error signing in as a guest',
      );
    }
  }

  Future<void> signOut() async {
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      try {
        if (!kIsWeb) await googleSignIn.signOut();
        await FirebaseAuth.instance.signOut();
        await FacebookAuth.instance.logOut();
      } catch (error) {
        throw GeneralException(
          source: 'SignOutUseCase',
          message: 'Error signing out. Try again.',
        );
      }
    }
    if (datasource.get(UserLocalDatabaseKeys.guestSignedIn))
      await datasource.set(
        key: UserLocalDatabaseKeys.guestSignedIn,
        value: false,
      );
  }
}

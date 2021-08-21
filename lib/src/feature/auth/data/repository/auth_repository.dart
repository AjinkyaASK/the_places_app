import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

import '../../../../config/twitter_api_config.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../value/strings.dart';
import '../../core/auth_database_keys.dart';
import '../../data/datasource/local/user_datasource_local.dart';
import '../../data/model/user.dart';
import '../../domain/repository/auth_repository.dart';

///[AuthRepository] contains methods for Authentication module
class AuthRepository implements AuthRepositoryBase {
  AuthRepository(this.datasource);

  final UserDatasourceLocal datasource;

  ///[init] method initializes the local datasource and check if user
  ///is signed in either as a Guest, Google or Facebook User
  ///initializes the returns the user object if user is signed in
  ///else returns null
  static Future<PlacesAppUser?> init(UserDatasourceLocal datasource) async {
    // Check if user is signed in as a guest
    final bool isGuest = datasource.get(AuthLocalDatabaseKeys.guestSignedIn);

    PlacesAppUser? placesAppUser;
    // Check for Google / Facebook sign in
    if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
      final FirebaseApp firebaseApp = await Firebase.initializeApp();

      // Check if user signed in with Google/Firebase
      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      // Check if user signed in with Facebook
      final AccessToken? facebookAccessToken =
          await FacebookAuth.instance.accessToken;

      if (firebaseUser != null) {
        placesAppUser = PlacesAppUser(
          name: firebaseUser.displayName ?? '',
          pictureUrl: firebaseUser.photoURL ?? '',
          email: firebaseUser.email,
        );
      } else if (facebookAccessToken != null) {
        // user is logged
        final Map<String, dynamic> userData =
            await FacebookAuth.instance.getUserData();

        placesAppUser = PlacesAppUser(
          name: userData[AuthLocalDatabaseKeys.name],
          email: userData[AuthLocalDatabaseKeys.email],
          pictureUrl: ((userData[AuthLocalDatabaseKeys.picture]
                  as Map<String, dynamic>)[AuthLocalDatabaseKeys.data]
              as Map<String, dynamic>)[AuthLocalDatabaseKeys.url],
        );
      }
    }

    if (placesAppUser == null && isGuest)
      placesAppUser = PlacesAppUser(
        isGuest: true,
        name: Strings.guestUserName,
        pictureUrl: '',
      );

    return placesAppUser;
  }

  ///[signInWithGoogle] method used to sign in using Google
  @override
  Future<PlacesAppUser?> signInWithGoogle(
      {required void Function(String message) onAuthFailure}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

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
        email: user.email,
        pictureUrl: user.photoURL ?? '',
      );

    return placesAppUser;
  }

  ///[signInWithFacebook] method used to sign in using Facebook
  @override
  Future<PlacesAppUser?> signInWithFacebook(
      {required void Function(String message) onAuthFailure}) async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final String accessToken = result.accessToken!.token;
      final OAuthCredential credential =
          FacebookAuthProvider.credential(accessToken);
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      final Map<String, dynamic> userData =
          await FacebookAuth.instance.getUserData();

      final placesAppUser = PlacesAppUser(
        name: userData[AuthLocalDatabaseKeys.name],
        email: userData[AuthLocalDatabaseKeys.email],
        pictureUrl: ((userData[AuthLocalDatabaseKeys.picture]
                as Map<String, dynamic>)[AuthLocalDatabaseKeys.data]
            as Map<String, dynamic>)[AuthLocalDatabaseKeys.url],
      );
      return placesAppUser;
    } else {
      log('Signing in with Facebook failed: ${result.message}');
    }
  }

  ///[signInWithTwitter] method used to sign in using Twitter (Not Integrated)
  @override
  Future<PlacesAppUser?> signInWithTwitter() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    final TwitterLogin twitterLogin = TwitterLogin(
      apiKey: TwitterApiConfig.apiKey,
      apiSecretKey: TwitterApiConfig.apiSecret,
      redirectURI: TwitterApiConfig.redirectUrl,
    );
    final authResult = await twitterLogin.login();

    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        if (authResult.authToken != null &&
            authResult.authTokenSecret != null &&
            authResult.user != null) {
          final OAuthCredential credential = TwitterAuthProvider.credential(
            accessToken: authResult.authToken!,
            secret: authResult.authTokenSecret!,
          );
          await auth.signInWithCredential(credential);
          return PlacesAppUser(
            name: authResult.user!.name,
            pictureUrl: authResult.user!.thumbnailImage,
          );
        }
        break;

      case TwitterLoginStatus.error:
        throw GeneralException(
          source: 'AuthRepository',
          message: 'Signing in with Twitter failed with error',
        );

      case TwitterLoginStatus.cancelledByUser:
        throw GeneralException(
          source: 'AuthRepository',
          message: 'Signing in with Twitter cancelled by user',
        );

      default:
        throw GeneralException(
          source: 'AuthRepository',
          message: 'Signing in with Twitter failed due to unknown reason',
        );
    }
  }

  ///[signInAsGuest] method used to sign in as a Guest
  @override
  Future<PlacesAppUser> signInAsGuest() async {
    try {
      await datasource.set(
        key: AuthLocalDatabaseKeys.guestSignedIn,
        value: true,
      );
      final user = PlacesAppUser(
        isGuest: true,
        name: Strings.guestUserName,
        pictureUrl: '',
      );
      return user;
    } catch (error) {
      throw GeneralException(
        source: 'AuthRepository',
        message: Strings.guestSignInErrorMessage,
      );
    }
  }

  ///[signOut] method used to sign out from all signed in account
  @override
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
    if (datasource.get(AuthLocalDatabaseKeys.guestSignedIn))
      await datasource.set(
        key: AuthLocalDatabaseKeys.guestSignedIn,
        value: false,
      );
  }
}

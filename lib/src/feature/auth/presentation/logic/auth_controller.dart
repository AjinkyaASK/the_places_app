import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../../value/strings.dart';
import '../../../showcase/presentation/view/showcase_view.dart';
import '../../data/model/user.dart';
import '../../domain/usecase/sign_in_as_guest_usecase.dart';
import '../../domain/usecase/sign_in_with_facebook_usecase.dart';
import '../../domain/usecase/sign_in_with_google_usecase.dart';
import '../../domain/usecase/sign_in_with_twitter_usecase.dart';
import '../../domain/usecase/sign_out_usecase.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required this.signInAsGuestUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
    required this.signInWithTwitterUseCase,
    required this.signOutUseCase,
  })  : isSignInWithGoogleSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS,
        isSignInWithFacebookSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS,
        isSignInWithAppleSupported =
            !kIsWeb && (Platform.isIOS || Platform.isMacOS),
        isSignInWithTwitterSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS;

  final SignInAsGuestUseCase signInAsGuestUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
  final SignInWithTwitterUseCase signInWithTwitterUseCase;
  final SignOutUseCase signOutUseCase;

  bool _isLoading = false;
  bool _isSigningInAsGuest = false;
  bool _isSigningInWithGoogle = false;
  bool _isSigningInWithFacebook = false;
  bool _isSigningInWithApple = false;
  bool _isSigningInWithTwitter = false;

  bool get loading => _isLoading;
  bool get signingInAsGuest => _isSigningInAsGuest;
  bool get signingInWithGoogle => _isSigningInWithGoogle;
  bool get signingInWithFacebook => _isSigningInWithFacebook;
  bool get signingInWithApple => _isSigningInWithApple;
  bool get signingInWithTwitter => _isSigningInWithTwitter;

  final bool isSignInWithGoogleSupported;
  final bool isSignInWithFacebookSupported;
  final bool isSignInWithAppleSupported;
  final bool isSignInWithTwitterSupported;

  void refresh() => notifyListeners();

  void flashError({required BuildContext context, required String message}) {}

  void startLoading() {
    _isLoading = true;
    refresh();
  }

  void doneLoading() {
    _isLoading = false;
    refresh();
  }

  void onAuthFailure({
    required BuildContext context,
    required String message,
  }) {
    print(message);
    flashError(
      context: context,
      message: message,
    );
  }

  Future<void> signInAsGuest(BuildContext context) async {
    final response = await signInAsGuestUseCase();

    response.fold(
      (exception) {
        onAuthFailure(
            context: context,
            message: exception.message ?? 'Something went wrong');
      },
      (user) {
        if (RouteManger.navigatorKey.currentState != null)
          RouteManger.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Pages.placesShowcase,
            (route) => false,
            arguments: ShowcaseViewParams(
              user: user as PlacesAppUser,
            ),
          );
      },
    );
  }

  Future<void> signInWithApple(BuildContext context) async {
    _isSigningInWithApple = true;
    startLoading();

    // TODO: Implement this
    await Future.delayed(Duration(seconds: 3));

    _isSigningInWithApple = false;
    doneLoading();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    _isSigningInWithGoogle = true;
    startLoading();
    final result = await signInWithGoogleUseCase(
      onAuthFailure: (message) => onAuthFailure(
        context: context,
        message: message,
      ),
    );

    result.fold((exception) {
      _isSigningInWithGoogle = false;
      doneLoading();
      onAuthFailure(
        context: context,
        message: exception.message ?? Strings.blanketErrorMessage,
      );
    }, (user) {
      if ((user as PlacesAppUser?) != null) {
        _isSigningInWithGoogle = false;
        doneLoading();
        if (RouteManger.navigatorKey.currentState != null)
          RouteManger.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Pages.placesShowcase,
            (route) => false,
            arguments: ShowcaseViewParams(user: user!),
          );
      } else {
        onAuthFailure(
          context: context,
          message: Strings.blanketErrorMessage,
        );
        _isSigningInWithGoogle = false;
        doneLoading();
      }
    });
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    startLoading();
    _isSigningInWithFacebook = true;

    final result = await signInWithFacebookUseCase(
      onAuthFailure: (message) => onAuthFailure(
        context: context,
        message: message,
      ),
    );

    result.fold((exception) {
      _isSigningInWithFacebook = false;
      doneLoading();
      onAuthFailure(
        context: context,
        message: exception.message ?? Strings.blanketErrorMessage,
      );
    }, (user) {
      if ((user as PlacesAppUser?) != null) {
        _isSigningInWithFacebook = false;
        doneLoading();
        if (RouteManger.navigatorKey.currentState != null)
          RouteManger.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Pages.placesShowcase,
            (route) => false,
            arguments: ShowcaseViewParams(user: user!),
          );
      } else {
        onAuthFailure(
          context: context,
          message: Strings.blanketErrorMessage,
        );
        _isSigningInWithFacebook = false;
        doneLoading();
      }
    });
  }

  Future<void> signInWithTwitter(BuildContext context) async {
    _isSigningInWithTwitter = true;
    startLoading();

    final result = await signInWithTwitterUseCase();

    result.fold((exception) {
      _isSigningInWithTwitter = false;
      doneLoading();
      onAuthFailure(
        context: context,
        message: exception.message ?? Strings.blanketErrorMessage,
      );
    }, (user) {
      if ((user as PlacesAppUser?) != null) {
        _isSigningInWithTwitter = false;
        doneLoading();
        if (RouteManger.navigatorKey.currentState != null)
          RouteManger.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            Pages.placesShowcase,
            (route) => false,
            arguments: ShowcaseViewParams(
              user: user!,
            ),
          );
      } else {
        onAuthFailure(
          context: context,
          message: Strings.blanketErrorMessage,
        );
        _isSigningInWithTwitter = false;
        doneLoading();
      }
    });

    _isSigningInWithTwitter = false;
    doneLoading();
  }

  Future<void> signOut(BuildContext context) async {
    final result = await signOutUseCase();
    result.fold((exception) {}, (success) {});
  }
}

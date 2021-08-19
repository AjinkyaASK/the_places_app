import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/model/user.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../showcase/core/messages.dart';
import '../../../showcase/presentation/view/showcase_view.dart';
import '../../domain/usecase/sign_in_as_guest_usecase.dart';
import '../../domain/usecase/sign_in_with_facebook_usecase.dart';
import '../../domain/usecase/sign_in_with_google_usecase.dart';
import '../../domain/usecase/sign_out_usecase.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required this.signInAsGuestUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
    required this.signOutUseCase,
  })  : isSignInWithGoogleSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS,
        isSignInWithFacebookSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS,
        isSignInWithAppleSupported =
            !kIsWeb && (Platform.isIOS || Platform.isMacOS);

  final SignInAsGuestUseCase signInAsGuestUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
  final SignOutUseCase signOutUseCase;

  bool _isLoading = false;
  bool _isSigningInWithGoogle = false;
  bool _isSigningInWithFacebook = false;
  bool _isSigningInWithApple = false;
  bool _isSigningInAsGuest = false;

  bool get loading => _isLoading;
  bool get signingInWithGoogle => _isSigningInWithGoogle;
  bool get signingInWithFacebook => _isSigningInWithFacebook;
  bool get signingInWithApple => _isSigningInWithApple;
  bool get signingInAsGuest => _isSigningInAsGuest;

  final bool isSignInWithGoogleSupported;
  final bool isSignInWithFacebookSupported;
  final bool isSignInWithAppleSupported;

  void refresh() => notifyListeners();

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
            arguments: user,
          );
      },
    );
  }

  Future<void> signInWithApple(BuildContext context) async {
    _isSigningInWithApple = true;
    startLoading();

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

    result.fold((exception) {}, (user) {
      if ((user as PlacesAppUser?) != null) {
        _isSigningInWithGoogle = false;
        doneLoading();
        if (RouteManger.navigatorKey.currentState != null)
          RouteManger.navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => ShowcaseView(
                user: user!,
              ),
            ),
            (route) => false,
          );
      } else {
        onAuthFailure(
          context: context,
          message: ShowcaseMessages.BlanketErrorMessage,
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

    result.fold((exception) {}, (user) {
      if ((user as PlacesAppUser?) != null) {
        _isSigningInWithFacebook = false;
        doneLoading();
        if (RouteManger.navigatorKey.currentState != null)
          RouteManger.navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => ShowcaseView(
                user: user!,
              ),
            ),
            (route) => false,
          );
      } else {
        onAuthFailure(
          context: context,
          message: ShowcaseMessages.BlanketErrorMessage,
        );
        _isSigningInWithFacebook = false;
        doneLoading();
      }
    });
  }

  Future<void> signOut(BuildContext context) async {
    final result = await signOutUseCase();
    result.fold((exception) {}, (success) {});
  }
}

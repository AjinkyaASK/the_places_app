import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../showcase/presentation/view/showcase_view.dart';
import '../../core/util/authentication.dart';
import '../../data/model/user.dart';
import '../../domain/usecase/sign_in_as_guest_usecase.dart';

class AuthController extends ChangeNotifier {
  AuthController({
    required this.signInAsGuestUseCase,
  })  : isSignInWithGoogleSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS,
        isSignInWithFacebookSupported =
            kIsWeb || Platform.isAndroid || Platform.isIOS;

  final SignInAsGuestUseCase signInAsGuestUseCase;

  bool _isLoading = false;
  bool _isSigningInWithGoogle = false;
  bool _isSigningInWithFacebook = false;
  bool _isSigningInAsGuest = false;

  bool get loading => _isLoading;
  bool get signingInWithGoogle => _isSigningInWithGoogle;
  bool get signingInWithFacebook => _isSigningInWithFacebook;
  bool get signingInAsGuest => _isSigningInAsGuest;

  final bool isSignInWithGoogleSupported;
  final bool isSignInWithFacebookSupported;

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

  Future<void> signInWithGoogle(BuildContext context) async {
    _isSigningInWithGoogle = true;
    startLoading();
    final PlacesAppUser? result = await Authentication.signInWithGoogle(
      onAuthFailure: (message) => onAuthFailure(
        context: context,
        message: message,
      ),
    );
    if (result != null) {
      _isSigningInWithGoogle = false;
      doneLoading();
      if (RouteManger.navigatorKey.currentState != null)
        RouteManger.navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => ShowcaseView(
              user: result,
            ),
          ),
          (route) => false,
        );
      return;
    } else {
      onAuthFailure(context: context, message: 'Something went wrong');
    }
    _isSigningInWithGoogle = false;
    doneLoading();
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    startLoading();
    _isSigningInWithFacebook = true;
    await Future.delayed(Duration(seconds: 2));
    _isSigningInWithFacebook = false;
    doneLoading();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/local/user_datasource_local.dart';
import '../../data/repository/auth_repository.dart';
import '../../domain/usecase/sign_in_as_guest_usecase.dart';
import '../../domain/usecase/sign_in_with_facebook_usecase.dart';
import '../../domain/usecase/sign_in_with_google_usecase.dart';
import '../../domain/usecase/sign_in_with_twitter_usecase.dart';
import '../../domain/usecase/sign_out_usecase.dart';
import '../logic/auth_controller.dart';

class AuthenticationView extends StatelessWidget {
  AuthenticationView({Key? key}) : super(key: key);
  static final AuthRepository _authRepository =
      AuthRepository(UserDatasourceLocal());
  final AuthController _controller = AuthController(
    signInAsGuestUseCase: SignInAsGuestUseCase(_authRepository),
    signInWithGoogleUseCase: SignInWithGoogleUseCase(_authRepository),
    signInWithFacebookUseCase: SignInWithFacebookUseCase(_authRepository),
    signInWithTwitterUseCase: SignInWithTwitterUseCase(_authRepository),
    signOutUseCase: SignOutUseCase(_authRepository),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (_) => _controller,
      child: Consumer<AuthController>(
        builder: (__, controller, ___) {
          return Scaffold(
            body: Stack(children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Welcome to',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          'The Places App',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.isSignInWithAppleSupported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: MaterialButton(
                              minWidth: 200.0,
                              onPressed: () => controller.loading
                                  ? null
                                  : controller.signInWithApple(context),
                              color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.signingInWithApple)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: SizedBox(
                                          width: 18.0,
                                          height: 18.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Image.asset(
                                          'assets/icons/apple.png',
                                          width: 18.0,
                                          height: 18.0,
                                        ),
                                      ),
                                    Text(
                                      'Sign in with Apple',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (controller.isSignInWithGoogleSupported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: MaterialButton(
                              onPressed: () => controller.loading
                                  ? null
                                  : controller.signInWithGoogle(context),
                              color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.signingInWithGoogle)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: SizedBox(
                                          width: 18.0,
                                          height: 18.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Image.asset(
                                          'assets/icons/google.png',
                                          width: 18.0,
                                          height: 18.0,
                                        ),
                                      ),
                                    Text(
                                      'Sign in with Google',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (controller.isSignInWithFacebookSupported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: MaterialButton(
                              onPressed: () => controller.loading
                                  ? null
                                  : controller.signInWithFacebook(context),
                              color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.signingInWithFacebook)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: SizedBox(
                                          width: 18.0,
                                          height: 18.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Image.asset(
                                          'assets/icons/facebook.png',
                                          width: 18.0,
                                          height: 18.0,
                                        ),
                                      ),
                                    Text(
                                      'Sign in with Facebook',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        //TODO: the false is added in condition to make Sign in twitter unavailable (due to the API account issue)
                        if (false && controller.isSignInWithTwitterSupported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: MaterialButton(
                              onPressed: () => controller.loading
                                  ? null
                                  : controller.signInWithTwitter(context),
                              color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (controller.signingInWithTwitter)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: SizedBox(
                                          width: 18.0,
                                          height: 18.0,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3.0,
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: Image.asset(
                                          'assets/icons/twitter.png',
                                          width: 18.0,
                                          height: 18.0,
                                        ),
                                      ),
                                    Text(
                                      'Sign in with Twitter',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        if (controller.isSignInWithGoogleSupported ||
                            controller.isSignInWithFacebookSupported)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        TextButton(
                          onPressed: () async {
                            await controller.signInAsGuest(context);
                          },
                          child: Text('Continue' +
                              (controller.isSignInWithGoogleSupported ||
                                      controller.isSignInWithFacebookSupported
                                  ? ' as a Guest'
                                  : '')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}

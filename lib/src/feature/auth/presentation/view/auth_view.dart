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
import 'widget/sign_in_button.dart';

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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 250.0,
                        maxHeight: 250.0,
                      ),
                      child: Image.asset('assets/app_icon.png'),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //TODO: Commented to make Sign in apple unavailable as the feature is not complete
                        // if (controller.isSignInWithAppleSupported)
                        //   SignInButton(
                        //     onPressed: () => controller.loading
                        //         ? null
                        //         : controller.signInWithApple(context),
                        //     loading: controller.signingInWithApple,
                        //     text: 'Sign in with Apple',
                        //     leading: Image.asset(
                        //       'assets/icons/apple.png',
                        //       width: 18.0,
                        //       height: 18.0,
                        //     ),
                        //   ),

                        if (controller.isSignInWithGoogleSupported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SignInButton(
                              onPressed: () => controller.loading
                                  ? null
                                  : controller.signInWithGoogle(context),
                              loading: controller.signingInWithGoogle,
                              text: 'Sign in with Google',
                              leading: Image.asset(
                                'assets/icons/google.png',
                                width: 18.0,
                                height: 18.0,
                              ),
                            ),
                          ),

                        if (controller.isSignInWithFacebookSupported)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SignInButton(
                              onPressed: () => controller.loading
                                  ? null
                                  : controller.signInWithFacebook(context),
                              loading: controller.signingInWithFacebook,
                              text: 'Sign in with Facebook',
                              leading: Image.asset(
                                'assets/icons/facebook.png',
                                width: 18.0,
                                height: 18.0,
                              ),
                            ),
                          ),

                        //TODO: Commented to make Sign in twitter unavailable as the feature is not complete
                        // if (controller.isSignInWithFacebookSupported)
                        //   Padding(
                        //     padding: const EdgeInsets.only(bottom: 12.0),
                        //     child: SignInButton(
                        //       onPressed: () => controller.loading
                        //           ? null
                        //           : controller.signInWithTwitter(context),
                        //       loading: controller.signingInWithTwitter,
                        //       text: 'Sign in with Twitter',
                        //       leading: Image.asset(
                        //         'assets/icons/twitter.png',
                        //         width: 18.0,
                        //         height: 18.0,
                        //       ),
                        //     ),
                        //   ),

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

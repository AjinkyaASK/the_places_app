import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasource/local/user_datasource_local.dart';
import '../../domain/usecase/sign_in_as_guest_usecase.dart';
import '../logic/auth_controller.dart';

class AuthenticationView extends StatelessWidget {
  AuthenticationView({Key? key}) : super(key: key);
  static final UserDatasourceLocal _datasourceLocal = UserDatasourceLocal();
  final AuthController _controller = AuthController(
      signInAsGuestUseCase: SignInAsGuestUseCase(_datasourceLocal));

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
                    Text(
                      'Welcome to The\nPlaces App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

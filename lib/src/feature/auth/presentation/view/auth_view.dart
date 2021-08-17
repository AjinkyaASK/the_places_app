import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_places_app/src/feature/auth/presentation/logic/auth_controller.dart';

class AuthenticationView extends StatelessWidget {
  AuthenticationView({Key? key}) : super(key: key);

  final AuthController _controller = AuthController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthController>(
      create: (_) => _controller,
      child: Consumer<AuthController>(
        builder: (__, controller, ___) {
          return Scaffold(
            body: Column(
              children: [
                Text('Welcome to The Places App'),
                MaterialButton(
                  onPressed: () => controller.signInWithGoogle(context),
                  child: Text('Sign in with Google'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Continue as a guest'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../core/util/authentication.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;

  bool get loading => _isLoading;

  void refresh() => notifyListeners();

  void startLoading() {
    _isLoading = true;
    refresh();
  }

  void stopLoading() {
    _isLoading = false;
    refresh();
  }

  void onAuthFailure({
    required BuildContext context,
    required String message,
  }) {
    print(message);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final User? result = await Authentication.signInWithGoogle(
      onAuthFailure: (message) => onAuthFailure(
        context: context,
        message: message,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/artifacts/image_artifacts.dart';
import '../../../../../value/strings.dart';

const double _maxWidth = 260.0;
const EdgeInsets _defaultPadding = const EdgeInsets.symmetric(
  horizontal: 32.0,
  vertical: 16.0,
);

///[NoInternetWidget] is the widget shown when
///there is no internet connection
class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  ///[onRetry] called when user taps on `Retry` button
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: _defaultPadding,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: _maxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImageArtifacts.noConnection,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  Strings.noInternetConnectionTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  Strings.noInternetConnectionDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: onRetry,
                color: Colors.grey.shade900,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Text(
                    Strings.retryButton,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

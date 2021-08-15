import 'exception.dart';

class GeneralException extends Exception {
  GeneralException({
    required final String source,
    final String? message,
  }) : super(
          source: source,
          message: message,
        );
}

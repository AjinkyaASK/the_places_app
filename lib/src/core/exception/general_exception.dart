import 'exception.dart';

///[GeneralException] is used as a exception
class GeneralException extends Exception {
  GeneralException({
    required final String source,
    final String? message,
  }) : super(
          source: source,
          message: message,
        );
}

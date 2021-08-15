import '../../util/network/network_request.dart';
import 'exception.dart';

class NetworkException extends Exception {
  NetworkException({
    required final String source,
    final String? message,
    required this.requestType,
    this.httpCode,
    required this.requestUrl,
    this.responseBody,
  }) : super(
          source: source,
          message: message,
        );

  final int? httpCode;
  final NetworkRequestType requestType;
  final String requestUrl;
  final String? responseBody;
}

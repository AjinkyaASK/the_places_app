import '../../util/network/network_request.dart';
import 'exception.dart';

///[NetworkException] is used as a exception for throwing network related errors
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

  ///[httpCode] is error code from http request
  final int? httpCode;

  ///[requestType] is the type of http request either Get or Post
  final NetworkRequestType requestType;

  ///[requestUrl] is the network url of http request
  final String requestUrl;

  ///[responseBody] is the body of the response
  final String? responseBody;
}

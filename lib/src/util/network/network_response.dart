import 'network_request.dart';

class NetworkResponse {
  NetworkResponse({
    required this.requestType,
    required this.httpCode,
    required this.requestUrl,
    this.requestParameters,
    this.responseBody,
  });

  final NetworkRequestType requestType;
  final int httpCode;
  final String requestUrl;
  final Map<String, String>? requestParameters;
  final Map<String, dynamic>? responseBody;
}

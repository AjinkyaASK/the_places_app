import 'network_request.dart';

///[NetworkResponse] acts as a parameter class
///used by [NetworkHelper] class for its response
class NetworkResponse {
  NetworkResponse({
    required this.requestType,
    required this.httpCode,
    required this.requestUrl,
    this.requestParameters,
    this.responseBody,
  });

  ///[requestType] is either Get or Post
  final NetworkRequestType requestType;

  ///[httpCode] indicates the http response code from server
  final int httpCode;

  ///[requestUrl] is the url against which the request was processed
  final String requestUrl;

  ///[requestParameters] are the parameters sent via the request
  final Map<String, String>? requestParameters;

  ///[responseBody] is the response body received from server in the response
  final dynamic responseBody;
}

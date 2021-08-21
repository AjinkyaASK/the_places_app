enum NetworkRequestType { Get, Post }

///[NetworkRequest] is acts as a parameter class
///used by [NetworkHelper] class as a argument
class NetworkRequest {
  NetworkRequest({
    required this.requestUrl,
    required this.requestType,
    this.requestParameters,
  });

  ///[requestUrl] is a complete request url
  final String requestUrl;

  ///[requestType] is either Get or Post
  final NetworkRequestType requestType;

  ///[requestParameters] is query parameters/headers of the request
  ///this is optional
  final Map<String, String>? requestParameters;
}

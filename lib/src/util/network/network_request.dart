enum NetworkRequestType { Get, Post }

class NetworkRequest {
  NetworkRequest({
    required this.requestUrl,
    required this.requestType,
    this.requestParameters,
  });

  final String requestUrl;
  final NetworkRequestType requestType;
  final Map<String, String>? requestParameters;
}

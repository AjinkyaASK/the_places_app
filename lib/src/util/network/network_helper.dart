import 'package:http/http.dart' as http;

import '../../core/exception/network_exception.dart';
import 'network_request.dart';
import 'network_response.dart';

class NetworkHelper {
  static Future<NetworkResponse> request(NetworkRequest request) async {
    try {
      final Uri url = Uri.parse(request.requestUrl);

      switch (request.requestType) {
        case NetworkRequestType.Get:
          final response = await _get(
            url: url,
            params: request.requestParameters,
          );
          return response;

        case NetworkRequestType.Post:
          final response = await _post(
            url: url,
            params: request.requestParameters,
          );
          return response;
      }
    } on FormatException catch (exception) {
      throw NetworkException(
        source: 'NetworkHelper.request',
        message:
            'Error occured while parsing the requestUrl: ${exception.message}',
        requestType: request.requestType,
        requestUrl: request.requestUrl.toString(),
      );
    } on http.ClientException catch (exception) {
      throw NetworkException(
        source: 'NetworkHelper.request',
        message: exception.message,
        requestType: request.requestType,
        requestUrl: request.requestUrl.toString(),
      );
    } catch (error) {
      throw NetworkException(
        source: 'NetworkHelper.request',
        message: '$error',
        requestType: request.requestType,
        requestUrl: request.requestUrl.toString(),
      );
    }
  }

  static Future<NetworkResponse> _get({
    required final Uri url,
    final Map<String, String>? params,
  }) async {
    final http.Response response = await http.get(
      url,
      headers: params,
    );

    return NetworkResponse(
      requestType: NetworkRequestType.Get,
      httpCode: response.statusCode,
      requestUrl: url.toString(),
      requestParameters: params,
    );
  }

  static Future<NetworkResponse> _post({
    required final Uri url,
    final Map<String, String>? params,
  }) async {
    final http.Response response = await http.post(
      url,
      headers: params,
    );

    return NetworkResponse(
      requestType: NetworkRequestType.Post,
      httpCode: response.statusCode,
      requestUrl: url.toString(),
      requestParameters: params,
    );
  }
}

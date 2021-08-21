import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/exception/network_exception.dart';
import 'network_request.dart';
import 'network_response.dart';

/// [NetworkHelper] is a helper class that provides various methods
/// usefull for network related operations
class NetworkHelper {
  /// [isConnected] is a getter that tells if internet connection is available
  /// returns boolean future, as `true` when connectivity is available
  /// and `false` when not
  static Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      /// No internet
      return false;
    } catch (error) {
      print('Error while checking internet connection $error');

      /// Unexpected error thrown
      return false;
    }
  }

  /// The method [request] is used for creating HTTP Requests
  /// such as a GET or POST request, takes object of type [NetworkRequest]
  /// Returns a furue of type [NetworkResponse] when request was successfull
  /// throws exception of type [NetworkException] when something is wrong
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
      print('$error');
      throw NetworkException(
        source: 'NetworkHelper.request',
        message: '$error',
        requestType: request.requestType,
        requestUrl: request.requestUrl.toString(),
      );
    }
  }

  ///[_get] is an private method used by [request] method for HTTP Get request
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
      responseBody: jsonDecode(response.body),
    );
  }

  ///[_post] is an private method used by [request] method for HTTP Post request
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

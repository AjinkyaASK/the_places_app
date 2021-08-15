import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/src/core/exception/network_exception.dart';
import '../../../../lib/src/util/network/network_helper.dart';
import '../../../../lib/src/util/network/network_request.dart';

void main() {
  Future<void> invalidUrlCheck(NetworkRequestType requestType) async {
    // Arrange
    final String invalidUrl = 'some_random_string_which_is_not_a_url';

    // Act
    // Assert
    expect(
        () async => await NetworkHelper.request(NetworkRequest(
              requestUrl: invalidUrl,
              requestType: requestType,
            )),
        throwsA(isA<NetworkException>()));
  }

  Future<void> unreachableUrlCheck(NetworkRequestType requestType) async {
    // Arrange
    final String url = 'https://google.com/nopage';

    // Act
    final response = await NetworkHelper.request(NetworkRequest(
      requestUrl: url,
      requestType: requestType,
    ));

    // Assert
    expect(response.httpCode, 404);
  }

  Future<void> reachableUrlCheck({
    required final String url,
    required NetworkRequestType requestType,
  }) async {
    // Arrange
    // Act
    final response = await NetworkHelper.request(NetworkRequest(
      requestUrl: url,
      requestType: requestType,
    ));

    // Assert
    expect(response.httpCode, 200);
  }

  test(
      'Given call to request method for GET, when the requestUrl is not actually a url, throws NetworkException',
      () async {
    await invalidUrlCheck(NetworkRequestType.Get);
  });

  test(
      'Given call to request method for POST, when the requestUrl is not actually a url, throws NetworkException',
      () async {
    await invalidUrlCheck(NetworkRequestType.Post);
  });

  test(
      'Given call to request method for GET, when the requestUrl is not reachable, gives NetworkResponse with status code 404',
      () async {
    await unreachableUrlCheck(NetworkRequestType.Get);
  });

  test(
      'Given call to request method for POST, when the requestUrl is not reachable, gives NetworkResponse with status code 404',
      () async {
    await unreachableUrlCheck(NetworkRequestType.Post);
  });

  test(
      'Given call to request method for GET, when the requestUrl is reachable, gives NetworkResponse with status code 200',
      () async {
    await reachableUrlCheck(
      url: 'https://www.zee5.com/',
      requestType: NetworkRequestType.Get,
    );
  });

  test(
      'Given call to request method for POST, when the requestUrl is reachable, gives NetworkResponse with status code 200',
      () async {
    await reachableUrlCheck(
      url: 'https://www.zee5.com/',
      requestType: NetworkRequestType.Post,
    );
  });
}

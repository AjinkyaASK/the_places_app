import '../../../../../util/network/network_helper.dart';
import '../../../../../util/network/network_request.dart';
import '../../../core/api.dart';
import '../../../domain/entity/datasource.dart';
import '../../model/place.dart';

class PlacesDatasourceRemote extends PlacesDatasource {
  @override
  Future<List<Place>> get() async {
    final response = await NetworkHelper.request(NetworkRequest(
      requestUrl: PlacesApi.url,
      requestType: NetworkRequestType.Get,
    ));

    return List.unmodifiable(response.responseBody
        .map((place) => Place.fromMap(place as Map<String, dynamic>)));
  }

  @override
  Future<List<Place>> reset() => throw UnsupportedError(
      'Reset functionality is not supported for remote datasource');

  @override
  Future<void> set(List<Place> places) => throw UnsupportedError(
      'Set functionality is not supported for remote datasource');

  @override
  Future<void> remove(List<Place> places) => throw UnsupportedError(
      'Remove functionality is not supported for remote datasource');
}

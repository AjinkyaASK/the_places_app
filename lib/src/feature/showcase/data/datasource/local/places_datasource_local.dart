import 'package:hive/hive.dart';

import '../../../../../core/exception/general_exception.dart';
import '../../../domain/entity/datasource.dart';
import '../../model/place.dart';

class PlacesDatasourceLocal extends PlacesDatasource {
  static const String _placesBoxLabel = 'places_box_hive';
  static late final Box<Place> _placesBox;

  static Future<void> init() async {
    try {
      _placesBox = await Hive.openBox<Place>(_placesBoxLabel);
    } catch (error) {
      //TODO: Handle this error in better way
      print('Initialization error: Error while opening places box: $error');
    }
  }

  static Future<void> dispose() async {
    if (_placesBox.isOpen)
      await _placesBox.close();
    else
      throw GeneralException(
        source: 'PlacesDatasourceLocal',
        message:
            'Initialization error: Did you called init() before calling this?',
      );
  }

  void _initializationCheck() {
    //TODO: Handle this error in better way
    if (!_placesBox.isOpen)
      throw GeneralException(
        source: 'PlacesDatasourceLocal',
        message:
            'Initialization error: Did you called init() before calling this?',
      );
  }

  @override
  Future<List<Place>> get() async {
    _initializationCheck();

    final response = List<Place>.unmodifiable(_placesBox.values);
    return response;
  }

  @override
  Future<List<Place>> reset() async {
    _initializationCheck();

    final places = await get();

    await _placesBox.clear();

    return places;
  }

  @override
  Future<void> set(List<Place> places) async {
    _initializationCheck();

    //TODO: We don't need this below code for validating parameters once the storing actual object instead of Map is in place
    // for (final place in places) {
    //   if (!place.containsKey(PlacesApi.labels.id) ||
    //       place[PlacesApi.labels.id].toString().isEmpty)
    //     throw GeneralException(
    //         source: 'PlacesDatasourceLocal',
    //         message: 'id is empty or does not exist in the data');

    //   if (!place.containsKey(PlacesApi.labels.name) ||
    //       place[PlacesApi.labels.name].isEmpty)
    //     throw GeneralException(
    //         source: 'PlacesDatasourceLocal',
    //         message: 'name is empty or does not exist in the data');

    //   if (!place.containsKey(PlacesApi.labels.state) ||
    //       place[PlacesApi.labels.state].isEmpty)
    //     throw GeneralException(
    //         source: 'PlacesDatasourceLocal',
    //         message: 'state is empty or does not exist in the data');

    //   if (!place.containsKey(PlacesApi.labels.country) ||
    //       place[PlacesApi.labels.country].isEmpty)
    //     throw GeneralException(
    //         source: 'PlacesDatasourceLocal',
    //         message: 'country is empty or does not exist in the data');

    //   if (!place.containsKey(PlacesApi.labels.countryShort) ||
    //       place[PlacesApi.labels.countryShort].isEmpty)
    //     throw GeneralException(
    //         source: 'PlacesDatasourceLocal',
    //         message: 'country short is empty or does not exist in the data');
    // }

    for (final Place place in places) {
      _placesBox.put(place.id, place);
    }
  }
}

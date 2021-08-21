import 'package:hive/hive.dart';

import '../../../../core/exception/general_exception.dart';
import '../../core/api.dart';
import '../../domain/entity/place.dart';

part 'place.g.dart';

@HiveType(typeId: 0)
class Place extends PlaceBase {
  Place({
    @HiveField(0) required final int id,
    @HiveField(1) required final String name,
    @HiveField(2) required final String state,
    @HiveField(3) required final String country,
    @HiveField(4) required final String countryShort,
    @HiveField(5) final String? wikipediaLink,
    @HiveField(6) final String? googleMapsLink,
    @HiveField(7) bool favorite = false,
  }) : super(
          id: id,
          name: name,
          state: state,
          country: country,
          countryShort: countryShort,
          wikipediaLink: wikipediaLink,
          googleMapsLink: googleMapsLink,
          favorite: favorite,
        );

  factory Place.fromMap(Map<String, dynamic> data) {
    assert(
        data.containsKey(PlacesApi.labels.id),
        GeneralException(
            source: 'Place', message: 'id does not exist in the data'));
    assert(
        data.containsKey(PlacesApi.labels.name) &&
            data[PlacesApi.labels.name].isNotEmpty,
        GeneralException(
            source: 'Place',
            message: 'name is empty or does not exist in the data'));
    assert(
        data.containsKey(PlacesApi.labels.state) &&
            data[PlacesApi.labels.state].isNotEmpty,
        GeneralException(
            source: 'Place',
            message: 'state is empty or does not exist in the data'));
    assert(
        data.containsKey(PlacesApi.labels.country) &&
            data[PlacesApi.labels.country].isNotEmpty,
        GeneralException(
            source: 'Place',
            message: 'country is empty or does not exist in the data'));
    assert(
        data.containsKey(PlacesApi.labels.countryShort) &&
            data[PlacesApi.labels.countryShort].isNotEmpty,
        GeneralException(
            source: 'Place',
            message: 'countryShort is empty or does not exist in the data'));

    if (!data.containsKey(PlacesApi.labels.id) ||
        data[PlacesApi.labels.id].toString().isEmpty)
      throw GeneralException(
          source: 'Place', message: 'id does not exist in the data');

    if (!data.containsKey(PlacesApi.labels.name) ||
        data[PlacesApi.labels.name].isEmpty)
      GeneralException(
          source: 'Place',
          message: 'name is empty or does not exist in the data');

    if (!data.containsKey(PlacesApi.labels.state) ||
        data[PlacesApi.labels.state].isEmpty)
      GeneralException(
          source: 'Place',
          message: 'state is empty or does not exist in the data');

    if (!data.containsKey(PlacesApi.labels.country) ||
        data[PlacesApi.labels.country].isEmpty)
      GeneralException(
          source: 'Place',
          message: 'country is empty or does not exist in the data');

    if (!data.containsKey(PlacesApi.labels.countryShort) ||
        data[PlacesApi.labels.countryShort].isEmpty)
      GeneralException(
          source: 'Place',
          message: 'countryShort is empty or does not exist in the data');

    try {
      return Place(
        id: data[PlacesApi.labels.id] as int,
        name: data[PlacesApi.labels.name] as String,
        state: data[PlacesApi.labels.state] as String,
        country: data[PlacesApi.labels.country] as String,
        countryShort: data[PlacesApi.labels.countryShort] as String,
        wikipediaLink: data[PlacesApi.labels.wikipediaLink] as String?,
        googleMapsLink: data[PlacesApi.labels.googleMapsLink] as String?,
      );
    } catch (error) {
      throw GeneralException(
          source: 'Place', message: 'Error while parsing data: $error');
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      PlacesApi.labels.id: id,
      PlacesApi.labels.name: name,
      PlacesApi.labels.state: state,
      PlacesApi.labels.country: country,
      PlacesApi.labels.countryShort: countryShort,
      PlacesApi.labels.wikipediaLink: wikipediaLink,
      PlacesApi.labels.googleMapsLink: googleMapsLink,
    };
  }

  @override
  List<Object?> get props => [id];
}

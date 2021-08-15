import 'package:hive/hive.dart';

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
  }) : super(
          id: id,
          name: name,
          state: state,
          country: country,
          countryShort: countryShort,
          wikipediaLink: wikipediaLink,
          googleMapsLink: googleMapsLink,
        );

  factory Place.fromMap(Map<String, dynamic> data) {
    assert(data.containsKey(PlacesApi.labels.id));
    assert(data.containsKey(PlacesApi.labels.name) &&
        data[PlacesApi.labels.name].isNotEmpty);
    assert(data.containsKey(PlacesApi.labels.state) &&
        data[PlacesApi.labels.state].isNotEmpty);
    assert(data.containsKey(PlacesApi.labels.country) &&
        data[PlacesApi.labels.country].isNotEmpty);
    assert(data.containsKey(PlacesApi.labels.countryShort) &&
        data[PlacesApi.labels.countryShort].isNotEmpty);

    if (!data.containsKey(PlacesApi.labels.id) ||
        data[PlacesApi.labels.id].toString().isEmpty)
      throw 'id is empty or does not exist in the data';

    if (!data.containsKey(PlacesApi.labels.name) ||
        data[PlacesApi.labels.name].isEmpty)
      throw 'name is empty or does not exist in the data';

    if (!data.containsKey(PlacesApi.labels.state) ||
        data[PlacesApi.labels.state].isEmpty)
      throw 'state is empty or does not exist in the data';

    if (!data.containsKey(PlacesApi.labels.country) ||
        data[PlacesApi.labels.country].isEmpty)
      throw 'country is empty or does not exist in the data';

    if (!data.containsKey(PlacesApi.labels.countryShort) ||
        data[PlacesApi.labels.countryShort].isEmpty)
      throw 'country short is empty or does not exist in the data';

    return Place(
      id: data[PlacesApi.labels.id],
      name: data[PlacesApi.labels.name],
      state: data[PlacesApi.labels.state],
      country: data[PlacesApi.labels.country],
      countryShort: data[PlacesApi.labels.countryShort],
      wikipediaLink: data[PlacesApi.labels.wikipediaLink],
      googleMapsLink: data[PlacesApi.labels.googleMapsLink],
    );
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

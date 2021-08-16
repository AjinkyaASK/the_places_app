import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_places_app/src/feature/showcase/data/datasource/local/places_datasource_local.dart';
import 'package:the_places_app/src/feature/showcase/data/datasource/remote/places_datasource_remote.dart';
import 'package:the_places_app/src/feature/showcase/data/model/place.dart';
import 'package:the_places_app/src/feature/showcase/data/repository/repository.dart';
import 'package:the_places_app/src/feature/showcase/domain/entity/place.dart';
import 'package:the_places_app/src/feature/showcase/domain/repository/repository.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  final List<Map<String, dynamic>> placesData = [
    {
      "country": "India",
      "name": "Addanki",
      "wikipediaLink": "https://en.wikipedia.org/wiki/Addanki",
      "googleMapsLink":
          "https://maps.google.com/maps?ll=15.81667,79.98333&spn=0.1,0.1&t=h&q=15.81667,79.98333",
      "id": 66755,
      "asciiName": "Addanki",
      "state": "02",
      "countryDigraph": "IN"
    },
    {
      "country": "United States",
      "name": "Westminster",
      "wikipediaLink": "https://en.wikipedia.org/wiki/Westminster,_MA",
      "googleMapsLink":
          "https://maps.google.com/maps?ll=42.54592,-71.91063&spn=0.1,0.1&t=h&q=42.54592,-71.91063",
      "id": 113892,
      "asciiName": "Westminster",
      "state": "MA",
      "countryDigraph": "US"
    },
    {
      "country": "Philippines",
      "name": "Murcia",
      "wikipediaLink": "https://en.wikipedia.org/wiki/Murcia",
      "googleMapsLink":
          "https://maps.google.com/maps?ll=15.40425,120.60903&spn=0.1,0.1&t=h&q=15.40425,120.60903",
      "id": 85235,
      "asciiName": "Murcia",
      "state": "03",
      "countryDigraph": "PH"
    }
  ];

  final PlacesDatasourceRemote datasourceRemote = PlacesDatasourceRemote();
  final PlacesDatasourceLocal datasourceLocal = PlacesDatasourceLocal();
  final PlacesRepository repository = PlacesRepository(
    datasourceLocal: PlacesDatasourceLocal(),
    datasourceRemote: datasourceRemote,
  );

  test(
    'PlacesRepository extends the intended abstract classes',
    () async {
      // Arrange
      // Act
      // Assert
      expect(
        repository,
        isA<PlacesRepositoryBase>(),
      );
    },
  );

  test(
      'Given call to getPlaces, When remoteDataSource is available, Then it returns a list of Place',
      () async {
    // Arrange
    // Act
    final response = await repository.getPlaces();

    // Assert
    expect(
      response,
      isA<List<Place>>(),
    );
  });

  test(
      'Given call to getFavoritePlaces, When localDataSource is available, Then it returns a list of Place',
      () async {
    // Arrange
    await PlacesDatasourceLocal.init();

    // Act
    final response = await repository.getFavoritePlaces();

    // Assert
    expect(
      response,
      isA<List<Place>>(),
    );
  });

  test(
    'Given call to setPlaces, in all cases, it throws a UnsupportedError',
    () {
      // Arrange
      final List<Place> places = <Place>[];

      // Act
      // Assert
      expect(
        repository.setPlaces(places),
        throwsA(isA<UnsupportedError>()),
      );
    },
  );

  test(
    'Given call to setFavoritePlaces with a list of place, When localDataSource is available, Then it stores given data and completes normally',
    () async {
      // Arrange
      await PlacesDatasourceLocal.init();
      final List<Place> placesRequestedToStored =
          placesData.map((place) => Place.fromMap(place)).toList();
      final List<Place> storedPlaces = [];

      // Act
      // Assert
      expect(
        () async => await repository.setFavoritePlaces(placesRequestedToStored),
        returnsNormally,
      );
      storedPlaces.addAll((await repository.getFavoritePlaces())
          .map((place) => place as Place)
          .toList());
      expect(
        placesRequestedToStored
            .every((element) => storedPlaces.contains(element)),
        true,
      );
    },
  );
}

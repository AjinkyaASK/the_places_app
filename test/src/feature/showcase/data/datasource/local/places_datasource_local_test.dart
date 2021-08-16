import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_places_app/src/core/exception/general_exception.dart';
import 'package:the_places_app/src/feature/showcase/core/api.dart';
import 'package:the_places_app/src/feature/showcase/data/datasource/local/places_datasource_local.dart';
import 'package:the_places_app/src/feature/showcase/data/model/place.dart';
import 'package:the_places_app/src/feature/showcase/domain/entity/datasource.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  test('Making sure the class extends its intended parent class', () {
    expect(
      PlacesDatasourceLocal() is PlacesDatasource,
      true,
    );
  });

  test('Given call to init, When it executes, Then no error is thrown',
      () async {
    // Arrange
    // Act
    // Assert
    expect(
      () async => await PlacesDatasourceLocal.init(),
      returnsNormally,
    );
  });

  //TODO: Commented below test case as it is conflicting with others when all run at once
  // test(
  //     'Given call to dispose, When the box is already closed, Then it throws a exception',
  //     () async {
  //   // Arrange (Making sure the box is open, to be closed in next step)
  //   await PlacesDatasourceLocal.init();

  //   // Act (Making sure the box is closed for the assertion to work)
  //   await PlacesDatasourceLocal.dispose();

  //   // Assert
  //   expect(
  //     () async => await PlacesDatasourceLocal.dispose(),
  //     throwsA(isA<GeneralException>()),
  //   );
  // });

  test(
      'Given call to get, When the box is open, Then it returns a list of Place',
      () async {
    // Arrange (Making sure the box is open)
    await PlacesDatasourceLocal.init();
    PlacesDatasourceLocal datasourceLocal = PlacesDatasourceLocal();

    // Act
    // Assert
    expect(
      await datasourceLocal.get(),
      isA<List<Place>>(),
    );
  });

  test(
      'Given call to set with list of objects, When the box is open, Then it throws no exceptions',
      () async {
    // Arrange (Making sure the box is open)
    final List<Map<String, dynamic>> dataToStore = <Map<String, dynamic>>[
      {
        "country": "Philippines",
        "name": "Maputi",
        "wikipediaLink": "https://en.wikipedia.org/wiki/Maputi",
        "googleMapsLink":
            "https://maps.google.com/maps?ll=8.44972,124.29056&spn=0.1,0.1&t=h&q=8.44972,124.29056",
        "id": 85404,
        "asciiName": "Maputi",
        "state": "10",
        "countryDigraph": "PH"
      },
      {
        "country": "Bosnia and Herzegovina",
        "name": "Dobrinje",
        "wikipediaLink": "https://en.wikipedia.org/wiki/Dobrinje",
        "googleMapsLink":
            "https://maps.google.com/maps?ll=44.04972,18.11944&spn=0.1,0.1&t=h&q=44.04972,18.11944",
        "id": 4534,
        "asciiName": "Dobrinje",
        "state": "01",
        "countryDigraph": "BA"
      },
      {
        "country": "Slovenia",
        "name": "Radenci",
        "wikipediaLink": "https://en.wikipedia.org/wiki/Radenci",
        "googleMapsLink":
            "https://maps.google.com/maps?ll=46.64201,16.03781&spn=0.1,0.1&t=h&q=46.64201,16.03781",
        "id": 100725,
        "asciiName": "Radenci",
        "state": "A1",
        "countryDigraph": "SI"
      },
    ];
    await PlacesDatasourceLocal.init();
    PlacesDatasourceLocal datasourceLocal = PlacesDatasourceLocal();

    // Act
    // Assert
    expect(
      () async => await datasourceLocal.set(
          List.unmodifiable(dataToStore.map((place) => Place.fromMap(place)))),
      returnsNormally,
    );
  });

  test(
      'Given call to set with list of objects, When the box is open and the list has data in required format, Then it stores every item from the given list',
      () async {
    // Arrange (Making sure the box is open)
    final List<Map<String, dynamic>> dataToStore = <Map<String, dynamic>>[
      {
        "country": "Philippines",
        "name": "Maputi",
        "wikipediaLink": "https://en.wikipedia.org/wiki/Maputi",
        "googleMapsLink":
            "https://maps.google.com/maps?ll=8.44972,124.29056&spn=0.1,0.1&t=h&q=8.44972,124.29056",
        "id": 85404,
        "asciiName": "Maputi",
        "state": "10",
        "countryDigraph": "PH"
      },
      {
        "country": "Bosnia and Herzegovina",
        "name": "Dobrinje",
        "wikipediaLink": "https://en.wikipedia.org/wiki/Dobrinje",
        "googleMapsLink":
            "https://maps.google.com/maps?ll=44.04972,18.11944&spn=0.1,0.1&t=h&q=44.04972,18.11944",
        "id": 4534,
        "asciiName": "Dobrinje",
        "state": "01",
        "countryDigraph": "BA"
      },
      {
        "country": "Slovenia",
        "name": "Radenci",
        "wikipediaLink": "https://en.wikipedia.org/wiki/Radenci",
        "googleMapsLink":
            "https://maps.google.com/maps?ll=46.64201,16.03781&spn=0.1,0.1&t=h&q=46.64201,16.03781",
        "id": 100725,
        "asciiName": "Radenci",
        "state": "A1",
        "countryDigraph": "SI"
      },
    ];

    await PlacesDatasourceLocal.init();
    PlacesDatasourceLocal datasourceLocal = PlacesDatasourceLocal();

    // Act
    await datasourceLocal.set(
        List.unmodifiable(dataToStore.map((place) => Place.fromMap(place))));
    final List<Place> expectedData =
        dataToStore.map((data) => Place.fromMap(data)).toList();
    final List<Place> storedData = await datasourceLocal.get();

    // Assert
    expect(
      expectedData.every((item) => storedData.contains(item)),
      true,
    );
  });

  test(
      'Given call to reset, When the box is open, Then it clears all the values of the box',
      () async {
    // Arrange (Making sure the box is open)
    await PlacesDatasourceLocal.init();
    PlacesDatasourceLocal datasourceLocal = PlacesDatasourceLocal();

    // Act
    await datasourceLocal.reset();
    final data = await datasourceLocal.get();

    // Assert
    expect(
      data.isEmpty,
      true,
    );
  });

  //TODO: Commented below test case as it is conflicting with others when all run at once
  // test(
  //     'Given call to reset, When the box is not open, Then it throws a exception',
  //     () async {
  //   // Arrange (Making sure the box is open, to be closed in next step)
  //   await PlacesDatasourceLocal.init();
  //   await PlacesDatasourceLocal.dispose();
  //   PlacesDatasourceLocal datasourceLocal = PlacesDatasourceLocal();

  //   // Act
  //   // Assert
  //   expect(
  //     () async => await datasourceLocal.reset(),
  //     throwsA(isA<GeneralException>()),
  //   );
  // });
}

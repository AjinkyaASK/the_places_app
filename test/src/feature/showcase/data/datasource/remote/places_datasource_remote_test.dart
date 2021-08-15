import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_places_app/src/feature/showcase/data/datasource/remote/places_datasource_remote.dart';
import 'package:the_places_app/src/feature/showcase/data/model/place.dart';
import 'package:the_places_app/src/feature/showcase/domain/entity/datasource.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  test('Making sure the class extends its intended parent class', () {
    expect(
      PlacesDatasourceRemote() is PlacesDatasource,
      true,
    );
  });

  test(
      'Given call to get, When the API and Network is available, Then it returns a list of Place',
      () async {
    // Arrange
    PlacesDatasourceRemote datasourceRemote = PlacesDatasourceRemote();

    // Act
    // Assert
    expect(
      await datasourceRemote.get(),
      isA<List<Place>>(),
    );
  });

  test('Given call to set, At all cases, Then it throws UnsupportedError',
      () async {
    // Arrange (Making sure the box is open)
    PlacesDatasourceRemote datasourceRemote = PlacesDatasourceRemote();

    // Act
    // Assert
    expect(
      () async => await datasourceRemote.set([]),
      throwsA(isA<UnsupportedError>()),
    );
  });

  test('Given call to reset, At all cases, Then it throws UnsupportedError',
      () async {
    // Arrange (Making sure the box is open)
    PlacesDatasourceRemote datasourceRemote = PlacesDatasourceRemote();

    // Act
    // Assert
    expect(
      () async => await datasourceRemote.reset(),
      throwsA(isA<UnsupportedError>()),
    );
  });
}

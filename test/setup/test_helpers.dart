import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:the_places_app/src/feature/showcase/data/datasource/local/places_datasource_local.dart';
import 'package:the_places_app/src/feature/showcase/data/datasource/remote/places_datasource_remote.dart';
import 'package:the_places_app/src/feature/showcase/data/model/place.dart';
import 'package:the_places_app/src/feature/showcase/data/repository/repository.dart';
import 'package:the_places_app/src/feature/showcase/domain/entity/place.dart';

/// This file contains helpers (mocks/instances of classes or methods)
/// required for the unit tests to execute

class PlaceMock extends Mock implements Place {}

class PlacesDatasourceLocalMock extends Mock implements PlacesDatasourceLocal {
  @override
  Future<List<Place>> get() async {
    return List.from([
      PlaceMock(),
    ]);
  }
}

class PlacesDatasourceRemoteMock extends Mock
    implements PlacesDatasourceRemote {
  @override
  Future<List<Place>> get() async {
    return List.from([
      PlaceMock(),
    ]);
  }
}

class PlacesRepositoryMock extends Mock implements PlacesRepository {
  @override
  Future<List<PlaceBase>> getFavoritePlaces() async {
    return List.from([
      PlaceMock(),
    ]);
  }
}

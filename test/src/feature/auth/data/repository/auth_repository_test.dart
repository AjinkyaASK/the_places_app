import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:the_places_app/src/feature/auth/data/datasource/local/user_datasource_local.dart';
import 'package:the_places_app/src/feature/auth/data/model/user.dart';
import 'package:the_places_app/src/feature/auth/data/repository/auth_repository.dart';
import 'package:the_places_app/src/feature/auth/domain/entity/user.dart';
import 'package:the_places_app/src/feature/auth/domain/repository/auth_repository.dart';

import '../../../../../setup/test_helpers.dart';

void main() async {
  await Hive.initFlutter();

  final AuthRepositoryMock repository = AuthRepositoryMock();

  test(
    'AuthRepository extends the intended abstract classes',
    () async {
      // Arrange
      // Act
      // Assert
      expect(
        repository,
        isA<AuthRepositoryBase>(),
      );
    },
  );

  test(
      'Given call to getPlaces, When remoteDataSource is available, Then it returns a list of Place',
      () async {
    // Arrange
    final PlacesAppUser user = PlacesAppUser(
      name: 'name',
      pictureUrl: 'pictureUrl',
    );
    when(repository.signInAsGuest()).thenAnswer((_) async => user);
    // Act
    // Assert
    expect(
      await repository.signInAsGuest(),
      isA<PlacesAppUser>(),
    );
  });
}

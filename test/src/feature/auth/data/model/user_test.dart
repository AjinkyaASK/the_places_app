import 'package:flutter_test/flutter_test.dart';
import 'package:the_places_app/src/feature/auth/core/auth_database_keys.dart';
import 'package:the_places_app/src/feature/auth/data/model/user.dart';
import 'package:the_places_app/src/feature/auth/domain/entity/user.dart';

void main() {
  const Map<String, dynamic> validUserData = <String, dynamic>{
    AuthLocalDatabaseKeys.name: 'new user',
    AuthLocalDatabaseKeys.pictureUrl: 'picture',
  };

  const Map<String, dynamic> incompleteUserData = <String, dynamic>{
    AuthLocalDatabaseKeys.name: 'new user',
  };

  test(
    'Place extends the intended abstract classes',
    () async {
      // Arrange
      final PlacesAppUser user = PlacesAppUser.fromMap(validUserData);
      // Act
      // Assert
      expect(user, isA<PlacesAppUserBase>());
    },
  );

  test(
    'Given call to the factory method fromMap, When passed a object of Map<String, dynamic> with all required parameters, Then it returns a object of type PlacesAppUser',
    () {
      // Arrange
      // Act
      final object = PlacesAppUser.fromMap(validUserData);

      // Assert
      expect(
        object,
        isA<PlacesAppUser>(),
      );
    },
  );

  test(
    'Given call to the factory method fromMap, When passed a object of Map<String, dynamic> with some incomplete parameters, Then it throws a exception',
    () {
      // Arrange
      // Act
      // Assert
      expect(
        () => PlacesAppUser.fromMap(incompleteUserData),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  test(
    'Given call to toMap(), When the object is initialized, Then it returns the details of the object in Map<Stringm, dynamic> format',
    () async {
      // Arrange
      final PlacesAppUser user = PlacesAppUser.fromMap(validUserData);

      // Act
      final response = user.toMap();

      // Assert
      expect(
        response,
        isA<Map<String, dynamic>>(),
      );
    },
  );
}

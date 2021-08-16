import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_places_app/src/core/exception/general_exception.dart';
import 'package:the_places_app/src/feature/showcase/data/model/place.dart';
import 'package:the_places_app/src/feature/showcase/domain/entity/place.dart';

void main() {
  const Map<String, dynamic> validPlaceData = <String, dynamic>{
    "country": "India",
    "name": "Dūdhi",
    "wikipediaLink": "https://en.wikipedia.org/wiki/Dūdhi",
    "googleMapsLink":
        "https://maps.google.com/maps?ll=24.21667,83.25&spn=0.1,0.1&t=h&q=24.21667,83.25",
    "id": 65901,
    "asciiName": "Dudhi",
    "state": "36",
    "countryDigraph": "IN"
  };

  const Map<String, dynamic> incompletePlaceData = <String, dynamic>{
    "country": "India",
    "name": "Dūdhi",
    "wikipediaLink": "https://en.wikipedia.org/wiki/Dūdhi",
    "googleMapsLink":
        "https://maps.google.com/maps?ll=24.21667,83.25&spn=0.1,0.1&t=h&q=24.21667,83.25",
    "asciiName": "Dudhi",
    "state": "36",
    "countryDigraph": "IN"
  };

  const Map<String, dynamic> invalidPlaceData = <String, dynamic>{
    "country": "India",
    "name": "Dūdhi",
    "wikipediaLink": "https://en.wikipedia.org/wiki/Dūdhi",
    "googleMapsLink":
        "https://maps.google.com/maps?ll=24.21667,83.25&spn=0.1,0.1&t=h&q=24.21667,83.25",
    "id": "65901",
    "asciiName": "Dudhi",
    "state": "36",
    "countryDigraph": "IN"
  };

  test(
    'Place extends the intended abstract classes',
    () async {
      // Arrange
      final Place place = Place.fromMap(validPlaceData);
      // Act
      // Assert
      expect(place, isA<PlaceBase>());
      expect(place, isA<Equatable>());
    },
  );

  test(
    'Given call to the factory method fromMap, When passed a object of Map<String, dynamic> with all required parameters, Then it returns a object of type Place',
    () {
      // Arrange
      // Act
      final object = Place.fromMap(validPlaceData);

      // Assert
      expect(
        object,
        isA<Place>(),
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
        () => Place.fromMap(incompletePlaceData),
        throwsA(isA<AssertionError>()),
      );
    },
  );

  test(
    'Given call to the factory method fromMap, When passed a object of Map<String, dynamic> with some invalid parameters, Then it throws a exception',
    () {
      // Arrange
      // Act
      // Assert
      expect(
        () => Place.fromMap(invalidPlaceData),
        throwsA(isA<GeneralException>()),
      );
    },
  );

  test(
    'Given call to toMap(), When the object is initialized, Then it returns the details of the object in Map<Stringm, dynamic> format',
    () async {
      // Arrange
      final Place place = Place.fromMap(validPlaceData);

      // Act
      final response = place.toMap();

      // Assert
      expect(
        response,
        isA<Map<String, dynamic>>(),
      );
    },
  );
}

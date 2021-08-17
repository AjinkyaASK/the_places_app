import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_places_app/src/core/usecase/usecase_base.dart';
import 'package:the_places_app/src/feature/showcase/domain/usecase/get_favorite_places_usecase.dart';
import '../../../../../setup/test_helpers.dart';

void main() {
  final PlacesRepositoryMock placesRepositoryMock = PlacesRepositoryMock();
  final GetFavoritePlacesUsecase getFavoritePlacesUsecase =
      GetFavoritePlacesUsecase(placesRepositoryMock);

  test(
    'GetFavoritePlacesUsecase implements UsecaseBase',
    () async {
      // Arrange
      // Act
      // Assert
      expect(
        getFavoritePlacesUsecase,
        isA<UsecaseBase>(),
      );
    },
  );

  test(
    'Given call on (), it calls getFavoritePlaces once',
    () async {
      // Arrange
      // when(await placesRepositoryMock.getFavoritePlaces())
      //     .thenReturn([PlaceMock()]);
      // Act
      await getFavoritePlacesUsecase();

      // Assert
      verify(placesRepositoryMock.getFavoritePlaces());
    },
  );
}

import '../entity/datasource.dart';
import '../entity/place.dart';

abstract class PlacesRepositoryBase {
  PlacesRepositoryBase({
    required this.datasourceLocal,
    required this.datasourceRemote,
  });

  final PlacesDatasource datasourceLocal;
  final PlacesDatasource datasourceRemote;

  Future<List<PlaceBase>> getPlaces();
  Future<List<PlaceBase>> getFavoritePlaces();
  Future<void> setPlaces(List<PlaceBase> places);
  Future<void> setFavoritePlaces(List<PlaceBase> places);
  Future<void> removeFavoritePlaces(List<PlaceBase> places);
}

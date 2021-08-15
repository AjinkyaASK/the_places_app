import '../../data/model/place.dart';

abstract class PlacesDatasource {
  Future<List<Place>> get();
  Future<void> set(List<Place> places);
  Future<List<Place>> reset();
}

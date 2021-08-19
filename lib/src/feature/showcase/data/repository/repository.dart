import '../../domain/entity/place.dart';
import '../../domain/repository/repository.dart';
import '../datasource/local/places_datasource_local.dart';
import '../datasource/remote/places_datasource_remote.dart';
import '../model/place.dart';

class PlacesRepository extends PlacesRepositoryBase {
  PlacesRepository({
    required final PlacesDatasourceLocal datasourceLocal,
    required final PlacesDatasourceRemote datasourceRemote,
  }) : super(
          datasourceLocal: datasourceLocal,
          datasourceRemote: datasourceRemote,
        );

  @override
  Future<List<PlaceBase>> getPlaces() async {
    final List<Place> places = List.unmodifiable(await datasourceRemote.get());
    return places;
  }

  @override
  Future<List<PlaceBase>> getFavoritePlaces() async {
    final List<Place> places = List.unmodifiable(await datasourceLocal.get());
    return places;
  }

  @override
  Future<void> setPlaces(List<PlaceBase> places) async {
    throw UnsupportedError('setPlaces is not supported yet');
  }

  @override
  Future<void> setFavoritePlaces(List<PlaceBase> places) async {
    datasourceLocal.set(List.unmodifiable(places.map((place) => Place(
          id: place.id,
          name: place.name,
          state: place.state,
          country: place.country,
          countryShort: place.countryShort,
          wikipediaLink: place.wikipediaLink,
          googleMapsLink: place.googleMapsLink,
          favorite: true,
        ))));
  }

  @override
  Future<void> removeFavoritePlaces(List<PlaceBase> places,
      {bool removeAll = false}) async {
    if (!removeAll)
      datasourceLocal
          .remove(List.unmodifiable(places.map((place) => place as Place)));
    else
      datasourceLocal.reset();
  }
}

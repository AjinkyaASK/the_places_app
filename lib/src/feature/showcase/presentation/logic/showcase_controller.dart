import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/exception.dart';
import '../../core/messages.dart';
import '../../data/model/place.dart';
import '../../domain/entity/place.dart';
import '../../domain/usecase/get_favorite_places_usecase.dart';
import '../../domain/usecase/get_places_usecase.dart';
import '../../domain/usecase/remove_favorite_places_usecase.dart';
import '../../domain/usecase/set_places_usecase.dart';

class ShowcaseController extends ChangeNotifier {
  ShowcaseController({
    required this.getPlacesUsecase,
    required this.getFavoritePlacesUsecase,
    required this.setPlacesUsecase,
    required this.removeFavoritePlacesUsecase,
  }) {
    //TODO: Not sure about placement of this call
    // init();
  }

  final GetPlacesUsecase getPlacesUsecase;
  final GetFavoritePlacesUsecase getFavoritePlacesUsecase;
  final SetPlacesUsecase setPlacesUsecase;
  final RemoveFavoritePlacesUsecase removeFavoritePlacesUsecase;

  void refresh() => notifyListeners();

  static bool _loading = false;
  bool get loading => _loading;

  static final List<Place> _places = [];
  List<Place> get places => List.unmodifiable(_places);

  static final List<Place> _favoritePlaces = [];
  List<Place> get favoritePlaces => List.unmodifiable(_favoritePlaces);

  void startLoading() {
    _loading = true;
    refresh();
  }

  void doneLoading() {
    _loading = false;
    refresh();
  }

  void flashError(String message) {
    //TODO: Implement something that flashes error
  }

  void flashSuccess() {
    //TODO: Implement something that flashes success
  }

  Future<void> init(void Function() onComplete) async {
    ///`loadFavoritePlaces` is placed first as it fetches data from local storage, apparently finishes work faster,
    ///and this is what is available to show when device is in offline mode
    await loadFavoritePlaces();

    ///This is second in sequence, because this is dependent on Network Connectivity and takes longer execution time
    //TODO: Place a network connectivity check here before calling `loadPlaces`
    await loadPlaces(onComplete);
  }

  Future<void> onRemoved({
    required Place place,
    required void Function() onComplete,
  }) async {
    _places.removeWhere((item) => item.id == place.id);
    if (_places.isEmpty)
      await loadPlaces(onComplete);
    else
      onComplete();
    refresh();
  }

  Future<void> onFavorite({
    required Place place,
    required void Function() onComplete,
  }) async {
    final Either<Exception, void> result = await setPlacesUsecase(
      places: List.from([place]),
    );
    result.fold(
      (exception) {
        flashError(exception.message ?? '');
        refresh();
      },
      (done) async {
        _favoritePlaces.add(Place(
          id: place.id,
          name: place.name,
          state: place.state,
          country: place.country,
          countryShort: place.countryShort,
          wikipediaLink: place.wikipediaLink,
          googleMapsLink: place.googleMapsLink,
          favorite: true,
        ));
        _places.removeWhere((item) => item.id == place.id);
        if (_places.isEmpty)
          await loadPlaces(onComplete);
        else
          onComplete();
        refresh();
        refresh();
      },
    );
  }

  Future<void> onFavoriteRemoved({
    required Place place,
    required void Function() onComplete,
  }) async {
    final Either<Exception, void> result = await removeFavoritePlacesUsecase(
      places: List.from([place]),
    );
    result.fold(
      (exception) {
        flashError(exception.message ?? '');
        refresh();
      },
      (done) {
        _favoritePlaces.remove(place);
        onComplete();
        refresh();
      },
    );
  }

  Future<void> removeAllFavorites() async {
    final Either<Exception, void> result = await removeFavoritePlacesUsecase(
      places: List.from([]),
      removeAll: true,
    );
    result.fold(
      (exception) {
        flashError(exception.message ?? '');
        refresh();
      },
      (done) {
        _favoritePlaces.clear();
        refresh();
      },
    );
  }

  Future<void> loadPlaces(void Function() onComplete) async {
    startLoading();

    final Either<Exception, List<PlaceBase>> response =
        await getPlacesUsecase();

    response.fold(
      (Exception exception) {
        flashError(exception.message ?? ShowcaseMessages.BlanketErrorMessage);
        onComplete();
        doneLoading();
      },
      (List<PlaceBase> places) {
        _places.clear();
        _places.addAll(places.map((place) => place as Place));
        onComplete();
        doneLoading();
        //TODO: Not sure about below statement
        flashSuccess();
      },
    );
  }

  Future<void> loadFavoritePlaces() async {
    startLoading();

    final Either<Exception, List<PlaceBase>> response =
        await getFavoritePlacesUsecase();

    response.fold(
      (Exception exception) {
        flashError(exception.message ?? ShowcaseMessages.BlanketErrorMessage);
        doneLoading();
      },
      (List<PlaceBase> places) {
        _favoritePlaces.clear();
        _favoritePlaces.addAll(places.map((place) => place as Place));
        doneLoading();
        //TODO: Not sure about below statement
        flashSuccess();
      },
    );
  }
}

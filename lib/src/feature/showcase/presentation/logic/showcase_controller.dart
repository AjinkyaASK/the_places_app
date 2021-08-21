import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../../value/strings.dart';
import '../../../auth/data/datasource/local/user_datasource_local.dart';
import '../../../auth/data/repository/auth_repository.dart';
import '../../data/model/place.dart';
import '../../domain/entity/place.dart';
import '../../domain/usecase/get_favorite_places_usecase.dart';
import '../../domain/usecase/get_places_usecase.dart';
import '../../domain/usecase/remove_favorite_places_usecase.dart';
import '../../domain/usecase/set_places_usecase.dart';

///[ShowcaseController] is the logical controller
///that handles all logical operations Showcase View screen
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

  ///[getPlacesUsecase] is executed to fetch places from API
  final GetPlacesUsecase getPlacesUsecase;

  ///[getFavoritePlacesUsecase] is executed to fetch favorite places from local database
  final GetFavoritePlacesUsecase getFavoritePlacesUsecase;

  ///[setPlacesUsecase] is executed to store favorite places from local database
  final SetPlacesUsecase setPlacesUsecase;

  ///[removeFavoritePlacesUsecase] is executed to remove favorite places from local database
  final RemoveFavoritePlacesUsecase removeFavoritePlacesUsecase;

  ///[refresh] rebuilds the widget tree
  void refresh() => notifyListeners();

  static bool _loading = false;

  ///[loading] indicates if the logic controller is doing some operation
  bool get loading => _loading;

  static final List<Place> _places = [];

  ///[places] is the list of places fetched from API
  List<Place> get places => List.unmodifiable(_places);

  static final List<Place> _favoritePlaces = [];

  ///[favoritePlaces] is the list of favorite places fetched from local database
  List<Place> get favoritePlaces => List.unmodifiable(_favoritePlaces);

  ///[startLoading] sets the loading to `true`
  ///and rebuilds to widget tree
  void startLoading() {
    _loading = true;
    refresh();
  }

  ///[startLoading] sets the loading to `false`
  ///and rebuilds to widget tree
  void doneLoading() {
    _loading = false;
    refresh();
  }

  ///[flashError] used to show error messages to the users
  void flashError(String message) {
    //TODO: Implement something that flashes error
    log(message);
  }

  ///[flashSuccess] used to show success messages to the users
  void flashSuccess() {
    //TODO: Implement something that flashes success
  }

  ///[init] calls [loadFavoritePlaces] and [loadPlaces] in sequence
  ///takes a `void Function` and execute when methods are finished executing
  Future<void> init(void Function() onComplete) async {
    ///`loadFavoritePlaces` is placed first as it fetches data from local storage, apparently finishes work faster,
    ///and this is what is available to show when device is in offline mode
    await loadFavoritePlaces();

    ///This is second in sequence, because this is dependent on Network Connectivity and takes longer execution time
    //TODO: Place a network connectivity check here before calling `loadPlaces`
    await loadPlaces(onComplete);
  }

  ///[onRemoved] takes a object of `Place` to be removed from list of places
  ///and a void callback [onComplete] which gets executed when place is removed
  Future<void> onRemoved({
    required Place place,
    required void Function() onComplete,
  }) async {
    _places.removeWhere((item) => item.id == place.id);
    //If the list is empty, [loadPlaces] is called again to load next set of places from API
    if (_places.isEmpty)
      await loadPlaces(onComplete);
    else
      onComplete();
    // Rebuilding widget tree to reflect changes
    refresh();
  }

  ///[onFavorite] takes a object of `Place` to be stored as favorite
  ///and a void callback [onComplete] which gets executed when place is stored as favorite
  Future<void> onFavorite({
    required Place place,
    required void Function() onComplete,
  }) async {
    //Executing SetPlacesUsecase
    final Either<Exception, void> result = await setPlacesUsecase(
      places: List.from([place]),
    );
    result.fold(
      (exception) {
        flashError(exception.message ?? '');
        // Rebuilding widget tree to reflect changes
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
        // Rebuilding widget tree to reflect changes
        refresh();
      },
    );
  }

  ///[onFavoriteRemoved] takes a object of `Place` to be removed from list of favorite places
  ///and a void callback [onComplete] which gets executed when place is removed
  Future<void> onFavoriteRemoved({
    required Place place,
    required void Function() onComplete,
  }) async {
    //Executing RemoveFavoritePlacesUsecase
    final Either<Exception, void> result = await removeFavoritePlacesUsecase(
      places: List.from([place]),
    );
    result.fold(
      (exception) {
        flashError(exception.message ?? '');
        // Rebuilding widget tree to reflect changes
        refresh();
      },
      (done) {
        _favoritePlaces.remove(place);
        onComplete();
        // Rebuilding widget tree to reflect changes
        refresh();
      },
    );
  }

  ///[removeAllFavorites] removes all entries from favorites
  Future<void> removeAllFavorites() async {
    final Either<Exception, void> result = await removeFavoritePlacesUsecase(
      places: List.from([]),
      removeAll: true,
    );
    result.fold(
      (exception) {
        flashError(exception.message ?? '');
        // Rebuilding widget tree to reflect changes
        refresh();
      },
      (done) {
        _favoritePlaces.clear();
        // Rebuilding widget tree to reflect changes
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
        flashError(exception.message ?? Strings.blanketErrorMessage);
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
    //Executing GetFavoritePlacesUsecase
    final Either<Exception, List<PlaceBase>> response =
        await getFavoritePlacesUsecase();

    response.fold(
      (Exception exception) {
        flashError(exception.message ?? Strings.blanketErrorMessage);
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

  ///[onSignOut] signs out the user from the application
  ///resets the list stored favorite places
  ///and navigates user back to authentication screen
  Future<void> onSignOut() async {
    try {
      // TODO: Signout call below needs to be well referenced
      await AuthRepository(UserDatasourceLocal()).signOut();
      await removeAllFavorites();
      if (RouteManger.navigatorKey.currentState != null)
        RouteManger.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          Pages.authentication,
          (route) => false,
        );
    } on GeneralException catch (exception) {
      flashError(exception.message ?? Strings.blanketErrorMessage);
    } catch (error) {
      flashError(Strings.blanketErrorMessage);
    }
  }
}

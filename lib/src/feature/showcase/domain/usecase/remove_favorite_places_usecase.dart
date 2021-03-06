import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/place.dart';
import '../repository/repository.dart';

///[RemoveFavoritePlacesUsecase] removes list of places
///stored in the local database
///or object of [GeneralException] if something is wrong
class RemoveFavoritePlacesUsecase
    implements UsecaseBase<Either<Exception, void>> {
  RemoveFavoritePlacesUsecase(this.repository);

  final PlacesRepositoryBase repository;

  @override
  Future<Either<Exception, void>> call(
      {List<PlaceBase> places = const <PlaceBase>[],
      bool removeAll = false}) async {
    try {
      //Calling repository method [removeFavoritePlaces] to remove favorite places of local storage
      await repository.removeFavoritePlaces(places, removeAll: removeAll);
      return Right(null);
    } on Exception catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(GeneralException(
        source: 'RemoveFavoritePlacesUsecase',
        message: '$error',
      ));
    }
  }
}

import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/place.dart';
import '../repository/repository.dart';

///[SetPlacesUsecase] takes list of places
///to store in the local database
///or object of [GeneralException] if something is wrong
class SetPlacesUsecase implements UsecaseBase<Either<Exception, void>> {
  SetPlacesUsecase(this.repository);

  final PlacesRepositoryBase repository;

  @override
  Future<Either<Exception, void>> call(
      {List<PlaceBase> places = const <PlaceBase>[]}) async {
    if (places.isEmpty)
      return Left(GeneralException(
        source: 'SetPlacesUsecase',
        message: 'places cannot be empty',
      ));

    try {
      //Calling repository method [setFavoritePlaces] to set favorite place into local storage
      await repository.setFavoritePlaces(places);
      return Right(null);
    } on Exception catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(GeneralException(
        source: 'SetPlacesUsecase',
        message: '$error',
      ));
    }
  }
}

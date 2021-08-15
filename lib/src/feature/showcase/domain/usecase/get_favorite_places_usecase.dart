import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../entity/place.dart';
import '../repository/repository.dart';

class GetFavoritePlacesUsecase {
  GetFavoritePlacesUsecase(this.repository);

  final PlacesRepositoryBase repository;

  Future<Either<Exception, List<PlaceBase>>> call() async {
    try {
      final List<PlaceBase> places = await repository.getFavoritePlaces();
      return Right(places);
    } on Exception catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(GeneralException(
        source: 'GetFavoritePlacesUsecase',
        message: '$error',
      ));
    }
  }
}

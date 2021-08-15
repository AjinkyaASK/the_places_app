import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../entity/place.dart';
import '../repository/repository.dart';

class SetPlacesUsecase {
  SetPlacesUsecase(this.repository);

  final PlacesRepositoryBase repository;

  Future<Either<Exception, void>> call(List<PlaceBase> places) async {
    try {
      await repository.setPlaces(places);
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

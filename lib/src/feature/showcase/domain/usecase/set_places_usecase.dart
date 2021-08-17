import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/place.dart';
import '../repository/repository.dart';

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

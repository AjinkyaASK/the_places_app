import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/place.dart';
import '../repository/repository.dart';

///[GetPlacesUsecase] returns list of places from API
///or object of [GeneralException] if something is wrong
class GetPlacesUsecase
    implements UsecaseBase<Either<Exception, List<PlaceBase>>> {
  GetPlacesUsecase(this.repository);

  final PlacesRepositoryBase repository;

  @override
  Future<Either<Exception, List<PlaceBase>>> call() async {
    try {
      //Calling repository method [getPlaces] to get list of places from API
      final List<PlaceBase> places = await repository.getPlaces();
      return Right(places);
    } on Exception catch (exception) {
      return Left(exception);
    } catch (error) {
      return Left(GeneralException(
        source: 'GetPlacesUsecase',
        message: '$error',
      ));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../entity/user.dart';
import '../repository/auth_repository.dart';

class SignInAsGuestUseCase
    implements UsecaseBase<Either<Exception, PlacesAppUserBase>> {
  SignInAsGuestUseCase(this.repository);

  final AuthRepositoryBase repository;

  @override
  Future<Either<Exception, PlacesAppUserBase>> call() async {
    try {
      final user = await repository.signInAsGuest();
      return Right(user);
    } catch (error) {
      return Left(GeneralException(
        source: 'source',
        message: 'Error signing in as a guest',
      ));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../../core/local_database_keys.dart';
import '../../data/datasource/local/user_datasource_local.dart';

class SignInAsGuestUseCase implements UsecaseBase<Either<Exception, void>> {
  SignInAsGuestUseCase(this.datasourceLocal);

  final UserDatasourceLocal datasourceLocal;

  @override
  Future<Either<Exception, void>> call() async {
    try {
      await datasourceLocal.set(
        key: UserLocalDatabaseKeys.guestSignedIn,
        value: true,
      );
      return Right(null);
    } catch (error) {
      return Left(GeneralException(
        source: 'source',
        message: 'Error signing in as a guest',
      ));
    }
  }
}

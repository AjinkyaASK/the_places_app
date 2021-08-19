import 'package:dartz/dartz.dart';

import '../../../../core/exception/exception.dart';
import '../../../../core/exception/general_exception.dart';
import '../../../../core/usecase/usecase_base.dart';
import '../../core/local_database_keys.dart';
import '../../data/datasource/local/user_datasource_local.dart';
import '../../data/model/user.dart';

class SignInAsGuestUseCase
    implements UsecaseBase<Either<Exception, PlacesAppUser>> {
  SignInAsGuestUseCase(this.datasourceLocal);

  final UserDatasourceLocal datasourceLocal;

  @override
  Future<Either<Exception, PlacesAppUser>> call() async {
    try {
      await datasourceLocal.set(
        key: UserLocalDatabaseKeys.guestSignedIn,
        value: true,
      );
      final user = PlacesAppUser(
        isGuest: true,
        name: 'Guest',
        pictureUrl: '',
      );
      return Right(user);
    } catch (error) {
      return Left(GeneralException(
        source: 'source',
        message: 'Error signing in as a guest',
      ));
    }
  }
}

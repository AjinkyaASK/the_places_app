import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/feature/auth/data/datasource/local/user_datasource_local.dart';
import 'src/feature/auth/data/model/user.dart';
import 'src/feature/auth/data/repository/auth_repository.dart';
import 'src/feature/showcase/data/datasource/local/places_datasource_local.dart';
import 'src/feature/showcase/data/model/place.dart';
import 'src/util/navigation/pages.dart';
import 'src/util/navigation/router.dart';
import 'src/value/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Intializing Hive and registering the adapters
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  /// Initializing local databases
  await UserDatasourceLocal.init();
  await PlacesDatasourceLocal.init();

  /// Checking if user is logged in and taking details when there is one
  final PlacesAppUser? user = await AuthRepository.init(UserDatasourceLocal());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    /// For the basic intended look and color scheme
    theme: Themes.appTheme,

    /// Never visited directly, decided by the [RouteManger.generateRoute]
    /// based on state of user object
    initialRoute: Pages.home,

    /// The navigator key used for all navigation calls throughout the code
    navigatorKey: RouteManger.navigatorKey,

    /// Passing user object to [RouteManger.generateRoute]
    /// for it  to determine initial route
    onGenerateRoute: (settings) => RouteManger.generateRoute(
      settings: settings,
      user: user,
    ),
  ));
}

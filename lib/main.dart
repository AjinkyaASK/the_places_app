import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/feature/auth/data/repository/auth_repository.dart';

import 'src/feature/auth/data/datasource/local/user_datasource_local.dart';
import 'src/feature/auth/data/model/user.dart';
import 'src/feature/showcase/data/datasource/local/places_datasource_local.dart';
import 'src/feature/showcase/data/model/place.dart';
import 'src/util/navigation/pages.dart';
import 'src/util/navigation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  await UserDatasourceLocal.init();
  await PlacesDatasourceLocal.init();

  final PlacesAppUser? user = await AuthRepository.init(UserDatasourceLocal());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Colors.green,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        // brightness: Brightness.light,
        // backwardsCompatibility: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.transparent,
        //   statusBarBrightness: Brightness.light,
        // ),
      ),
    ),
    initialRoute: Pages.home,
    navigatorKey: RouteManger.navigatorKey,
    onGenerateRoute: (settings) => RouteManger.generateRoute(
      settings: settings,
      user: user,
    ),
  ));
}

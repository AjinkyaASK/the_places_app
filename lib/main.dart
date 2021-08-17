import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/feature/showcase/data/datasource/local/places_datasource_local.dart';
import 'src/feature/showcase/data/model/place.dart';
import 'src/feature/showcase/presentation/view/showcase_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  await PlacesDatasourceLocal.init();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green,
      primaryColor: Colors.green,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    ),
    home: ShowcaseView(),
  ));
}

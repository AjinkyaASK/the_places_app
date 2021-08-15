import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:the_places_app/src/feature/showcase/data/model/place.dart';

import 'src/feature/showcase/data/datasource/local/places_datasource_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  await PlacesDatasourceLocal.init();
}

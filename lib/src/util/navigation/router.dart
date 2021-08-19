import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../feature/auth/data/model/user.dart';
import '../../feature/auth/presentation/view/auth_view.dart';
import '../../feature/showcase/data/model/place.dart';
import '../../feature/showcase/presentation/view/detail_view.dart';
import '../../feature/showcase/presentation/view/showcase_view.dart';
import '../../widget/error_view.dart';
import 'pages.dart';

class RouteManger {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route<dynamic> generateRoute({
    required RouteSettings settings,
    required PlacesAppUser? user,
  }) {
    final Object? args = settings.arguments;

    switch (settings.name) {
      case Pages.home:
        if (user != null)
          return MaterialPageRoute(builder: (_) => ShowcaseView(user: user));
        else
          return MaterialPageRoute(builder: (_) => AuthenticationView());

      case Pages.authentication:
        return MaterialPageRoute(builder: (_) => AuthenticationView());

      case Pages.placesShowcase:
        return MaterialPageRoute(
            builder: (_) => ShowcaseView(
                  user: args as PlacesAppUser,
                ));

      case Pages.placeDetails:
        if (args is Map<String, dynamic> &&
            args.containsKey('place') &&
            args['place'] is Place &&
            args.containsKey('onFavorite') &&
            args['onFavorite'] is void Function() &&
            args.containsKey('onFavoriteRemoved') &&
            args['onFavoriteRemoved'] is void Function())
          return MaterialPageRoute(
            builder: (_) => DetailView(
              place: args['place'],
              onFavorite: args['onFavorite'],
              onFavoriteRemoved: args['onFavoriteRemoved'],
            ),
          );
        return _errorRoute;

      default:
        return _errorRoute;
    }
  }

  static MaterialPageRoute get _errorRoute => MaterialPageRoute(
      builder: (_) => ErrorView(
            title: 'Navigation Error',
            message: '404',
          ));
}

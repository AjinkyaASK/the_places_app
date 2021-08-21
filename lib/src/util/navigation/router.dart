import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/exception/general_exception.dart';
import '../../feature/auth/data/model/user.dart';
import '../../feature/auth/presentation/view/auth_view.dart';
import '../../feature/showcase/presentation/view/detail_view.dart';
import '../../feature/showcase/presentation/view/fullscreen_image_view.dart';
import '../../feature/showcase/presentation/view/showcase_view.dart';
import '../../widget/error_view.dart';
import 'pages.dart';

///[RouteManger] is the helper class used by the [MaterialApp] widget
///for various routing oprations and practices
class RouteManger {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  ///[navigatorKey] is the global key used for by router for navigation
  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  ///[generateRoute] receives the navigation calls and processes them
  static Route<dynamic> generateRoute({
    required RouteSettings settings,
    required PlacesAppUser? user,
  }) {
    switch (settings.name) {
      case Pages.home:

        /// Checking if the object user is not null, before redirecting to home
        if (user != null)
          return MaterialPageRoute(
            builder: (_) => ShowcaseView(
              params: ShowcaseViewParams(
                user: user,
              ),
            ),
          );

        /// When it's null, redirecting to authentication screen instead
        else
          return MaterialPageRoute(builder: (_) => AuthenticationView());

      case Pages.authentication:
        return MaterialPageRoute(builder: (_) => AuthenticationView());

      case Pages.placesShowcase:
        if (!(settings.arguments is ShowcaseViewParams))
          throw GeneralException(
            source: 'Router',
            message:
                'When navigating to Pages.placesShowcase, expected object of type ShowcaseViewParams, received something else.',
          );
        return MaterialPageRoute(
          builder: (_) => ShowcaseView(
            params: settings.arguments as ShowcaseViewParams,
          ),
        );

      case Pages.placeDetails:
        if (!(settings.arguments is DetailViewParams))
          throw GeneralException(
            source: 'Router',
            message:
                'When navigating to Pages.placeDetails, expected object of type DetailViewParams, received something else.',
          );
        return MaterialPageRoute(
          builder: (_) => DetailView(
            params: settings.arguments as DetailViewParams,
          ),
        );

      case Pages.fullScreenImageView:
        if (!(settings.arguments is FullscreenImageViewParams))
          throw GeneralException(
            source: 'Router',
            message:
                'When navigating to Pages.fullScreenImageView, expected object of type FullscreenImageViewParams, received something else.',
          );
        return MaterialPageRoute(
          builder: (_) => FullscreenImageView(
            params: settings.arguments as FullscreenImageViewParams,
          ),
        );

      default:

        /// Routing to the error route considering that
        /// the app does not support requested route
        log('App does not support requested route');
        return _errorRoute;
    }
  }

  ///[_errorRoute] is a private page route object that navigates
  ///to the [ErrorView] with some messages
  static MaterialPageRoute get _errorRoute => MaterialPageRoute(
        builder: (_) => ErrorView(
          title: 'Navigation Error',
          message: '404',
        ),
      );
}

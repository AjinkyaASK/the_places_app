import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_places_app/src/feature/auth/presentation/view/auth_view.dart';
import 'package:the_places_app/src/feature/showcase/presentation/view/detail_view.dart';
import 'package:the_places_app/src/feature/showcase/presentation/view/showcase_view.dart';
import 'package:the_places_app/src/util/navigation/page_action.dart';

import 'page_config.dart';
import 'values.dart';

class PlacesRouterDelegate extends RouterDelegate<PageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfig> {
  PlacesRouterDelegate() : _navigatorKey = GlobalKey();

  final List<Page> _pages = [];

  final GlobalKey<NavigatorState> _navigatorKey;

  List<MaterialPage> get pages => List.unmodifiable(_pages);

  int get pagesCount => _pages.length;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [],
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    _pages.remove(page);
  }

  void pop() {
    if (canPop()) {
      _removePage(pages.last);
    }
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(pages.last);
      return Future.value(true);
    }
    return Future.value(false);
  }

  bool canPop() {
    return _pages.length > 1;
  }

  MaterialPage _createPage(Widget child, PageConfig pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfig pageConfig) {
    final bool shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfig).page != pageConfig.page;
    if (shouldAddPage) {
      switch (pageConfig.page) {
        case Pages.Authentication:
          _addPageData(child, pageConfig);
          break;
      }
    }
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfig pageConfig) {
    final bool shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfig).page != pageConfig.page;

    if (shouldAddPage) {
      switch (pageConfig.page) {
        case Pages.Authentication:
          _addPageData(AuthenticationView(), DefaultPageConfigs.authentication);
          break;
        case Pages.PlacesShowcase:
          _addPageData(ShowcaseView(), DefaultPageConfigs.placesShowcase);
          break;
        case Pages.PlaceDetailView:
          _addPageData(
            DetailView(
              place: place,
              onFavorite: onFavorite,
              onFavoriteRemoved: onFavoriteRemoved,
            ),
            DefaultPageConfigs.placeDetailView,
          );
          break;
        default:
          break;
      }
    }
  }

  void replace(PageConfig newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfig newRoute) {
    setNewRoutePath(newRoute);
  }

  void push(PageConfig newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfig newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfig> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  void _setPageAction(PageAction action) {
    switch (action.page.page) {
      case Pages.Authentication:
        DefaultPageConfigs.authentication.currentPageAction = action;
        break;
      case Pages.PlacesShowcase:
        DefaultPageConfigs.placeDetailView.currentPageAction = action;
        break;
      case Pages.PlaceDetailView:
        DefaultPageConfigs.placeDetailView.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(PageConfig configuration) {
    final bool shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfig).page != configuration.page;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  @override
  PageConfig get currentConfiguration => _pages.last.arguments as PageConfig;
}

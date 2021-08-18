import 'pages.dart';
import 'values.dart';

class PageConfig {
  PageConfig({
    required this.key,
    required this.path,
    required this.page,
  });

  final String key;
  final String path;
  final Pages page;
}

class DefaultPageConfigs {
  static final PageConfig authentication = PageConfig(
    key: Pages.Authentication.toString(),
    path: PageUtil.getPagePath(Pages.Authentication),
    page: Pages.Authentication,
  );
  static final PageConfig placesShowcase = PageConfig(
    key: Pages.PlacesShowcase.toString(),
    path: PageUtil.getPagePath(Pages.PlacesShowcase),
    page: Pages.PlacesShowcase,
  );
  static final PageConfig placeDetailView = PageConfig(
    key: Pages.PlaceDetailView.toString(),
    path: PageUtil.getPagePath(Pages.PlaceDetailView),
    page: Pages.PlaceDetailView,
  );
}

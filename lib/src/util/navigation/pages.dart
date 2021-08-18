import '../../core/exception/general_exception.dart';
import 'values.dart';

class PageUtil {
  static const Map<Pages, String> _pagePath = <Pages, String>{
    Pages.Authentication: '/auth',
    Pages.PlacesShowcase: '/places',
    Pages.PlaceDetailView: '/place-details'
  };

  static String getPagePath(Pages page) {
    if (_pagePath.containsKey(page))
      return _pagePath[page]!;
    else
      throw GeneralException(
        source: 'getPagePath',
        message: 'Page not found',
      );
  }
}

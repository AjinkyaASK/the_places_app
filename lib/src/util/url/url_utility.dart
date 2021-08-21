import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';

/// [UrlUtility] is a helper class that provides various methods
/// usefull for url related operations
class UrlUtility {
  /// Method [launchUrl] launches the url provided in external browser
  /// returns boolean future, as `true` when url launched successfully
  /// and `false` when not
  static Future<bool> launchUrl(String url) async {
    try {
      if (!await launch(url)) {
        log('Launching url failed: $url');
        return false;
      }
    } catch (e) {
      log('Launching url failed: $url with error $e');
      return false;
    }
    return true;
  }
}

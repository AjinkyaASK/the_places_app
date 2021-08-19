import 'package:url_launcher/url_launcher.dart';

class UrlUtility {
  static Future<bool> launchUrl(String url) async {
    try {
      if (!await launch(url)) {
        print('Launching url failed: $url');
        return false;
      }
    } catch (e) {
      print('Launching url failed: $url with error $e');
      return false;
    }
    return true;
  }
}

import 'package:url_launcher/url_launcher.dart';

class UrlUtility {
  static Future<bool> launchUrl(String url) async {
    if (!await canLaunch(url)) {
      print('Launching url failed: $url');
      return false;
    }
    if (!await launch(url)) {
      print('Launching url failed: $url');
      return false;
    }
    return true;
  }
}

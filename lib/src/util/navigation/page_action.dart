import 'package:flutter/material.dart';
import 'package:the_places_app/src/util/navigation/page_config.dart';

import 'values.dart';

class PageAction {
  final PageState state;
  final PageConfig page;
  final List<PageConfig> pages;
  final Widget widget;

  PageAction({
    required this.state,
    required this.page,
    required this.pages,
    required this.widget,
  });
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullscreenImageView extends StatelessWidget {
  const FullscreenImageView({
    Key? key,
    required this.url,
    this.cacheKey,
    this.heroTag,
  }) : super(key: key);

  final Object? heroTag;
  final String? cacheKey;
  final String url;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      cacheKey: cacheKey,
    );
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: InteractiveViewer(
        child: heroTag != null
            ? Container(
                constraints: BoxConstraints.expand(),
                alignment: Alignment.center,
                child: Hero(
                  tag: heroTag!,
                  child: image,
                ),
              )
            : image,
      ),
    );
  }
}

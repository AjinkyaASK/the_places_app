import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// This class [FullscreenImageViewParams] is used as a helper class
/// that enables ease of passing arguments to the [FullscreenImageView] widget
class FullscreenImageViewParams {
  FullscreenImageViewParams({
    required this.url,
    this.cacheKey,
    this.heroTag,
  });

  /// When [heroTag] is initialized as non-null value
  /// it is passed to a hero widget for continuous transition effect
  /// This is optional, default value is `null`
  final Object? heroTag;

  /// When [cacheKey] is initialized as non-null value
  /// it is passed to the network image widget for identifaction of the cached data
  /// This is optional, default value is `null`
  final String? cacheKey;

  /// [url] is the network path of the image
  final String url;
}

/// This widget [FullscreenImageView] is used for showing
/// network images in full screen view
class FullscreenImageView extends StatelessWidget {
  FullscreenImageView({
    Key? key,
    required final FullscreenImageViewParams params,
  })  : heroTag = params.heroTag,
        cacheKey = params.cacheKey,
        url = params.url,
        super(key: key);

  /// Same as specified in the params class above
  final Object? heroTag;

  /// Same as specified in the params class above
  final String? cacheKey;

  /// Same as specified in the params class above
  final String url;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      cacheKey: cacheKey,
    );
    return Scaffold(
      appBar: AppBar(
        /// Setting brightness to always dark as the background is always black
        brightness: Brightness.dark,

        /// Back button
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,

      /// For full screen effect
      extendBody: true,

      /// For full screen effect
      extendBodyBehindAppBar: true,

      /// For gesture interaction (zoom and pan) on the image
      body: InteractiveViewer(
        child: heroTag != null

            /// Only using hero widget as parent when tag is passed
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

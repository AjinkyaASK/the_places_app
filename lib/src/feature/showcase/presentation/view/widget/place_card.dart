import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../../../../util/url/url_utility.dart';

import '../../../data/model/place.dart';

class PlaceCard extends StatefulWidget {
  PlaceCard({
    Key? key,
    required this.place,
    this.opacity = 1.0,
    this.scale = 1.0,
    required this.onFavorite,
  }) : super(key: key);

  final Place place;
  final double opacity;
  final double scale;
  final void Function() onFavorite;

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  Color foregroundColor = Colors.black;
  Color backgroundColor = Colors.white;

  Future<void> loadColorDataFromImage(String url) async {
    Color color = Colors.black;

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      //TODO: Need to replace below url with actual one
      //TODO: This image is being downloaded two times, once here and another one is on the background image of card
      CachedNetworkImageProvider(
        url,
        cacheKey: widget.place.id.toString(),
      ),

      size: Size(720, 1280),

      region: Offset.zero & Size(450, 450),
    );

    final Color dominantBGColor =
        (paletteGenerator.dominantColor?.color) ?? backgroundColor;

    if (dominantBGColor.computeLuminance() < 0.5) {
      foregroundColor = Colors.white;
      backgroundColor = Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
    loadColorDataFromImage('https://picsum.photos/720/1280').then((color) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      //TODO: This is not smooth, need some animation here
      scale: widget.scale,
      alignment: Alignment.topCenter,
      child: Card(
        elevation: 8.0,
        color: Colors.white,
        shadowColor: Colors.grey.shade300.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedOpacity(
          opacity: widget.opacity,
          duration: Duration(milliseconds: 250),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            curve: Curves.ease,
            width: double.maxFinite,
            height: double.maxFinite,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: MediaQuery.of(context).size.height * 0.775,
              minWidth: MediaQuery.of(context).size.width * 0.5,
              minHeight: MediaQuery.of(context).size.height * 0.5,
            ),
            color: Colors.green,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                  opacity: 1.0,
                  child: Hero(
                    tag: widget.place.id,
                    child: CachedNetworkImage(
                      cacheKey: widget.place.id.toString(),
                      //TODO: Need to replace below url with actual one
                      imageUrl: 'https://picsum.photos/720/1280',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.place.googleMapsLink != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: MaterialButton(
                                onPressed: () => UrlUtility.launchUrl(
                                    widget.place.googleMapsLink!),
                                minWidth: 0.0,
                                elevation: 0.0,
                                padding: const EdgeInsets.all(12.0),
                                shape: CircleBorder(),
                                color: foregroundColor.withOpacity(0.75),
                                child: SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                  child: Center(
                                    child: Icon(
                                      Icons.location_pin,
                                      size: 20.0,
                                      color: backgroundColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Hero(
                            tag: 'fav${widget.place.id}',
                            transitionOnUserGestures: true,
                            child: MaterialButton(
                              onPressed: widget.onFavorite,
                              minWidth: 0.0,
                              elevation: 0.0,
                              padding: const EdgeInsets.all(12.0),
                              shape: CircleBorder(),
                              color: foregroundColor.withOpacity(0.75),
                              child: SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: Center(
                                  child: Icon(
                                    Icons.favorite,
                                    size: 20.0,
                                    color: widget.place.favorite
                                        ? Colors.pink.shade400
                                        : backgroundColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        child: Hero(
                          tag: widget.place.name,
                          transitionOnUserGestures: true,
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              widget.place.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    decoration: TextDecoration.none,
                                    color: foregroundColor,
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Hero(
                        tag:
                            '${widget.place.name}${widget.place.state}${widget.place.country}',
                        transitionOnUserGestures: true,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: foregroundColor.withOpacity(0.75),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(
                                    Icons.location_pin,
                                    size: 14.0,
                                    color: backgroundColor.withOpacity(0.8),
                                  ),
                                ),
                                Flexible(
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      '${widget.place.state}, ${widget.place.country}',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                            decoration: TextDecoration.none,
                                            color: backgroundColor,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

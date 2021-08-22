import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../../util/url/url_utility.dart';
import '../../../core/api.dart';
import '../../../data/model/place.dart';
import 'material_chip.dart';

const double _defaultShadowOpacity = 0.25;
const double _defaultBorderRadius = 8.0;
const double _defaultCardElevation = 8.0;
const Duration _defaultAnimationDuration = Duration(milliseconds: 250);
const Color _defaultCardColor = Colors.white;
const double _defaultMaxWidthFactor = 0.85;
const double _defaultMinWidthFactor = 0.5;
const double _defaultMinHeightFactor = 0.5;
const double _defaultMaxHeightFactor = 0.75;
const double _defaultCardPadding = 24.0;

///[PlaceCard] is the widget used inside swiping cards to showcase place details
class PlaceCard extends StatefulWidget {
  PlaceCard({
    Key? key,
    required this.place,
    this.opacity = 1.0,
    this.scale = 1.0,
    required this.onFavorite,
  }) : super(key: key);

  ///[place] is object of type [Place] that contains details of the place
  final Place place;

  ///[opacity] is applied to entire card, default value is 1.0
  final double opacity;

  ///[scale] is applied to entire card, default value is 1.0
  final double scale;

  ///[onFavorite] is called when user taps on the favorite button
  final void Function() onFavorite;

  @override
  _PlaceCardState createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  Color foregroundColor = Colors.black;
  Color backgroundColor = Colors.white;

  ///[_loadColorDataFromImage] loads the network image and
  ///devices colors based on it's dominant color
  ///uses [PaletteGenerator] library
  Future<void> _loadColorDataFromImage(String url) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      //TODO: Need to replace below url with actual one
      //TODO: This image is being downloaded two times, once here and another one is on the background image of card
      CachedNetworkImageProvider(
        url,
        cacheKey: widget.place.id.toString(),
      ),

      ///[size] indicates size of the image
      size: Size(720, 1280),

      ///[region] indicates position and size of the region to be considered
      region: Offset.zero & Size(450, 450),
    );

    final Color dominantBGColor =
        (paletteGenerator.dominantColor?.color) ?? backgroundColor;

    ///Calcalating the luminance of the dominant color
    ///and setting foreground and background color based on it
    if (dominantBGColor.computeLuminance() < 0.5) {
      foregroundColor = Colors.white;
      backgroundColor = Colors.black;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadColorDataFromImage(PlacesApi.radmomPictureUrl).then((color) {
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
        elevation: _defaultCardElevation,
        color: _defaultCardColor,
        shadowColor: Colors.grey.shade300.withOpacity(_defaultShadowOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_defaultBorderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedOpacity(
          opacity: widget.opacity,
          duration: _defaultAnimationDuration,
          child: AnimatedContainer(
            duration: _defaultAnimationDuration,
            curve: Curves.ease,
            width: double.maxFinite,
            height: double.maxFinite,
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height * _defaultMinHeightFactor,
              maxWidth:
                  MediaQuery.of(context).size.width * _defaultMaxWidthFactor,
              minWidth:
                  MediaQuery.of(context).size.width * _defaultMinWidthFactor,
              maxHeight:
                  MediaQuery.of(context).size.height * _defaultMaxHeightFactor,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Hero(
                  tag: widget.place.id,
                  child: CachedNetworkImage(
                    cacheKey: widget.place.id.toString(),
                    //TODO: Need to replace below url with actual one
                    imageUrl: PlacesApi.radmomPictureUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey.shade400),
                  ),
                ),
                // Details
                Padding(
                  padding: const EdgeInsets.all(_defaultCardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Maps and Favorite Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Google Maps Button
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
                          // Favorite Button
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
                      // Place Name
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
                      // State and Country
                      Hero(
                        tag:
                            '${widget.place.name}${widget.place.state}${widget.place.country}',
                        transitionOnUserGestures: true,
                        child: MaterialChip(
                          icon: Icons.location_pin,
                          label:
                              '${widget.place.state}, ${widget.place.country}',
                          backgroundColor: Colors.black.withOpacity(0.75),
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

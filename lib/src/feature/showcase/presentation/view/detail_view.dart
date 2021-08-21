import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../../util/url/url_utility.dart';
import '../../../../value/strings.dart';
import '../../core/api.dart';
import '../../data/model/place.dart';
import 'fullscreen_image_view.dart';

///[_defaultForegroundColor] is used when foregroundColor is not passed as argument
const _defaultForegroundColor = Colors.black;

///[_defaultBackgroundColor] is used when foregroundColor is not passed as argument
const _defaultBackgroundColor = Colors.white;

///[_defaultExpandedHeight] is used as the extended height of sliver header
const double _defaultExpandedHeight = 350.0;

///[DetailViewParams] is the parameter class used when passing argument to
///the [DetailView] widget
class DetailViewParams {
  DetailViewParams({
    required this.place,
    required this.onFavorite,
    required this.onFavoriteRemoved,
    this.foregroundColor = _defaultForegroundColor,
    this.backgroundColor = _defaultBackgroundColor,
  });

  ///[place] is the object of type [Place] that contains
  ///details of the place to be shown in details view
  final Place place;

  ///[foregroundColor] is set as color of text, icons and buttons
  final Color foregroundColor;

  ///[backgroundColor] is set as background color of various elements
  final Color backgroundColor;

  ///[onFavorite] is executed when favorite button is pressed
  final void Function() onFavorite;

  ///[onFavoriteRemoved] is executed when remove favorite button is pressed
  final void Function() onFavoriteRemoved;
}

///[DetailView] is the widget that shows details for any place
class DetailView extends StatelessWidget {
  DetailView({
    Key? key,
    required final DetailViewParams params,
  })  : place = params.place,
        foregroundColor = params.foregroundColor,
        backgroundColor = params.backgroundColor,
        onFavorite = params.onFavorite,
        onFavoriteRemoved = params.onFavoriteRemoved,
        super(key: key);

  final Place place;
  final Color foregroundColor;
  final Color backgroundColor;
  final void Function() onFavorite;
  final void Function() onFavoriteRemoved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: HeaderDelegate(
                collapsedHeight: kToolbarHeight,
                expandedHeight: _defaultExpandedHeight,
                title: place.name,
                foregroundColor: foregroundColor,
                backgroundColor: backgroundColor,
                backgroundImageUrl: PlacesApi.dummyPictureUrl,
                backgroundImageCacheKey: place.id.toString(),
                backgroundImageHeroTag: place.id,
                place: place,
                onFavorite: onFavorite,
                onFavoriteRemoved: onFavoriteRemoved,
                onHeaderTapped: () {
                  // Navigating user to full screen image view
                  if (RouteManger.navigatorKey.currentState != null)
                    RouteManger.navigatorKey.currentState!.pushNamed(
                      Pages.fullScreenImageView,
                      arguments: FullscreenImageViewParams(
                        url: PlacesApi.dummyPictureUrl,
                        heroTag: place.id,
                        cacheKey: place.id.toString(),
                      ),
                    );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place Title
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Hero(
                        tag: place.name,
                        transitionOnUserGestures: true,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            place.name,
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
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
                      tag: '${place.name}${place.state}${place.country}',
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
                                  size: 16.0,
                                  color: backgroundColor.withOpacity(0.8),
                                ),
                              ),
                              Flexible(
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    '${place.state}, ${place.country}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                          decoration: TextDecoration.none,
                                          color: backgroundColor,
                                          fontSize: 14.0,
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
                    // Actions (Wiki + Maps)
                    Row(
                      children: [
                        // including Maps Button into widget tree only when there is a link
                        if (place.googleMapsLink != null)
                          Expanded(
                            child: MaterialButton(
                              onPressed: () =>
                                  UrlUtility.launchUrl(place.wikipediaLink!),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: foregroundColor.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.info,
                                        size: 20.0,
                                        color:
                                            foregroundColor.withOpacity(0.75),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        Strings.wikiButton,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(color: foregroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        // A spacer when there both buttons are available
                        if (place.wikipediaLink != null &&
                            place.googleMapsLink != null)
                          const SizedBox(
                            width: 16.0,
                          ),
                        // including Wiki Button into widget tree only when there is a link
                        if (place.wikipediaLink != null)
                          Expanded(
                            child: MaterialButton(
                              onPressed: () =>
                                  UrlUtility.launchUrl(place.googleMapsLink!),
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: foregroundColor.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.location_pin,
                                        size: 20.0,
                                        color:
                                            foregroundColor.withOpacity(0.75),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        Strings.mapsButton,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(color: foregroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Other Details
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(3),
                        },
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text('State'),
                              ),
                              Text(place.state),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text('Country'),
                              Text(place.country),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///[HeaderDelegate] used as [SliverPersistentHeaderDelegate] for
///the sliver persistent header used
class HeaderDelegate extends SliverPersistentHeaderDelegate {
  HeaderDelegate({
    required this.collapsedHeight,
    required this.expandedHeight,
    required this.title,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.backgroundImageUrl,
    this.backgroundImageCacheKey,
    this.backgroundImageHeroTag,
    required this.place,
    this.onHeaderTapped,
    required this.onFavorite,
    required this.onFavoriteRemoved,
  });

  ///[foregroundColor] sets the color of text and icons
  final Color foregroundColor;

  ///[backgroundColor] sets the background color of header
  final Color backgroundColor;

  ///[title] is the text title of the header
  final String title;

  ///Network path of the image shown in the background
  final String? backgroundImageUrl;

  ///[collapsedHeight] is the height of the header when it is fully collapsed
  final double collapsedHeight;

  ///[expandedHeight] is the height of the header when it is fully expanded
  final double expandedHeight;

  ///[backgroundImageCacheKey] is used by network image widget to identify the cache uniquely
  ///this is optional
  final String? backgroundImageCacheKey;

  ///[backgroundImageHeroTag] used by hero widget for continuos transition effect
  ///this is optional
  final Object? backgroundImageHeroTag;

  ///[place] object of class [Place]
  final Place place;

  ///[onHeaderTapped] called when the header is tapped
  final void Function()? onHeaderTapped;

  ///[onFavorite] called when favorite happens
  final void Function() onFavorite;

  ///[onFavoriteRemoved] called when remove favorite happens
  final void Function() onFavoriteRemoved;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    /// Always passing true (Not the best practice but okay for current application)
    return true;
  }

  ///[getProcessedShrinkOffset] mehod gives offset value between 0 and 1
  double getProcessedShrinkOffset(double shrinkOffset) {
    return (1 - shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return InkWell(
      onTap: onHeaderTapped,
      child: Container(
        height: expandedHeight,
        width: double.maxFinite,
        color: backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (backgroundImageUrl != null)
              if (backgroundImageHeroTag != null)
                Opacity(
                  opacity: getProcessedShrinkOffset(shrinkOffset),
                  child: Hero(
                    tag: backgroundImageHeroTag!,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      cacheKey: backgroundImageCacheKey,
                      imageUrl: backgroundImageUrl!,
                    ),
                  ),
                )
              else
                Opacity(
                  opacity: getProcessedShrinkOffset(shrinkOffset),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    cacheKey: backgroundImageCacheKey,
                    imageUrl: backgroundImageUrl!,
                  ),
                ),

            // Appbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: collapsedHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: foregroundColor,
                      ),
                    ),
                    StatefulBuilder(builder: (context, refresh) {
                      return Hero(
                        tag: 'fav${place.id}',
                        transitionOnUserGestures: true,
                        child: MaterialButton(
                          onPressed: () {
                            if (place.favorite) {
                              onFavoriteRemoved();
                            } else {
                              onFavorite();
                            }
                            place.favorite = !place.favorite;
                            refresh(() {});
                          },
                          minWidth: 0.0,
                          elevation: 0.0,
                          padding: const EdgeInsets.all(12.0),
                          shape: CircleBorder(),
                          // color: foregroundColor.withOpacity(0.75),
                          child: SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: Center(
                              child: Icon(
                                place.favorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                size: 24.0,
                                color: place.favorite
                                    ? Colors.pink.shade400
                                    : foregroundColor.withOpacity(0.75),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

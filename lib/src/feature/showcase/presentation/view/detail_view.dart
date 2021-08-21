import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../../util/url/url_utility.dart';
import '../../core/api.dart';
import '../../data/model/place.dart';

class DetailView extends StatelessWidget {
  const DetailView({
    Key? key,
    required this.place,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    required this.onFavorite,
    required this.onFavoriteRemoved,
  }) : super(key: key);

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
                expandedHeight: 350.0,
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
                  if (RouteManger.navigatorKey.currentState != null)
                    RouteManger.navigatorKey.currentState!.pushNamed(
                      Pages.fullScreenImageView,
                      arguments: {
                        'url': PlacesApi.dummyPictureUrl,
                        'heroTag': place.id,
                        'cacheKey': place.id.toString(),
                      },
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
                    // Title
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
                    // State
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
                    // Actions
                    Row(
                      children: [
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
                                        'Wiki',
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
                        if (place.wikipediaLink != null &&
                            place.googleMapsLink != null)
                          const SizedBox(
                            width: 16.0,
                          ),
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
                                        'Maps',
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
                    // Details
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

  final Color foregroundColor;
  final Color backgroundColor;
  final String title;
  final String? backgroundImageUrl;
  final double collapsedHeight;
  final double expandedHeight;
  final String? backgroundImageCacheKey;
  final Object? backgroundImageHeroTag;
  final Place place;
  final void Function()? onHeaderTapped;
  final void Function() onFavorite;
  final void Function() onFavoriteRemoved;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../../util/network/network_helper.dart';
import '../../../../value/labels.dart';
import '../../../auth/data/model/user.dart';
import '../../core/api.dart';
import '../../data/datasource/local/places_datasource_local.dart';
import '../../data/datasource/remote/places_datasource_remote.dart';
import '../../data/model/place.dart';
import '../../data/repository/repository.dart';
import '../../domain/usecase/get_favorite_places_usecase.dart';
import '../../domain/usecase/get_places_usecase.dart';
import '../../domain/usecase/remove_favorite_places_usecase.dart';
import '../../domain/usecase/set_places_usecase.dart';
import '../logic/showcase_controller.dart';
import 'widget/no_internet.dart';
import 'widget/place_card.dart';
import 'widget/swiping_card.dart';

final List<Widget> _placeCards = <Widget>[];

class ShowcaseView extends StatelessWidget {
  ShowcaseView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final PlacesAppUser user;

  static final PlacesRepository _repository = PlacesRepository(
    datasourceLocal: PlacesDatasourceLocal(),
    datasourceRemote: PlacesDatasourceRemote(),
  );
  final ShowcaseController _controller = ShowcaseController(
    getPlacesUsecase: GetPlacesUsecase(_repository),
    getFavoritePlacesUsecase: GetFavoritePlacesUsecase(_repository),
    setPlacesUsecase: SetPlacesUsecase(_repository),
    removeFavoritePlacesUsecase: RemoveFavoritePlacesUsecase(_repository),
  );

  List<Widget> _buildAndGetCards({
    required BuildContext context,
    required List<Place> places,
  }) {
    final List<Widget> cards = <Widget>[];

    double marginTop = 54;
    const double marginToReduce = 18;

    double opacity = 1.0;
    double scale = 1.0;

    int index = 0;

    for (final place in places.reversed) {
      switch (index) {
        case 0:
          scale = 1.0;
          opacity = 1.0;
          break;

        case 1:
          scale = 0.875;
          opacity = 0.675;
          break;

        case 2:
          scale = 0.75;
          opacity = 0.35;
          break;

        default:
          scale = 0.0;
          opacity = 0.0;
          break;
      }

      cards.add(
        Positioned(
          top: marginTop - marginToReduce,
          child: SwipingCard(
            onTap: () {
              if (RouteManger.navigatorKey.currentState != null)
                RouteManger.navigatorKey.currentState!
                    .pushNamed(Pages.placeDetails, arguments: {
                  'place': place,
                  'onFavorite': () {
                    _controller.onFavorite(
                      place: place,
                      onComplete: () {
                        _placeCards.clear();
                        _placeCards.addAll(_buildAndGetCards(
                          context: context,
                          places: _controller.places,
                        ));
                      },
                    );
                  },
                  'onFavoriteRemoved': () {
                    _controller.onFavoriteRemoved(
                      place: place,
                      onComplete: () {
                        _placeCards.clear();
                        _placeCards.addAll(_buildAndGetCards(
                          context: context,
                          places: _controller.places,
                        ));
                      },
                    );
                  },
                });
            },
            onSwipeRight: () {
              _controller.onFavorite(
                place: place,
                onComplete: () {
                  _placeCards.clear();
                  _placeCards.addAll(_buildAndGetCards(
                    context: context,
                    places: _controller.places,
                  ));
                },
              );
            },
            onSwipeLeft: () {
              _controller.onRemoved(
                place: place,
                onComplete: () {
                  _placeCards.clear();
                  _placeCards.addAll(_buildAndGetCards(
                    context: context,
                    places: _controller.places,
                  ));
                },
              );
            },
            child: PlaceCard(
              place: place,
              opacity: opacity,
              scale: scale,
              onFavorite: () {
                _controller.onFavorite(
                  place: place,
                  onComplete: () {
                    _placeCards.clear();
                    _placeCards.addAll(_buildAndGetCards(
                      context: context,
                      places: _controller.places,
                    ));
                  },
                );
              },
            ),
          ),
        ),
      );

      index++;
      marginTop -= marginToReduce;
    }

    return cards;
  }

  Widget get _loaderWidget => const Center(
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: CircularProgressIndicator(),
        ),
      );

  void _showProfileDialog({
    required BuildContext context,
    required ShowcaseController controller,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    if (RouteManger.navigatorKey.currentState != null)
                      RouteManger.navigatorKey.currentState!.pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            content: Container(
              width: 150.0,
              // height: 150.0,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      bottom: 24.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: user.pictureUrl.isEmpty
                                ? null
                                : CachedNetworkImageProvider(user.pictureUrl),
                            child: user.pictureUrl.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 64.0,
                                    color: Colors.white30,
                                  )
                                : null,
                            backgroundColor: Colors.grey.shade800,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (user.email != null)
                          Text(
                            user.email!,
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: controller.onSignOut,
                child: Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowcaseController>(
      create: (_) => _controller
        ..init(() {
          _placeCards.clear();
          _placeCards.addAll(_buildAndGetCards(
            context: context,
            places: _controller.places,
          ));
        }),
      child: Consumer<ShowcaseController>(
        builder: (__, controller, ____) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                Labels.appName,
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () => _showProfileDialog(
                    context: context,
                    controller: controller,
                  ),
                  radius: 32.0,
                  child: CircleAvatar(
                    backgroundImage: user.pictureUrl.isEmpty
                        ? null
                        : CachedNetworkImageProvider(user.pictureUrl),
                    child: user.pictureUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                          )
                        : null,
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
            endDrawer: Drawer(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    AppBar(
                      title: Row(
                        children: [
                          Text(
                            'Favorites',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      centerTitle: false,
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    Expanded(
                      child: controller.favoritePlaces.isEmpty
                          ? Center(
                              child: Text('No favorite places to show'),
                            )
                          : ListView.separated(
                              itemCount: controller.favoritePlaces.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (context, index) {
                                final Place place =
                                    controller.favoritePlaces[index];
                                return ListTile(
                                  onTap: () {
                                    if (RouteManger.navigatorKey.currentState !=
                                        null)
                                      RouteManger.navigatorKey.currentState!
                                          .pushNamed(Pages.placeDetails,
                                              arguments: {
                                            'place': place,
                                            'onFavorite': () {
                                              _controller.onFavorite(
                                                place: place,
                                                onComplete: () {
                                                  _placeCards.clear();
                                                  _placeCards
                                                      .addAll(_buildAndGetCards(
                                                    context: context,
                                                    places: _controller.places,
                                                  ));
                                                },
                                              );
                                            },
                                            'onFavoriteRemoved': () {
                                              _controller.onFavoriteRemoved(
                                                place: place,
                                                onComplete: () {
                                                  _placeCards.clear();
                                                  _placeCards
                                                      .addAll(_buildAndGetCards(
                                                    context: context,
                                                    places: _controller.places,
                                                  ));
                                                },
                                              );
                                            },
                                          });
                                  },
                                  leading: Hero(
                                    tag: place.id,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        //TODO: Need to replace below url with actual one
                                        PlacesApi.dummyPictureUrl,
                                        cacheKey: place.id.toString(),
                                        // fit: BoxFit.cover,
                                        // placeholder: (context, url) =>
                                        //     Container(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  title: Text(place.name),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 4.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: Colors.black.withOpacity(0.65),
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
                                              padding: const EdgeInsets.only(
                                                  right: 4.0),
                                              child: Icon(
                                                Icons.location_pin,
                                                size: 14.0,
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                            Flexible(
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: Text(
                                                  '${place.state}, ${place.country}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6!
                                                      .copyWith(
                                                        decoration:
                                                            TextDecoration.none,
                                                        color: Colors.white,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await controller.onFavoriteRemoved(
                                        place: place,
                                        onComplete: () {},
                                      );
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            body: controller.loading
                ? _loaderWidget
                : FutureBuilder<bool>(
                    future: NetworkHelper.isConnected,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError && snapshot.hasData) {
                        if (snapshot.data ?? false) {
                          if (_placeCards.isEmpty)
                            return Center(
                              child: Text('No places to show'),
                            );
                          return Stack(
                            alignment: Alignment.center,
                            children: _placeCards.reversed.toList(),
                          );
                        }
                        return NoInternetWidget(
                          onRetry: () async {
                            await controller.loadPlaces(() {
                              _placeCards.clear();
                              _placeCards.addAll(_buildAndGetCards(
                                context: context,
                                places: _controller.places,
                              ));
                            });
                          },
                        );
                      } else {
                        return _loaderWidget;
                      }
                    }),
          );
        },
      ),
    );
  }
}

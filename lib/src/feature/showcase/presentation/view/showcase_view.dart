import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_places_app/src/feature/showcase/domain/usecase/remove_favorite_places_usecase.dart';

import '../../../../value/labels.dart';
import '../../data/datasource/local/places_datasource_local.dart';
import '../../data/datasource/remote/places_datasource_remote.dart';
import '../../data/model/place.dart';
import '../../data/repository/repository.dart';
import '../../domain/usecase/get_favorite_places_usecase.dart';
import '../../domain/usecase/get_places_usecase.dart';
import '../../domain/usecase/set_places_usecase.dart';
import '../logic/showcase_controller.dart';
import 'detail_view.dart';
import 'widget/place_card.dart';
import 'widget/swiping_card.dart';

class ShowcaseView extends StatelessWidget {
  ShowcaseView({Key? key}) : super(key: key);

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

  final List<Widget> _cards = <Widget>[];

  List<Widget> _buildAndGetCards(BuildContext context) {
    final List<Widget> cards = <Widget>[];

    double marginTop = 54;
    const double marginToReduce = 18;

    double opacity = 1.0;
    double scale = 1.0;

    int index = 0;

    for (final place in _controller.places.reversed) {
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailView(
                  place: place,
                  onFavorite: () {
                    _controller.onFavorite(
                      place: place,
                      onComplete: () {
                        _cards.clear();
                        _cards.addAll(_buildAndGetCards(context));
                      },
                    );
                  },
                  onFavoriteRemoved: () {
                    _controller.onFavoriteRemoved(
                      place: place,
                      onComplete: () {
                        _cards.clear();
                        _cards.addAll(_buildAndGetCards(context));
                      },
                    );
                  },
                ),
              ));
            },
            onSwipeRight: () {
              _controller.onFavorite(
                place: place,
                onComplete: () {
                  _cards.clear();
                  _cards.addAll(_buildAndGetCards(context));
                },
              );
            },
            onSwipeLeft: () {
              _controller.onRemoved(
                place: place,
                onComplete: () {
                  _cards.clear();
                  _cards.addAll(_buildAndGetCards(context));
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
                    _cards.clear();
                    _cards.addAll(_buildAndGetCards(context));
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowcaseController>(
      create: (_) => _controller
        ..init(() {
          _cards.clear();
          _cards.addAll(_buildAndGetCards(context));
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
                child: CircleAvatar(
                  //TODO: Put users picture here and make below child Null when picture is available
                  // backgroundImage: AssetImage(
                  //   ImageArtifacts.profilePlaceholder,
                  // ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.grey.shade800,
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
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.pink.shade400,
                              size: 20.0,
                            ),
                          ),
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
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => DetailView(
                                        place: place,
                                        onFavorite: () {
                                          _controller.onFavorite(
                                            place: place,
                                            onComplete: () {
                                              _cards.clear();
                                              _cards.addAll(
                                                  _buildAndGetCards(context));
                                            },
                                          );
                                        },
                                        onFavoriteRemoved: () {
                                          _controller.onFavoriteRemoved(
                                            place: place,
                                            onComplete: () {
                                              _cards.clear();
                                              _cards.addAll(
                                                  _buildAndGetCards(context));
                                            },
                                          );
                                        },
                                      ),
                                    ));
                                  },
                                  leading: Hero(
                                    tag: place.id,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        //TODO: Need to replace below url with actual one
                                        'https://picsum.photos/720/1280',
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
                    Divider(
                      height: 1.0,
                      thickness: 1.0,
                    ),
                    TextButton(
                      onPressed: () {},
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
                ),
              ),
            ),
            body: controller.loading
                ? Center(
                    child: SizedBox(
                      width: 48.0,
                      height: 48.0,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Stack(
                    // fit: StackFit.expand,
                    alignment: Alignment.center,
                    // children: _cards,
                    children: _cards.reversed.toList(),
                  ),
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/navigation/pages.dart';
import '../../../../util/navigation/router.dart';
import '../../../../util/network/network_helper.dart';
import '../../../../value/strings.dart';
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
import 'detail_view.dart';
import 'widget/draggable_swiping_card.dart';
import 'widget/material_chip.dart';
import 'widget/no_internet.dart';
import 'widget/place_card.dart';
import 'widget/swiping_card.dart';

final List<Widget> _placeCards = <Widget>[];

/// This class [ShowcaseViewParams] serves as a helper class
/// to pass parameters to the view
class ShowcaseViewParams {
  ShowcaseViewParams({
    required this.user,
  });

  final PlacesAppUser user;
}

/// [ShowcaseView] is the actual widget of the showcase view
class ShowcaseView extends StatelessWidget {
  ShowcaseView({
    Key? key,
    required final ShowcaseViewParams params,
  })  : user = params.user,
        super(key: key);

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

  /// This method [_buildAndGetCards] builds place cards
  List<Widget> _buildAndGetCards({
    required BuildContext context,
    required List<Place> places,
  }) {
    final List<Widget> cards = <Widget>[];

    // This is the maximum margin cards will have vertically
    double marginTop = 108;

    // This is the difference dremented from top margin (to achieve to vertical stack effect)
    const double marginToDecrement = 36;

    // This is the opacity of card
    double opacity = 1.0;

    // This is the scale of card
    double scale = 1.0;

    // Index of current card
    int index = 0;

    // Calculating Scale and Opacity of card based on index
    for (final place in places.reversed) {
      final margin = marginTop - marginToDecrement;

      switch (index) {
        case 0:
          // Making first card at full scale and opacity
          scale = 1.0;
          opacity = 1.0;
          break;

        case 1:
          // Making second card at ~half scale and opacity
          scale = 0.875;
          opacity = 0.675;
          break;

        case 2:
          // Making third card at ~one forth scale and opacity
          scale = 0.75;
          opacity = 0.35;
          break;

        default:
          // Making rest of the cards invisible by making scale and opacity zero
          scale = 0.0;
          opacity = 0.0;
          break;
      }

      // Building and adding card to the list
      cards.add(
        Container(
          // top margin is set by the margin subtracted by the decrement value
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(
            top: margin > 0 ? margin : 0,
          ),
          child: DraggableSwipingCard(
            // Navigating to details screen on tap of the card
            onTap: () {
              if (RouteManger.navigatorKey.currentState != null)
                RouteManger.navigatorKey.currentState!.pushNamed(
                  Pages.placeDetails,
                  arguments: DetailViewParams(
                    place: place,
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
                    onFavoriteRemoved: () {
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
                  ),
                );
            },
            // Marking place as favorite and removing from the list
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
            // Removing place from the list
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
              // Marking place as favorite and removing from the list on click of heart icon
              onFavorite: () {
                _controller.onFavorite(
                  place: place,
                  // Upadating the cards list
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

      // Updating the index
      index++;

      // Subtracting the decrement margin from marginTop
      marginTop -= marginToDecrement;
    }

    return cards;
  }

  /// The [_loaderWidget] shown when the places data is being fetched
  Widget get _loaderWidget => const Center(
        child: SizedBox(
          width: 48.0,
          height: 48.0,
          child: CircularProgressIndicator(),
        ),
      );

  /// The method [_showProfileDialog] which shows profile dialog with user details and sign out button
  void _showProfileDialog({
    required BuildContext context,
    required ShowcaseController controller,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            /// Keeping all padding zero for end to end content space
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// Dialog close button
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
              /// Signout button
              TextButton(
                onPressed: controller.onSignOut,
                child: Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    Strings.signOutButton,
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
          /// Building the cards widget list on completion of data fetch
          _placeCards.clear();
          _placeCards.addAll(_buildAndGetCards(
            context: context,
            places: _controller.places,
          ));
        }),
      child: Consumer<ShowcaseController>(
        builder: (__, controller, ____) {
          // return Scaffold(
          //   body: Container(
          //     child: DraggableSwipingCard(
          //       onTap: () {},
          //       onSwipeLeft: () {},
          //       onSwipeRight: () {},
          //       child: Container(
          //         width: 250,
          //         height: 250,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // );
          return Scaffold(
            appBar: AppBar(
              title: Text(
                Strings.appName,
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
                            color: Colors.white30,
                          )
                        : null,
                    backgroundColor: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
            endDrawer: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.transparent,

                /// For the rounded corners at left side
              ),
              child: Drawer(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      bottomLeft: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      AppBar(
                        title: Row(
                          children: [
                            Text(
                              Strings.favoritesTitle,
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
                                child: Text(Strings.noFavoritesFound),

                                /// Message telling user that there are no favorite places stored
                              )
                            : ListView.separated(
                                itemCount: controller.favoritePlaces.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  final Place place =
                                      controller.favoritePlaces[index];
                                  return Dismissible(
                                    /// For swipe to dismiss the place card
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 32.0),
                                        child: Icon(Icons.delete_outline),
                                      ),
                                    ),
                                    key: Key(place.id.toString()),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        return true;
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        await controller.onFavoriteRemoved(
                                          place: place,
                                          onComplete: () {},
                                        );
                                      }
                                    },
                                    child: ListTile(
                                      /// This is to open the place in details view on tap
                                      onTap: () {
                                        if (RouteManger
                                                .navigatorKey.currentState !=
                                            null)
                                          RouteManger.navigatorKey.currentState!
                                              .pushNamed(
                                            Pages.placeDetails,
                                            arguments: DetailViewParams(
                                              place: place,
                                              // This is required to update the list when a place is added to favorites
                                              onFavorite: () {
                                                _controller.onFavorite(
                                                  place: place,
                                                  onComplete: () {
                                                    _placeCards.clear();
                                                    _placeCards.addAll(
                                                        _buildAndGetCards(
                                                      context: context,
                                                      places:
                                                          _controller.places,
                                                    ));
                                                  },
                                                );
                                              },
                                              // This is required to update the list when a place is removed from favorites
                                              onFavoriteRemoved: () {
                                                _controller.onFavoriteRemoved(
                                                  place: place,
                                                  onComplete: () {
                                                    _placeCards.clear();
                                                    _placeCards.addAll(
                                                        _buildAndGetCards(
                                                      context: context,
                                                      places:
                                                          _controller.places,
                                                    ));
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                      },
                                      leading: Hero(
                                        tag: place.id,
                                        child: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                            //TODO: Need to replace below url with actual one
                                            PlacesApi.radmomPictureUrl,
                                            cacheKey: place.id.toString(),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        place.name,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      subtitle: Align(
                                        alignment: Alignment.centerLeft,
                                        child: MaterialChip(
                                          icon: Icons.location_pin,
                                          label:
                                              '${place.state}, ${place.country}',
                                          backgroundColor:
                                              Colors.black.withOpacity(0.75),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: controller.loading
                ? _loaderWidget
                : FutureBuilder<bool>(
                    /// Future that tells if internet connectivity is available
                    future: NetworkHelper.isConnected,
                    builder: (context, snapshot) {
                      if (!snapshot.hasError && snapshot.hasData) {
                        if (snapshot.data ?? false) {
                          if (_placeCards.isEmpty)

                            /// When there are no places
                            return Center(
                              child: Text(Strings.noPlacesFound),
                            );

                          /// When there are some places to show
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 72.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: _placeCards.reversed.toList(),
                            ),
                          );
                        }

                        /// When there is no connectivity
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
                        /// When there is something wrong
                        return _loaderWidget;
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}

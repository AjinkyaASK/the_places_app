import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/artifacts/image_artifacts.dart';
import '../../../../value/labels.dart';
import '../../data/datasource/local/places_datasource_local.dart';
import '../../data/datasource/remote/places_datasource_remote.dart';
import '../../data/model/place.dart';
import '../../data/repository/repository.dart';
import '../../domain/usecase/get_favorite_places_usecase.dart';
import '../../domain/usecase/get_places_usecase.dart';
import '../../domain/usecase/set_places_usecase.dart';
import '../logic/showcase_controller.dart';
import 'widget/place_card.dart';
import 'widget/swiping_card.dart';

class ShowcaseView extends StatelessWidget {
  ShowcaseView({Key? key}) : super(key: key);

  static final PlacesDatasourceLocal _datasourceLocal = PlacesDatasourceLocal();
  static final PlacesDatasourceRemote _datasourceRemote =
      PlacesDatasourceRemote();
  static final PlacesRepository _repository = PlacesRepository(
    datasourceLocal: _datasourceLocal,
    datasourceRemote: _datasourceRemote,
  );
  static final GetPlacesUsecase _getPlacesUsecase =
      GetPlacesUsecase(_repository);
  static final GetFavoritePlacesUsecase _getFavoritePlacesUsecase =
      GetFavoritePlacesUsecase(_repository);
  static final SetPlacesUsecase _setPlacesUsecase =
      SetPlacesUsecase(_repository);

  final ShowcaseController _controller = ShowcaseController(
      getPlacesUsecase: _getPlacesUsecase,
      getFavoritePlacesUsecase: _getFavoritePlacesUsecase,
      setPlacesUsecase: _setPlacesUsecase);

  final List<Widget> _cards = <Widget>[];

  List<Widget> _buildAndGetCards({
    required BuildContext context,
  }) {
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
            onSwipeRight: () {
              _controller.onFavorite(
                place: place,
                onComplete: () => _buildAndGetCards(context: context),
              );
            },
            onSwipeLeft: () {
              _controller.onRemoved(
                place: place,
                onComplete: () => _buildAndGetCards(context: context),
              );
            },
            child: PlaceCard(
              place: place,
              opacity: opacity,
              scale: scale,
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
          _cards.addAll(_buildAndGetCards(context: context));
        }),
      child: Consumer<ShowcaseController>(
        builder: (__, controller, ____) {
          if (controller.loading)
            return Center(
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: CircularProgressIndicator(),
              ),
            );

          return Scaffold(
            appBar: AppBar(
              title: Text(
                Labels.appName,
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    ImageArtifacts.profilePlaceholder,
                  ),
                ),
              ),
            ),
            endDrawer: Drawer(
              child: Container(
                color: Colors.green,
              ),
            ),
            body: Stack(
              // fit: StackFit.expand,
              alignment: Alignment.center,
              // children: _cards,
              children: _cards.reversed.toList(),
            ),
            // body: ListView.builder(
            //   itemCount: controller.places.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(controller.places[index].name),
            //       subtitle: Text(
            //           '${controller.places[index].state}, ${controller.places[index].country}'),
            //     );
            //   },
            // ),
          );
        },
      ),
    );
  }
}

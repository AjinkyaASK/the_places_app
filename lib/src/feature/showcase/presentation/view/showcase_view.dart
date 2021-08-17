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

  void _loadCards({
    required BuildContext context,
  }) {
    _cards.clear();
    double margin = 54;
    final double marginToCut = 18;

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

      final card = _placeCard(
        context: context,
        place: place,
        opacity: opacity,
        scale: scale,
      );

      opacity = opacity > 0.33 ? opacity -= 0.33 : 0.0;

      _cards.add(
        Positioned(
          top: margin - marginToCut,
          // bottom: marginMax,
          child: Draggable(
            onDragEnd: (details) {
              // print(
              //     'Drag end ${details.offset.dx} / ${MediaQuery.of(context).size.width}');

              if (details.offset.dx.isNegative &&
                  details.offset.dx.abs() / MediaQuery.of(context).size.width >
                      0.60) {
                _controller.onRemoved(
                  place: place,
                  onComplete: () => _loadCards(context: context),
                );
              } else if (details.offset.dx / MediaQuery.of(context).size.width >
                  0.60) {
                _controller.onFavorite(
                  place: place,
                  onComplete: () => _loadCards(context: context),
                );
              }
            },
            childWhenDragging: Container(),
            feedback: card,
            child: card,
          ),
        ),
      );

      index++;
      margin -= marginToCut;
    }
  }

  Widget _placeCard({
    required BuildContext context,
    required Place place,
    double opacity = 1.0,
    double scale = 1.0,
  }) {
    return Transform.scale(
      scale: scale,
      alignment: Alignment.topCenter,
      child: Card(
        elevation: 8.0,
        shadowColor: Colors.grey.shade300.withOpacity(0.25),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.775,
            minWidth: MediaQuery.of(context).size.width * 0.5,
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(opacity),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: 0.25,
                child: Image.asset(
                  ImageArtifacts.profilePlaceholder,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        place.name,
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${place.state}, ${place.country}',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    Text(
                        'Opacity: ${opacity.toStringAsFixed(2)} | Scale: $scale'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowcaseController>(
      create: (_) => _controller..init(() => _loadCards(context: context)),
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

import 'package:flutter/material.dart';

import '../../../../../core/artifacts/image_artifacts.dart';
import '../../../data/model/place.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    Key? key,
    required this.place,
    this.opacity = 1.0,
    this.scale = 1.0,
  }) : super(key: key);

  final Place place;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
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
}

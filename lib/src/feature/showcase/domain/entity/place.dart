import 'package:equatable/equatable.dart';

abstract class PlaceBase extends Equatable {
  PlaceBase({
    required this.id,
    required this.name,
    required this.state,
    required this.country,
    required this.countryShort,
    this.wikipediaLink,
    this.googleMapsLink,
  });

  final int id;
  final String name;
  final String state;
  final String country;
  final String countryShort;
  final String? wikipediaLink;
  final String? googleMapsLink;
}

import 'dart:convert';

import '../../geojson_vi.dart';

/// The geometry type Point
class GeoJSONPoint implements GeoJSONGeometry {
  @override
  GeoJSONType get type => GeoJSONType.point;

  /// The [coordinates] member is a single position (two or more
  /// elements). The first two elements are `longitude` and `latitude`
  var coordinates = <double>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox => [
        coordinates[0],
        coordinates[1],
        coordinates[0],
        coordinates[1],
      ];

  @override
  double get distance => 0.0;

  /// The constructor for the [coordinates] member
  GeoJSONPoint(this.coordinates)
      : assert(
            coordinates != null && coordinates.length >= 2,
            'The coordinates is List<double>. '
            'There MUST be two or more elements');

  /// The constructor from map
  factory GeoJSONPoint.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('coordinates')) {
      final value = map['coordinates'];
      if (value is List) {
        final _pos =
            value.map((e) => e.toDouble()).cast<double>().toList();
        return GeoJSONPoint(_pos);
      }
    }
    return null;
  }

  /// The constructor from JSON string
  factory GeoJSONPoint.fromJSON(String source) =>
      GeoJSONPoint.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'coordinates': coordinates,
    };
  }

  @override
  String toJSON() => json.encode(toMap());

  @override
  String toString() => 'Point($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONPoint && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

import 'dart:convert';

import '../../geojson_vi.dart';

/// The geometry type MultiPoint
class GeoJSONMultiPoint implements GeoJSONGeometry {
  @override
  GeoJSONType get type => GeoJSONType.multiPoint;

  ///The [coordinates] member is an array of positions.
  var coordinates = <List<double>>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => [element[0]],
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => [element[1]],
        )
        .toList();
    longitudes.sort();
    latitudes.sort();

    return [
      longitudes.first,
      latitudes.first,
      longitudes.last,
      latitudes.last,
    ];
  }

  @override
  double get distance => 0.0;

  /// The constructor for the [coordinates] member
  GeoJSONMultiPoint(this.coordinates)
      : assert(
            coordinates != null && coordinates.isNotEmpty,
            'The coordinates is List<List<double>>. '
            'There MUST be one or more elements');

  /// The constructor forom map
  factory GeoJSONMultiPoint.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('coordinates')) {
      final lll = map['coordinates'];
      if (lll is List) {
        final _coordinates = <List<double>>[];
        lll.forEach((ll) {
          if (ll is List) {
            final _pos =
                ll.map((e) => e.toDouble()).cast<double>().toList();
            _coordinates.add(_pos);
          }
        });
        return GeoJSONMultiPoint(_coordinates);
      }
    }
    return null;
  }

  /// The constructor from JSON string
  factory GeoJSONMultiPoint.fromJSON(String source) =>
      GeoJSONMultiPoint.fromMap(json.decode(source));

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
  String toString() => 'MultiPoint($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONMultiPoint && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

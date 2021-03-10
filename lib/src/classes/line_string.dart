import 'dart:convert';
import 'dart:math';

import '../../geojson_vi.dart';

/// The geometry type LineString
class GeoJSONLineString implements GeoJSONGeometry {
  @override
  GeoJSONType get type => GeoJSONType.lineString;

  /// The [coordinates] member is a array of two or more positions
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
  double get distance {
    double _calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a)) * 1000.0;
    }

    var _length = 0.0;
    for (var i = 0; i < coordinates.length - 1; i++) {
      var p1 = coordinates[i];
      var p2 = coordinates[i + 1];
      _length += _calculateDistance(p1[1], p1[0], p2[1], p2[0]);
    }
    return _length;
  }

  /// The constructor for the [coordinates] member
  GeoJSONLineString(this.coordinates)
      : assert(coordinates != null && coordinates.length >= 2,
            'The coordinates MUST be two or more positions');

  /// The constructor from map
  factory GeoJSONLineString.fromMap(Map<String, dynamic> map) {
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
        return GeoJSONLineString(_coordinates);
      }
    }
    return null;
  }

  /// The constructor from JSON string
  factory GeoJSONLineString.fromJSON(String source) =>
      GeoJSONLineString.fromMap(json.decode(source));

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
  String toString() => 'LineString($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONLineString && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

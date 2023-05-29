import 'dart:convert';

import 'dart:math';

import '../../geojson_vi.dart';

/// A class representing a GeoJSON LineString.
///
/// A LineString is a curve with linear interpolation between points. Each
/// segment of the LineString is a line in the two-dimensional coordinate plane.
class GeoJSONLineString implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.lineString;

  /// The coordinates of this LineString, represented as an array of point
  /// coordinates.
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
    double calculateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a)) * 1000.0;
    }

    var length = 0.0;
    for (var i = 0; i < coordinates.length - 1; i++) {
      var p1 = coordinates[i];
      var p2 = coordinates[i + 1];
      length += calculateDistance(p1[1], p1[0], p2[1], p2[0]);
    }
    return length;
  }

  /// Constructs a GeoJSONLineString from the provided list of [coordinates].
  GeoJSONLineString(this.coordinates)
      : assert(coordinates.length >= 2,
            'The coordinates MUST be two or more positions');

  /// Constructs a GeoJSONLineString from a Map.
  factory GeoJSONLineString.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['LineString'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');
    assert(map['coordinates'] is List,
        'There MUST be array of two or more positions.');
    final lll = map['coordinates'];
    final coordinates = <List<double>>[];
    lll.forEach((ll) {
      assert(ll is List, 'There MUST be List');
      assert((ll as List).length > 1, 'There MUST be two or more element');
      final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
      coordinates.add(pos);
    });
    return GeoJSONLineString(coordinates);
  }

  /// Constructs a GeoJSONLineString from a JSON string.
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
  String toJSON({int indent = 0}) {
    if (indent > 0) {
      return JsonEncoder.withIndent(' ' * indent).convert(toMap());
    } else {
      return json.encode(toMap());
    }
  }

  @override
  String toString() => 'LineString($coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONLineString && other.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

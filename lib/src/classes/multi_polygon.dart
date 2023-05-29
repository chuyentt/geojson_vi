import 'dart:convert';

import '../../geojson_vi.dart';

/// Class that represents a MultiPolygon geometry type in GeoJSON.
///
/// A MultiPolygon geometry is defined by a list of Polygon coordinate arrays.
class GeoJSONMultiPolygon implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiPolygon;

  /// A list of Polygon coordinate arrays that define the MultiPolygon.
  ///
  /// Each Polygon coordinate array is a list of linear rings, where each ring
  /// is represented by a list of points. Each point is a list of its
  /// coordinates (longitude and latitude).
  var coordinates = <List<List<List<double>>>>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => element.expand(
              (element) => [element[0]],
            ),
          ),
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => element.expand(
              (element) => [element[1]],
            ),
          ),
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

  /// Constructs a GeoJSONMultiPolygon from the given [coordinates].
  ///
  /// The [coordinates] should contain at least one Polygon, and each Polygon
  /// should contain at least two points (the start and end point of a linear
  /// ring).
  GeoJSONMultiPolygon(this.coordinates)
      : assert(coordinates.first.first.length >= 2,
            'The coordinates MUST be two or more elements');

  /// Constructs a GeoJSONMultiPolygon from a map.
  ///
  /// The map must contain a 'type' key with the value 'MultiPolygon', and a
  /// 'coordinates' key with the value being a list of Polygon coordinate arrays.
  factory GeoJSONMultiPolygon.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['MultiPolygon'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');
    assert(map['coordinates'] is List,
        'There MUST be array of Polygon coordinate arrays.');
    final lllll = map['coordinates'];
    final coords = <List<List<List<double>>>>[];
    lllll.forEach((llll) {
      final polygon = <List<List<double>>>[];
      assert(llll is List, 'There MUST be List');
      llll.forEach((lll) {
        assert(lll is List, 'There MUST be List');
        final rings = <List<double>>[];
        lll.forEach((ll) {
          assert(ll is List, 'There MUST be List');
          assert((ll as List).length > 1, 'There MUST be two or more element');
          final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
          rings.add(pos);
        });
        polygon.add(rings);
      });
      coords.add(polygon);
    });
    return GeoJSONMultiPolygon(coords);
  }

  /// Constructs a GeoJSONMultiPolygon from a JSON string.
  ///
  /// The JSON string must represent a map containing a 'type' key with the
  /// value 'MultiPolygon', and a 'coordinates' key with the value being a list
  /// of Polygon coordinate arrays.
  factory GeoJSONMultiPolygon.fromJSON(String source) =>
      GeoJSONMultiPolygon.fromMap(json.decode(source));

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
  String toString() => 'MultiPolygon($coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONMultiPolygon && other.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

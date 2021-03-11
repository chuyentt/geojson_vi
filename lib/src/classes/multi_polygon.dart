import 'dart:convert';

import '../../geojson_vi.dart';

/// The geometry type MultiPolygon
class GeoJSONMultiPolygon implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiPolygon;

  /// The [coordinates] member is a member is an array of Polygon
  /// coordinate arrays.
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

  /// The constructor for the [coordinates] member
  GeoJSONMultiPolygon(this.coordinates)
      : assert(coordinates.length >= 2,
            'The coordinates MUST be two or more elements');

  /// The constructor from map
  factory GeoJSONMultiPolygon.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['MultiPolygon'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');
    assert(map['coordinates'] is List<List<List<List<dynamic>>>>,
        'There MUST be array of Polygon coordinate arrays.');
    final lllll = map['coordinates'];
    final _coordinates = <List<List<List<double>>>>[];
    lllll.forEach((llll) {
      final _polygon = <List<List<double>>>[];
      assert(llll is List, 'There MUST be List');
      llll.forEach((lll) {
        assert(lll is List, 'There MUST be List');
        final _rings = <List<double>>[];
        lll.forEach((ll) {
          assert(ll is List, 'There MUST be List');
          assert((ll as List).length > 1,
              'There MUST be two or more element');
          final _pos =
              ll.map((e) => e.toDouble()).cast<double>().toList();
          _rings.add(_pos);
        });
        _polygon.add(_rings);
      });
      _coordinates.add(_polygon);
    });
    return GeoJSONMultiPolygon(_coordinates);
  }

  /// The constructor from JSON string
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
  String toJSON() => json.encode(toMap());

  @override
  String toString() => 'MultiPolygon($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONMultiPolygon && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

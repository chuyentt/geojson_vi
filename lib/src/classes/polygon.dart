import 'dart:convert';
import 'dart:math';

import '../../geojson_vi.dart';

/// The geometry type Polygon
class GeoJSONPolygon implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.polygon;

  /// The [coordinates] member is a array of linear ring coordinate
  /// arrays.
  var coordinates = <List<List<double>>>[];

  @override
  double get area {
    double _ringArea(List<List<double>> ringPos) {
      const WGS84_RADIUS = 6378137.0;
      const DEG_TO_RAD = pi / 180.0;
      var _area = 0.0;
      for (var i = 0; i < ringPos.length - 1; i++) {
        var p1 = ringPos[i];
        var p2 = ringPos[i + 1];
        _area += (p2[0] * DEG_TO_RAD - p1[0] * DEG_TO_RAD) *
            (2.0 + sin(p1[1] * DEG_TO_RAD) + sin(p2[1] * DEG_TO_RAD));
      }
      _area = _area * WGS84_RADIUS * WGS84_RADIUS / 2.0;
      return _area.abs();
    }

    var exteriorRing = coordinates[0];
    var _area = _ringArea(exteriorRing);
    for (var i = 1; i < coordinates.length; i++) {
      var interiorRing = coordinates[i];
      _area -= _ringArea(interiorRing);
    }
    return _area;
  }

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => [element[0]],
          ),
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => [element[1]],
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
  GeoJSONPolygon(this.coordinates)
      : assert(coordinates.isNotEmpty,
            'The coordinates MUST be one or more elements');

  /// The constructor from map
  factory GeoJSONPolygon.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['Polygon'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');
    assert(map['coordinates'] is List<List<List<dynamic>>>,
        'There MUST be array of linear ring coordinate arrays.');
    final llll = map['coordinates'];
    final _coordinates = <List<List<double>>>[];
    llll.forEach((lll) {
      assert(lll is List, 'There MUST be List');
      final _rings = <List<double>>[];
      lll.forEach((ll) {
        assert(ll is List, 'There MUST be List');
        assert((ll as List).length > 1,
            'There MUST be two or more element');
        final _pos = ll.map((e) => e.toDouble()).cast<double>().toList();
        _rings.add(_pos);
      });
      _coordinates.add(_rings);
    });
    return GeoJSONPolygon(_coordinates);
  }

  /// The constructor from JSON string
  factory GeoJSONPolygon.fromJSON(String source) =>
      GeoJSONPolygon.fromMap(json.decode(source));

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
  String toString() => 'Polygon($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONPolygon && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

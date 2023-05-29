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
    double ringArea(List<List<double>> ringPos) {
      const double wgs84Radius = 6378137.0;
      const double degToRad = pi / 180.0;
      var area = 0.0;
      for (var i = 0; i < ringPos.length - 1; i++) {
        var p1 = ringPos[i];
        var p2 = ringPos[i + 1];
        area += (p2[0] * degToRad - p1[0] * degToRad) *
            (2.0 + sin(p1[1] * degToRad) + sin(p2[1] * degToRad));
      }
      area = area * wgs84Radius * wgs84Radius / 2.0;
      return area.abs();
    }

    var exteriorRing = coordinates[0];
    var area = ringArea(exteriorRing);
    for (var i = 1; i < coordinates.length; i++) {
      var interiorRing = coordinates[i];
      area -= ringArea(interiorRing);
    }
    return area;
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
    assert(map['coordinates'] is List,
        'There MUST be array of linear ring coordinate arrays.');
    final llll = map['coordinates'];
    final coords = <List<List<double>>>[];
    llll.forEach((lll) {
      assert(lll is List, 'There MUST be List');
      final rings = <List<double>>[];
      lll.forEach((ll) {
        assert(ll is List, 'There MUST be List');
        assert((ll as List).length > 1, 'There MUST be two or more element');
        final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
        rings.add(pos);
      });
      coords.add(rings);
    });
    return GeoJSONPolygon(coords);
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
  String toJSON({int indent = 0}) {
    if (indent > 0) {
      return JsonEncoder.withIndent(' ' * indent).convert(toMap());
    } else {
      return json.encode(toMap());
    }
  }

  @override
  String toString() => 'Polygon($coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONPolygon && other.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

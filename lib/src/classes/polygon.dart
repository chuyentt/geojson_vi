part of '../../geojson_vi.dart';

/// The geometry type Polygon
class GeoJSONPolygon implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.polygon;

  /// The [coordinates] member is a array of linear ring coordinate
  /// arrays.
  var coordinates = <List<List<double>>>[];

  @override
  double get area {
    var exteriorRing = coordinates[0];
    var area = getGeographicArea(exteriorRing);
    for (var i = 1; i < coordinates.length; i++) {
      var interiorRing = coordinates[i];
      area -= getGeographicArea(interiorRing);
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

  /// Returns the total length (perimeter) of the outer boundary of the polygon.
  ///
  /// The perimeter is calculated as the sum of the distances between
  /// consecutive points in the outer polygon ring. The polygon is assumed to be
  /// closed, meaning the distance between the last point and the first point is
  /// also included in the perimeter calculation.
  ///
  /// The distance between points is calculated using the calculateDistance
  /// method.
  ///
  /// Returns:
  ///   A double representing the total length (perimeter) of the outer boundary
  ///   of the polygon, in the same units as used by calculateDistance (usually
  ///   meters).
  double get perimeter {
    var perimeter = 0.0;
    for (var i = 0; i < coordinates[0].length - 1; i++) {
      var p1 = coordinates[0][i];
      var p2 = coordinates[0][i + 1];
      perimeter += calculateHaversineDistance(p1[1], p1[0], p2[1], p2[0]);
    }
    // Add distance between the last point and the first point to close the polygon
    var p1 = coordinates[0][coordinates[0].length - 1];
    var p2 = coordinates[0][0];
    perimeter += calculateHaversineDistance(p1[1], p1[0], p2[1], p2[0]);

    return perimeter;
  }

  /// Returns the geographic center (centroid) of a polygon, including any holes.
  ///
  /// The centroid is calculated by taking into account the area of the outer
  /// polygon and subtracting the areas of any holes.
  ///
  /// Note: The centroid may not necessarily lie within the polygon, especially
  /// if the polygon has a complex shape or includes holes.
  ///
  /// Returns:
  ///   A two-element list [longitude, latitude] representing the centroid
  ///   coordinates.
  ///
  /// Throws an [ArgumentError] if there are fewer than three points provided
  /// to calculate the area of a polygon.
  ///
  /// Reference: [Wikipedia](https://en.wikipedia.org/wiki/Centroid#Of_a_polygon)
  List<double> get centroid {
    var coords = <List<List<double>>>[];
    for (final ring in coordinates) {
      final transformedRing = <List<double>>[];

      for (final point in ring) {
        final List<double> transformedPoint =
            convertToWebMercator(point[0], point[1]);
        transformedRing.add(transformedPoint);
      }

      coords.add(transformedRing);
    }
    var outer = coords.first;
    var n = outer.length;
    double cx = 0;
    double cy = 0;
    for (int i = 0; i < n; i++) {
      double x1 = outer[i][1];
      double y1 = outer[i][0];
      double x2 = outer[(i + 1) % n][1];
      double y2 = outer[(i + 1) % n][0];
      double f = x1 * y2 - x2 * y1;
      cx += (x1 + x2) * f;
      cy += (y1 + y2) * f;
    }
    double a = getPlanarArea(outer) * 6;
    var c = convertFromWebMercator(cy / a, cx / a);
    return c;
  }

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
  String toString() => 'GeoJSONPolygon(type: $type, coordinates: $coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is GeoJSONPolygon) {
      if (other.type != type ||
          other.coordinates.length != coordinates.length) {
        return false;
      }

      return coordinates.asMap().entries.map((entry) {
        int i = entry.key;
        List<List<double>> lineString1 = entry.value;
        List<List<double>> lineString2 = other.coordinates[i];
        return lineString1.asMap().entries.map((entry) {
          int j = entry.key;
          return doubleListsEqual(lineString1[j], lineString2[j]);
        }).reduce((value, element) => value && element);
      }).reduce((value, element) => value && element);
    }
    return false;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      coordinates
          .expand((list) => list)
          .expand((innerList) => innerList)
          .fold(0, (hash, value) => hash ^ value.hashCode);
}

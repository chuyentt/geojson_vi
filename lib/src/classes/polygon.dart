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
    var c = convertFromWebMercator(cy.abs() / a, cx.abs() / a);
    return c;
  }

  /// Determines if a point is inside
  ///
  /// [point] is the point to check, represented as a `List<double>` containing
  /// the longitude and latitude coordinates.
  ///
  /// Returns `true` if the point is inside the polygon; otherwise, `false.`
  bool isPointInside(List<double> point) {
    var coords = <List<List<double>>>[];
    var pt = convertToWebMercator(point[0], point[1]);
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
    bool inside = false;
    for (int i = 0, j = outer.length - 1; i < outer.length; j = i++) {
      if (((outer[i][1] > pt[1]) != (outer[j][1] > pt[1])) &&
          (pt[0] <
              (outer[j][0] - outer[i][0]) *
                      (pt[1] - outer[i][1]) /
                      (outer[j][1] - outer[i][1]) +
                  outer[i][0])) {
        inside = !inside;
      }
    }
    return inside;
  }

  /// Checks if a point is within a complex polygon, considering the outer boundary and any inner holes.
  ///
  /// The method first checks if the point is within the outer boundary. It then checks each hole, returning
  /// `false` if the point is found within any of them.
  ///
  /// [point] is the point to check, represented as a `List<double>` containing the `longitude` and `latitude` coordinates.
  ///
  /// Returns `true` if the point is within the outer boundary and not within any holes.
  bool isPointInsideComplex(List<double> point) {
    if (!isPointInside(point)) {
      return false;
    }
    for (int i = 1; i < coordinates.length; i++) {
      if (GeoJSONPolygon([coordinates[i]]).isPointInside(point)) {
        return false;
      }
    }
    return true;
  }

  /// Calculates the optimal point within a complex polygon using a custom grid-based search algorithm.
  ///
  /// This method determines an ideal point for label placement within a polygon to ensure
  /// maximum visibility and minimal obstruction by the polygon's edges. It employs a
  /// grid-based search algorithm developed specifically for this package, which involves
  /// creating a grid over the polygon and evaluating potential points based on their
  /// distance to the nearest edge.
  ///
  /// The complex polygon can include holes, and the point will not be placed inside any of these holes.
  ///
  /// [resolution] allows you to adjust the granularity of the grid search for the optimal point. A higher
  /// resolution increases the computation time but may result in a more precise location.
  ///
  /// Returns a `List<double>` representing the optimal point's `longitude` and `latitude` coordinates.
  ///
  /// While this method is based on a grid search, it is a unique implementation designed for
  /// the specific needs of geospatial analysis within this package and may not directly correspond
  /// to any single established grid-based search algorithm in the literature.
  List<double> optimalPointInside({double resolution = 2.0}) {
    // Calculate the distance between two points in WebMercator coordinates
    double distance(List<double> point1, List<double> point2) {
      return sqrt(
          pow(point1[0] - point2[0], 2) + pow(point1[1] - point2[1], 2));
    }

    /// Calculates the perpendicular distance from a point to a line segment.
    ///
    /// This method finds the closest point on the line segment to the given point and calculates the
    /// distance between these two points in WebMercator coordinates.
    ///
    /// [point] is the point from which the distance is measured.
    /// [lineStart] and [lineEnd] define the line segment's endpoints.
    ///
    /// Returns the perpendicular distance as a double.
    double perpendicularDistance(
        List<double> point, List<double> lineStart, List<double> lineEnd) {
      double dx = lineEnd[0] - lineStart[0];
      double dy = lineEnd[1] - lineStart[1];
      if (dx == 0 && dy == 0) {
        return distance(point, lineStart);
      }
      double t =
          ((point[0] - lineStart[0]) * dx + (point[1] - lineStart[1]) * dy) /
              (dx * dx + dy * dy);
      t = max(0, min(1, t));
      double nearestPointX = lineStart[0] + t * dx;
      double nearestPointY = lineStart[1] + t * dy;
      return distance(point, [nearestPointX, nearestPointY]);
    }

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

    List<double> labelPoint = [];
    double maxDistance = 0.0;

    // Determine the boundary of the rectangle that covers the outer polygon
    double minX = coords[0].reduce((a, b) => [min(a[0], b[0]), a[1]])[0];
    double maxX = coords[0].reduce((a, b) => [max(a[0], b[0]), a[1]])[0];
    double minY = coords[0].reduce((a, b) => [a[0], min(a[1], b[1])])[1];
    double maxY = coords[0].reduce((a, b) => [a[0], max(a[1], b[1])])[1];

    // Calculate grid size
    int gridSize = (sqrt(coordinates[0].length) * resolution).ceil();
    double deltaX = (maxX - minX) / gridSize;
    double deltaY = (maxY - minY) / gridSize;

    // Browse through the point grid
    for (int i = 0; i <= gridSize; i++) {
      for (int j = 0; j <= gridSize; j++) {
        List<double> gridPoint = [minX + i * deltaX, minY + j * deltaY];
        var gridPointLonLat =
            convertFromWebMercator(gridPoint.first, gridPoint.last);
        if (isPointInsideComplex(gridPointLonLat)) {
          double minDistance = double.infinity;
          // Calculate the distance from the point to each edge of the outer polygon and the holes
          for (var polygon in coords) {
            for (int k = 0; k < polygon.length; k++) {
              List<double> currentVertex = polygon[k];
              List<double> nextVertex = polygon[(k + 1) % polygon.length];
              double distance =
                  perpendicularDistance(gridPoint, currentVertex, nextVertex);
              if (distance < minDistance) {
                minDistance = distance;
              }
            }
          }
          if (minDistance > maxDistance) {
            maxDistance = minDistance;
            labelPoint = gridPoint;
          }
        }
      }
    }

    return convertFromWebMercator(labelPoint.first, labelPoint.last);
  }

  /// The constructor for the [coordinates] member
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  GeoJSONPolygon(this.coordinates) {
    _assert(coordinates.isNotEmpty,
        'The coordinates MUST be one or more elements', coordinates);
  }

  /// The constructor from map
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONPolygon.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(['Polygon'].contains(map['type']), 'Invalid type', map['type']);
    _assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`', map);
    _assert(
        map['coordinates'] is List,
        'There MUST be array of linear ring coordinate arrays.',
        map['coordinates']);
    final llll = map['coordinates'];
    final coords = <List<List<double>>>[];
    llll.forEach((lll) {
      _assert(lll is List, 'There MUST be List', [map, lll]);
      final rings = <List<double>>[];
      lll.forEach((ll) {
        _assert(ll is List, 'There MUST be List', [map, ll]);
        _assert((ll as List).length > 1, 'There MUST be two or more element',
            [map, ll]);
        final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
        rings.add(pos);
      });
      coords.add(rings);
    });
    return GeoJSONPolygon(coords);
  }

  /// The constructor from JSON string
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
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
          other.coordinates.length != coordinates.length ||
          other.coordinates.first.length != coordinates.first.length) {
        return false;
      }

      return coordinates.asMap().entries.map((entry) {
        int i = entry.key;
        List<List<double>> lineString1 = entry.value;
        List<List<double>> lineString2 = other.coordinates[i];
        if (lineString1.length != lineString2.length) return false;
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

part of '../../geojson_vi.dart';

/// Calculates the Haversine distance in meters between two points specified by their
/// latitude and longitude coordinates.
///
/// The distance is calculated using the Haversine formula, which provides an
/// approximation of the great-circle distance between two points on a sphere.
/// This function is more suitable when calculating distance with geographic coordinates.
///
/// [lat1]: The latitude of the first point in decimal degrees.
/// [lon1]: The longitude of the first point in decimal degrees.
/// [lat2]: The latitude of the second point in decimal degrees.
/// [lon2]: The longitude of the second point in decimal degrees.
///
/// Returns the Haversine distance between the two points in meters.
double calculateHaversineDistance(num lat1, num lon1, num lat2, num lon2) {
  var p = 0.017453292519943295; // Pi/180
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12756.274 * asin(sqrt(a)) * 1000.0; // 2*R*asin...
}

/// Checks if two lists of [num] are equal.
///
/// This function compares each corresponding pair of numbers from the two
/// input lists. The input lists are considered equal if they have the same
/// length and each pair of corresponding elements are equal.
///
/// [list1] and [list2] are the two lists to be compared.
///
/// Returns `true` if the two input lists are equal, `false` otherwise.
///
/// Example usage:
///
/// ```
/// var list1 = [1, 2, 3.5];
/// var list2 = [1, 2, 3.5];
/// var list3 = [1, 2, 3.6];
/// print(numListEquals(list1, list2));  // prints: true
/// print(numListEquals(list1, list3));  // prints: false
/// ```
bool numListEquals(List<num> list1, List<num> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

/// Returns the area of a ring with planar coordinates.
///
/// The ring is represented as a list of points. Each point is a list
/// of two doubles ([x, y]).
///
/// The area is computed using the method of signed areas, also known as
/// the shoelace formula. The formula calculates the signed areas of the
/// trapezoids under the lines between consecutive points. The formula
/// requires the points to be ordered either clockwise or counter-clockwise.
///
/// The absolute value of the signed area gives the area of the ring.
///
/// Throws [ArgumentError] if the input is not a list of at least three points.
///
/// Example:
/// ```
/// var ring = [
///   [0.0, 0.0],
///   [1.0, 0.0],
///   [1.0, 1.0],
///   [0.0, 1.0]
/// ];
/// print(getPlanarArea(ring));  // prints: 1.0
/// ```
///
/// [ring]: A list of points representing the ring.
/// Each point is a list of two doubles ([x, y]).
///
/// Returns the area of the ring.
double getPlanarArea(List<List<double>> ring) {
  if (ring.length < 4 || !numListEquals(ring.first, ring.last)) {
    throw ArgumentError(
        "Input must be a list of at least four points, where the first and last points are the same.");
  }

  int n = ring.length;
  double a = 0;
  for (int i = 0; i < n; i++) {
    double x1 = ring[i][0];
    double y1 = ring[i][1];
    double x2 = ring[(i + 1) % n][0];
    double y2 = ring[(i + 1) % n][1];
    a += x1 * y2 - x2 * y1;
  }
  return (a / 2).abs();
}

/// Computes the area of a geographic polygon ring using the WGS84 ellipsoid.
///
/// This function calculates the area using the method of spherical excess.
/// This method requires the coordinates to be geographic (longitude and
/// latitude in degrees). It takes into account the Earth's ellipsoidal
/// shape and gives accurate results for large polygons.
///
/// The polygon ring is represented as a list of points, where each point
/// is a list of two doubles ([longitude, latitude]). The points must be
/// ordered either clockwise or counter-clockwise and the first point
/// should be the same as the last point to ensure the polygon ring is closed.
///
/// Throws [ArgumentError] if the input is not a list of at least four points.
///
/// Example:
/// ```
/// var ring = [
///   [0.0, 0.0],
///   [1.0, 0.0],
///   [1.0, 1.0],
///   [0.0, 1.0],
///   [0.0, 0.0] // repeat the first point to close the polygon
/// ];
/// print(getGeographicArea(ring));  // prints the area in square meters
/// ```
///
/// [ring]: A list of points representing the polygon ring.
/// Each point is a list of two doubles ([longitude, latitude]).
///
/// Returns the area of the polygon ring in square meters.
double getGeographicArea(List<List<double>> ring) {
  if (ring.length < 4 || !numListEquals(ring.first, ring.last)) {
    throw ArgumentError(
        "Input must be a list of at least four points, where the first and last points are the same.");
  }

  const double wgs84Radius = 6378137.0;
  const double degToRad = pi / 180.0;
  var area = 0.0;
  for (var i = 0; i < ring.length - 1; i++) {
    var p1 = ring[i];
    var p2 = ring[i + 1];
    area += (p2[0] * degToRad - p1[0] * degToRad) *
        (2.0 + sin(p1[1] * degToRad) + sin(p2[1] * degToRad));
  }
  area = area * wgs84Radius * wgs84Radius / 2.0;
  return area.abs();
}

/// Converts latitude and longitude coordinates in decimal degrees to the Web
/// Mercator EPSG:3857 coordinate system.
///
/// The Web Mercator projection is commonly used in web mapping applications.
/// The conversion formula scales and transforms the latitude and longitude
/// coordinates to match the coordinate system used by Web Mercator.
///
/// - [longitude]: The longitude coordinate in decimal degrees.
/// - [latitude]: The latitude coordinate in decimal degrees.
///
/// Returns a list of two double values representing the converted coordinates
/// in the Web Mercator EPSG:3857 coordinate system. The first value is the
/// converted longitude (x) and the second value is the converted latitude (y).
List<double> convertToWebMercator(double longitude, double latitude) {
  final x = longitude * 20037508.34 / 180.0;
  var y = log(tan((90.0 + latitude) * pi / 360.0)) / (pi / 180.0);
  y = y * 20037508.34 / 180.0;

  return [x, y];
}

/// Converts Web Mercator EPSG:3857 coordinates to decimal latitude and longitude.
///
/// The function takes in the `x` and `y` coordinates in the Web Mercator EPSG:3857
/// projection and converts them to decimal degrees for latitude and longitude.
///
/// - [x]: The x-coordinate in Web Mercator EPSG:3857.
/// - [y]: The y-coordinate in Web Mercator EPSG:3857.
///
/// Returns a list of two double values representing the converted decimal
/// latitude and longitude. The first value is the converted longitude, and
/// the second value is the converted latitude.
List<double> convertFromWebMercator(double x, double y) {
  final longitude = (x / 20037508.34) * 180.0;
  final lat0 = (y / 20037508.34) * 180.0;
  final radiansToDegrees = 180.0 / pi;

  final latitude =
      radiansToDegrees * (2.0 * atan(exp(lat0 / radiansToDegrees)) - pi / 2.0);

  return [longitude, latitude];
}

/// Triangulates a polygon using the Ear Clipping method.
///
/// This function takes a convex or concave polygon and returns a list of triangles
/// that fully cover the area of the original polygon.
///
/// The polygon is defined by a list of points. Each point is represented as a
/// list of two doubles ([x, y]). The polygon is assumed to be simple (does not
/// intersect itself or have holes).
///
/// If the input polygon is already a triangle, the function will return a list containing
/// the original polygon.
///
/// Throws [ArgumentError] if the polygon has less than 3 points.
///
/// Example:
/// ```
/// var polygon = [
///   [0.0, 0.0],
///   [1.0, 0.0],
///   [1.0, 1.0],
///   [0.0, 1.0]
/// ];
/// var result = earClipping(polygon);
/// print(result);
/// ```
///
/// [polygon]: A list of points representing the polygon.
/// Each point is represented as a list of two doubles ([x, y]).
///
/// Returns a list of triangles that represent the triangulation of the polygon.
/// Each triangle is represented as a list of three points.
/// Each point is represented as a list of two doubles ([x, y]).
List<List<List<double>>> earClipping(List<List<double>> polygon) {
  // Check if the polygon is valid.
  if (polygon.length < 3) {
    throw ArgumentError("A polygon must have at least 3 points.");
  }

  List<List<List<double>>> result = [];

  // Create a copy of the points to avoid modifying the original polygon.
  List<List<double>> points = List.from(polygon);

  while (points.length > 3) {
    for (int i = 0; i < points.length; i++) {
      int prev = (i - 1 + points.length) % points.length;
      int next = (i + 1) % points.length;

      var a = points[prev];
      var b = points[i];
      var c = points[next];

      // Check if angle ABC is convex.
      double crossProduct =
          (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0]);
      if (crossProduct < 0) continue;

      // Check if any point lies inside triangle ABC.
      bool isEar = true;
      for (var p in points) {
        if (p == a || p == b || p == c) continue;
        double areaABC = ((a[0] * (b[1] - c[1]) +
                    b[0] * (c[1] - a[1]) +
                    c[0] * (a[1] - b[1]))
                .abs()) /
            2;
        double areaABP = ((a[0] * (b[1] - p[1]) +
                    b[0] * (p[1] - a[1]) +
                    p[0] * (a[1] - b[1]))
                .abs()) /
            2;
        double areaBCP = ((b[0] * (c[1] - p[1]) +
                    c[0] * (p[1] - b[1]) +
                    p[0] * (b[1] - c[1]))
                .abs()) /
            2;
        double areaCAP = ((c[0] * (a[1] - p[1]) +
                    a[0] * (p[1] - c[1]) +
                    p[0] * (c[1] - a[1]))
                .abs()) /
            2;
        if (areaABC == areaABP + areaBCP + areaCAP) {
          isEar = false;
          break;
        }
      }

      if (isEar) {
        // Remove the ear from the polygon.
        points.removeAt(i);

        // Add the ear to the result.
        result.add([a, b, c]);
        break;
      }
    }
  }

  // Add the remaining triangle to the result.
  if (points.length == 3) {
    result.add(points);
  }

  return result;
}

/// Computes the incircle of a triangle.
///
/// The triangle is represented by a list of three points. Each point is a list of two doubles ([x, y]).
///
/// The function returns a Map with two keys:
/// * 'center': a list of two doubles representing the coordinates of the center of the incircle.
/// * 'radius': a double representing the radius of the incircle.
///
/// Throws [ArgumentError] if the input is not a list of three points.
///
/// Example:
/// ```
/// var triangle = [
///   [0.0, 0.0],
///   [1.0, 0.0],
///   [0.5, sqrt(3)/2]
/// ];
/// var incircle = findIncircle(triangle);
/// print(incircle);  // prints: {'center': [0.5, 0.2886751345948129], 'radius': 0.2886751345948129}
/// ```
///
/// [points]: A list of three points representing the triangle.
/// Each point is a list of two doubles ([x, y]).
///
/// Returns a Map with the center and radius of the incircle of the triangle.
Map<String, dynamic> findIncircle(List<List<double>> points) {
  if (points.length != 3) {
    throw ArgumentError("Input must be a list of three points.");
  }

  // Compute the side lengths of the triangle.
  double a = sqrt(pow(points[1][0] - points[0][0], 2) +
      pow(points[1][1] - points[0][1], 2));
  double b = sqrt(pow(points[2][0] - points[1][0], 2) +
      pow(points[2][1] - points[1][1], 2));
  double c = sqrt(pow(points[0][0] - points[2][0], 2) +
      pow(points[0][1] - points[2][1], 2));

  // Compute the semiperimeter of the triangle.
  double s = (a + b + c) / 2;

  // Compute the radius of the incircle.
  double radius = sqrt((s - a) * (s - b) * (s - c) / s);

  // Compute the coordinates of the incenter.
  double x =
      (a * points[2][0] + b * points[0][0] + c * points[1][0]) / (a + b + c);
  double y =
      (a * points[2][1] + b * points[0][1] + c * points[1][1]) / (a + b + c);

  return {
    'center': [x, y],
    'radius': radius
  };
}

/// Checks if two lists of doubles are equal by comparing their lengths and values.
///
/// Returns `true` if [list1] and [list2] are equal, or `false` otherwise.
/// If the lengths of [list1] and [list2] are different, they are considered unequal.
/// For each value in [list1], if the corresponding value in [list2] is different,
/// they are considered unequal.
bool doubleListsEqual(List<double> list1, List<double> list2) {
  return list1.length == list2.length &&
      list1.asMap().entries.every((entry) {
        int index = entry.key;
        double value = entry.value;
        return value == list2[index];
      });
}

/// Checks if two maps are equal by comparing their keys and values.
///
/// Returns `true` if [map1] and [map2] are equal, or `false` otherwise.
/// If both [map1] and [map2] are `null`, they are considered equal.
/// If either [map1] or [map2] is `null`, they are considered unequal.
/// If the lengths of [map1] and [map2] are different, they are considered unequal.
/// For each key in [map1], if [map2] does not contain the key or the values
/// associated with the key are different, they are considered unequal.
bool mapEquals(Map<dynamic, dynamic>? map1, Map<dynamic, dynamic>? map2) {
  if (map1 == map2) return true;
  if (map1 == null || map2 == null) return false;
  if (map1.length != map2.length) return false;

  for (final key in map1.keys) {
    if (!map2.containsKey(key) || map1[key] != map2[key]) {
      return false;
    }
  }

  return true;
}

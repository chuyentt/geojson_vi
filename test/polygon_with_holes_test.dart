import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('GeoJSONPolygon', () {
    test('Creating a Polygon with Holes', () {
      // Define the exterior ring coordinates
      final exteriorRing = [
        [0.0, 0.0],
        [10.0, 0.0],
        [10.0, 10.0],
        [0.0, 10.0],
        [0.0, 0.0]
      ];

      // Define the interior ring coordinates (hole)
      final interiorRing = [
        [2.0, 2.0],
        [2.0, 8.0],
        [8.0, 8.0],
        [8.0, 2.0],
        [2.0, 2.0]
      ];

      // Create the Polygon with Holes
      final polygonWithHoles = GeoJSON.fromMap({
        'type': 'Polygon',
        'coordinates': [exteriorRing, interiorRing]
      });

      // Verify the type
      expect(polygonWithHoles.type, GeoJSONType.polygon);

      // Verify the number of rings
      expect(
        (polygonWithHoles as GeoJSONPolygon).coordinates.length,
        equals(2),
      );

      // Verify the coordinates of the exterior ring
      expect(polygonWithHoles.coordinates[0], equals(exteriorRing));

      // Verify the coordinates of the interior ring (hole)
      expect(polygonWithHoles.coordinates[1], equals(interiorRing));

      // Convert the Polygon with Holes to JSON
      final polygonWithHolesJson = polygonWithHoles.toJSON();

      // Create a new Polygon with Holes from the JSON representation
      final parsedPolygonWithHoles = GeoJSON.fromJSON(polygonWithHolesJson);

      // Verify the coordinates of the exterior ring
      expect(
        (parsedPolygonWithHoles as GeoJSONPolygon).coordinates[0],
        equals(exteriorRing),
      );

      // Verify the coordinates of the interior ring (hole)
      expect(parsedPolygonWithHoles.coordinates[1], equals(interiorRing));
    });
  });
}

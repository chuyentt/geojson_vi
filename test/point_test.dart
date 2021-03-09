import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final fakeLatitude = -30.0653338;
  final fakeLongitude = -51.2356;

  group('GeoPoint', () {
    test('creates an instances by using fromMap', () {
      final data = {
        'coordinates': [fakeLongitude, fakeLatitude],
      };
      final expectedCoordinates = [fakeLongitude, fakeLatitude];

      final geoJsonPoint = GeoJSONPoint.fromMap(data);

      expect(geoJsonPoint.type, GeometryType.point);
      expect(geoJsonPoint.coordinates, expectedCoordinates);
    });

    test('toMap of an object created by the constructor', () {
      final coordinates = [fakeLongitude, fakeLatitude];
      final expectedMap = {
        'type': GeometryType.point.name,
        'coordinates': [fakeLongitude, fakeLatitude],
      };

      final geoJsonPoint = GeoJSONPoint(coordinates);

      expect(geoJsonPoint.toMap(), expectedMap);
    });
  });
}

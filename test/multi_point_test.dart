import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final expectedCoordinates = [
    [-40.473633, -18.729502],
    [-42.187500, -17.476432],
    [-41.528320, -17.947380],
    [-41.055908, -18.250219]
  ];

  group('GeoJSONMultiPoint', () {
    test('creates an instance using fromMap', () {
      final data = {
        'type': 'MultiPoint',
        'coordinates': expectedCoordinates,
      };

      final geoJson = GeoJSONMultiPoint.fromMap(data);

      expect(geoJson.type, GeoJSONType.multiPoint);
      expect(geoJson.coordinates, expectedCoordinates);
    });

    test('returns a map representation of an object created by the constructor',
        () {
      final expectedMap = {
        'type': GeoJSONType.multiPoint.value,
        'coordinates': expectedCoordinates,
      };

      final geoJson = GeoJSONMultiPoint(expectedCoordinates);

      expect(geoJson.toMap(), expectedMap);
    });

    test('returns the bounding box of the multipoint', () {
      final expectedBbox = [-42.187500, -18.729502, -40.473633, -17.476432];

      final geoJson = GeoJSONMultiPoint(expectedCoordinates);

      expect(geoJson.bbox, expectedBbox);
    });

    test('returns the string representation of the geospatial data', () {
      final expectedString = jsonEncode({
        'type': GeoJSONType.multiPoint.value,
        'coordinates': expectedCoordinates,
      });
      final geoJson = GeoJSONMultiPoint(expectedCoordinates);

      expect(geoJson.toJSON(), expectedString);
    });
  });
}

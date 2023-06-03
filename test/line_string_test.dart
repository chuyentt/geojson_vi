import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final expectedCoordinates = [
    [-53.940124, -30.057208],
    [-53.951110, -29.933515],
    [-53.907165, -29.797751],
    [-53.857727, -29.671349],
    [-53.959350, -29.556734],
    [-53.786315, -29.475470],
    [-53.706665, -29.396533]
  ];
  final expectedMap = {
    'type': 'LineString',
    'coordinates': expectedCoordinates,
  };

  group('GeoJSONLineString', () {
    test('creates an instance using fromMap', () {
      final geoJson = GeoJSONLineString.fromMap(expectedMap);

      expect(geoJson.type, GeoJSONType.lineString);
      expect(geoJson.coordinates, expectedCoordinates);
    });

    test('returns a map representation of an object created by the constructor',
        () {
      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.toMap(), expectedMap);
    });

    test('returns the bounding box of the line string', () {
      final expectedBbox = [-53.959350, -30.057208, -53.706665, -29.396533];

      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.bbox, expectedBbox);
    });

    test('returns the string representation of the geospatial data', () {
      final expectedString = jsonEncode(expectedMap);

      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.toJSON(), expectedString);
    });

    test('returns the distance of the line string', () {
      final expectedDistance = 91120.70;
      final delta = 5.0;

      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.distance, closeTo(expectedDistance, delta));
    });
  });
}

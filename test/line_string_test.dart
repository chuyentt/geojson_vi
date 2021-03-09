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
    test('creates an instances by using fromMap', () {
      final geoJson = GeoJSONLineString.fromMap(expectedMap);

      expect(geoJson.type, GeometryType.lineString);
      expect(geoJson.coordinates, expectedCoordinates);
    });

    test('toMap of an object created by the constructor', () {
      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.toMap(), expectedMap);
    });

    test('get bbox of a given GeoJSONLineString', () {
      final expectedBbox = [-53.959350, -30.057208, -53.706665, -29.396533];

      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.bbox, expectedBbox);
    });

    test(
        'toString returns collection of key/value pairs of geospatial data as String',
        () {
      final expectedString = jsonEncode(expectedMap);

      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.toString(), expectedString);
    });

    test('distance of a given GeoJSONLineString', () {
      final expectedDistance = 91120.70;
      final delta = 5.0;

      final geoJson = GeoJSONLineString(expectedCoordinates);

      expect(geoJson.distance, closeTo(expectedDistance, delta));
    });
  });
}

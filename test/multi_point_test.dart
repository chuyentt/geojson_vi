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
    test('creates an instances by using fromMap', () {
      final data = {
        'coordinates': expectedCoordinates,
      };

      final geoJson = GeoJSONMultiPoint.fromMap(data);

      expect(geoJson.type, GeometryType.multiPoint);
      expect(geoJson.coordinates, expectedCoordinates);
    });

    test('toMap of an object created by the constructor', () {
      final expectedMap = {
        'type': GeometryType.multiPoint.name,
        'coordinates': expectedCoordinates,
      };

      final geoJson = GeoJSONMultiPoint(expectedCoordinates);

      expect(geoJson.toMap(), expectedMap);
    });

    test('get bbox of a given multipoint', () {
      final expectedBbox = [-42.187500, -18.729502, -40.473633, -17.476432];

      final geoJson = GeoJSONMultiPoint(expectedCoordinates);

      expect(geoJson.bbox, expectedBbox);
    });

    test(
        'toString returns collection of key/value pairs of geospatial data as String',
        () {
      final map = {
        'type': GeometryType.multiPoint.name,
        'coordinates': expectedCoordinates,
      };
      final expectedString = jsonEncode(map);
      final geoJson = GeoJSONMultiPoint(expectedCoordinates);

      expect(geoJson.toString(), expectedString);
    });
  });
}

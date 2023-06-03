import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final expectedCoordinates = [
    [
      [-51.998291, -16.299051],
      [-51.405029, -16.488764],
      [-50.416259, -16.678293],
      [-49.801025, -16.962232],
      [-49.559326, -17.025272]
    ],
    [
      [-51.932373, -16.056371],
      [-51.361083, -16.256867],
      [-50.888671, -16.299051],
      [-50.383300, -16.467694],
      [-49.526367, -16.867633]
    ],
    [
      [-51.690673, -16.583552],
      [-50.965576, -16.846605],
      [-50.152587, -17.067287],
      [-49.888916, -17.235251],
      [-49.482422, -17.298199]
    ]
  ];
  final expectedMap = {
    'type': 'MultiLineString',
    'coordinates': expectedCoordinates,
  };

  group('GeoJSONMultiLineString', () {
    test('creates an instance using fromMap', () {
      final geoJson = GeoJSONMultiLineString.fromMap(expectedMap);

      expect(geoJson.type, GeoJSONType.multiLineString);
      expect(geoJson.coordinates, expectedCoordinates);
    });

    test('returns a map representation of an object created by the constructor',
        () {
      final geoJson = GeoJSONMultiLineString(expectedCoordinates);

      expect(geoJson.toMap(), expectedMap);
    });

    test('returns the bounding box of the multi-line string', () {
      final expectedBbox = [-51.998291, -17.298199, -49.482422, -16.056371];

      final geoJson = GeoJSONMultiLineString(expectedCoordinates);

      expect(geoJson.bbox, expectedBbox);
    });

    test('returns the string representation of the geospatial data', () {
      final expectedString = jsonEncode(expectedMap);

      final geoJson = GeoJSONMultiLineString(expectedCoordinates);

      expect(geoJson.toJSON(), expectedString);
    });
  });
}

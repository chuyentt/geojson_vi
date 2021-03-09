import 'package:geojson_vi/geojson_vi.dart';
import 'package:geojson_vi/src/classes/geometry.dart';
import 'package:test/test.dart';

void main() {
  final expectedCoordinates = [
    [
      [
        [102.0, 2.0],
        [103.0, 2.0],
        [103.0, 3.0],
        [102.0, 3.0],
        [102.0, 2.0]
      ]
    ],
    [
      [
        [100.0, 0.0],
        [101.0, 0.0],
        [101.0, 1.0],
        [100.0, 1.0],
        [100.0, 0.0]
      ],
      [
        [100.2, 0.2],
        [100.8, 0.2],
        [100.8, 0.8],
        [100.2, 0.8],
        [100.2, 0.2]
      ]
    ]
  ];

  group('GeoJSONMultiPolygon', () {
    test('creates an instances by using fromMap', () {
      final data = {
        'coordinates': expectedCoordinates,
      };

      final geoJsonMultiPolygon = GeoJSONMultiPolygon.fromMap(data);

      expect(geoJsonMultiPolygon.type, GeometryType.multiPolygon);
      expect(geoJsonMultiPolygon.coordinates, expectedCoordinates);
    });

    test('toMap of an object created by the constructor', () {
      final expectedMap = {
        'type': GeometryType.multiPolygon.name,
        'coordinates': expectedCoordinates,
      };

      final geoJsonMultiPolygon = GeoJSONMultiPolygon(expectedCoordinates);

      expect(geoJsonMultiPolygon.toMap(), expectedMap);
    });

    test('get bbox of a given multipolygon', () {
      final expectedBbox = [100.000000, 0.000000, 103.000000, 3.000000];

      final geoJsonMultiPolygon = GeoJSONMultiPolygon(expectedCoordinates);

      expect(geoJsonMultiPolygon.bbox, expectedBbox);
    });
  });
}

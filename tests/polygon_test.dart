import 'package:geojson_vi/geojson_vi.dart';
import 'package:geojson_vi/src/classes/geometry.dart';
import 'package:test/test.dart';

void main() {
  final expectedPolygonCoordinates = [
    [
      [-43.230695575475686, -22.91240592161791],
      [-43.23012828826904, -22.912718759177814],
      [-43.229606598615646, -22.91190099471436],
      [-43.23016718029975, -22.91159216999324],
      [-43.230695575475686, -22.91240592161791]
    ]
  ];

  group('GeoJSONPolygon', () {
    test('creates an instances by using fromMap', () {
      final data = {
        'coordinates': expectedPolygonCoordinates,
      };

      final geoJsonPoint = GeoJSONPolygon.fromMap(data);

      expect(geoJsonPoint.type, GeometryType.polygon);
      expect(geoJsonPoint.coordinates, expectedPolygonCoordinates);
    });

    test('toMap of an object created by the constructor', () {
      final expectedMap = {
        'type': GeometryType.polygon.name,
        'coordinates': expectedPolygonCoordinates,
      };

      final geoJsonPoint = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(geoJsonPoint.toMap(), expectedMap);
    });

    test('toMap of an object created by the constructor', () {
      final expectedMap = {
        'type': GeometryType.polygon.name,
        'coordinates': expectedPolygonCoordinates,
      };

      final geoJsonPoint = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(geoJsonPoint.toMap(), expectedMap);
    });

    test('calculates area of a given polygon', () {
      final expectedArea = 7113.80;
      final precision = 0.01;

      final geoJsonPoint = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(
        geoJsonPoint.area,
        inInclusiveRange(expectedArea - precision, expectedArea + precision),
      );
    });

    test('get bbox of a given polygon', () {
      final expectedBbox = [
        -43.230695575475686,
        -22.912718759177814,
        -43.229606598615646,
        -22.91159216999324
      ];

      final geoJsonPoint = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(geoJsonPoint.bbox, expectedBbox);
    });
  });
}

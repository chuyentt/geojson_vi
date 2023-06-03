import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final lineStringCoordinates = [
    [-43.230695575475686, -22.91240592161791],
    [-43.23012828826904, -22.912718759177814],
    [-43.229606598615646, -22.91190099471436],
    [-43.23016718029975, -22.91159216999324],
    [-43.230695575475686, -22.91240592161791]
  ];

  group('GeoJSONLineString', () {
    test('creates an instance using fromMap', () {
      final data = {
        'type': 'LineString',
        'coordinates': lineStringCoordinates,
      };

      final geoJsonLineString = GeoJSONLineString.fromMap(data);

      expect(geoJsonLineString.type, GeoJSONType.lineString);
      expect(geoJsonLineString.coordinates, lineStringCoordinates);
    });

    test('returns a map representation of an object created by the constructor',
        () {
      final expectedMap = {
        'type': GeoJSONType.lineString.value,
        'coordinates': lineStringCoordinates,
      };

      final geoJsonLineString = GeoJSONLineString(lineStringCoordinates);

      expect(geoJsonLineString.toMap(), expectedMap);
    });

    test('creates an instance using fromJSON', () {
      final data =
          '{"type": "LineString", "coordinates": $lineStringCoordinates}';

      final geoJsonLineString = GeoJSONLineString.fromJSON(data);

      expect(geoJsonLineString.type, GeoJSONType.lineString);
      expect(geoJsonLineString.coordinates, lineStringCoordinates);
    });

    test('calculates the distance of a given line string', () {
      final expectedDistance = 345.91;
      final precision = 1.0;

      final geoJsonLineString = GeoJSONLineString(lineStringCoordinates);

      expect(
        geoJsonLineString.distance,
        inInclusiveRange(
            expectedDistance - precision, expectedDistance + precision),
      );
    });

    test('returns the bounding box of a given line string', () {
      final expectedBbox = [
        -43.230695575475686,
        -22.912718759177814,
        -43.229606598615646,
        -22.91159216999324
      ];

      final geoJsonLineString = GeoJSONLineString(lineStringCoordinates);

      expect(geoJsonLineString.bbox, expectedBbox);
    });
  });
}

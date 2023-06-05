import 'package:geojson_vi/geojson_vi.dart';
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
    test('creates an instance using fromMap', () {
      final data = {
        'type': 'Polygon',
        'coordinates': expectedPolygonCoordinates,
      };

      final geoJsonPolygon = GeoJSONPolygon.fromMap(data);

      expect(geoJsonPolygon.type, GeoJSONType.polygon);
      expect(geoJsonPolygon.coordinates, expectedPolygonCoordinates);
    });

    test('returns a map representation of an object created by the constructor',
        () {
      final expectedMap = {
        'type': GeoJSONType.polygon.value,
        'coordinates': expectedPolygonCoordinates,
      };

      final geoJsonPolygon = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(geoJsonPolygon.toMap(), expectedMap);
    });

    test('calculates the area of a given polygon', () {
      final expectedArea = 7113.80;
      final precision = 0.01;

      final geoJsonPolygon = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(
        geoJsonPolygon.area,
        inInclusiveRange(expectedArea - precision, expectedArea + precision),
      );
    });

    test('returns the bounding box of a given polygon', () {
      final expectedBbox = [
        -43.230695575475686,
        -22.912718759177814,
        -43.229606598615646,
        -22.91159216999324
      ];

      final geoJsonPolygon = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(geoJsonPolygon.bbox, expectedBbox);
    });

    test('calculates the perimeter of a given polygon', () {
      final expectedPerimeter = 345.91;
      final precision = 0.01;

      final geoJsonPolygon = GeoJSONPolygon(expectedPolygonCoordinates);

      expect(
        geoJsonPolygon.perimeter,
        inInclusiveRange(
            expectedPerimeter - precision, expectedPerimeter + precision),
      );
    });

    test('calculates the centroid correctly', () {
      final polygon = GeoJSONPolygon([
        [
          [105.75844517033448, 21.08115157318212],
          [105.77613146171272, 21.08115157318212],
          [105.77613146171272, 21.09802265821532],
          [105.7938177531, 21.09802265821532],
          [105.7938177531, 21.06428048815],
          [105.75844517033448, 21.06428048815],
          [105.75844517033448, 21.08115157318212]
        ]
      ]);

      final centroid = polygon.centroid;

      // Verify that the centroid is calculated correctly
      expect(centroid[0], closeTo(105.77907939875072, 1e-6));
      expect(centroid[1], closeTo(21.078340603132883, 1e-6));
    });
    test('calculates the centroid with hole correctly', () {
      final polygon = GeoJSONPolygon([
        [
          [105.75844517033448, 21.08115157318212],
          [105.77613146171272, 21.08115157318212],
          [105.77613146171272, 21.09802265821532],
          [105.7938177531, 21.09802265821532],
          [105.7938177531, 21.06428048815],
          [105.75844517033448, 21.06428048815],
          [105.75844517033448, 21.08115157318212]
        ],
        [
          [105.77390580027557121, 21.07735998643125441],
          [105.78019527759438745, 21.08263503192444333],
          [105.78317094428284406, 21.07364040307066944],
          [105.77390580027557121, 21.07735998643125441]
        ]
      ]);

      final centroid = polygon.centroid;

      // Verify that the centroid is calculated correctly
      expect(centroid[0], closeTo(105.77907939875072, 1e-6));
      expect(centroid[1], closeTo(21.078340603132883, 1e-6));
    });
  });
}

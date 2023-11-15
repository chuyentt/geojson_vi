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

    test('Centroid of Counterclockwise Polygon', () {
      // Define a counterclockwise polygon
      var polygon = GeoJSONPolygon([
        [
          [11.504408, 48.5300738],
          [11.5043411, 48.5298856],
          [11.5045044, 48.5298578],
          [11.5045017, 48.5298478],
          [11.5045637, 48.5298367],
          [11.5045684, 48.5298463],
          [11.5046393, 48.5298347],
          [11.5046361, 48.5298246],
          [11.5047081, 48.5298117],
          [11.5047115, 48.5298221],
          [11.504932, 48.529786],
          [11.5049734, 48.5297792],
          [11.5049843, 48.5298138],
          [11.5049874, 48.5298132],
          [11.5049908, 48.5298222],
          [11.5050429, 48.529814],
          [11.5050458, 48.5298037],
          [11.5050587, 48.5298057],
          [11.5050564, 48.5298166],
          [11.5050881, 48.5298351],
          [11.5050994, 48.5298276],
          [11.5051079, 48.5298343],
          [11.5050971, 48.529842],
          [11.5051094, 48.5298702],
          [11.5051246, 48.5298705],
          [11.5051236, 48.5298803],
          [11.5051092, 48.5298804],
          [11.5050929, 48.529905],
          [11.5051034, 48.5299119],
          [11.505095, 48.5299183],
          [11.505084, 48.5299115],
          [11.5050372, 48.5299177],
          [11.5050653, 48.5299939],
          [11.5049485, 48.5300126],
          [11.5049373, 48.5299829],
          [11.5047937, 48.5300075],
          [11.5047977, 48.5300183],
          [11.5047108, 48.5300322],
          [11.5047074, 48.5300221],
          [11.5046331, 48.5300348],
          [11.5046361, 48.5300432],
          [11.50458, 48.5300531],
          [11.5045767, 48.5300445],
          [11.5044831, 48.5300607],
          [11.504408, 48.5300738]
        ]
      ]);

      // Calculate the centroid
      var centroid = polygon.centroid;

      // Assert the centroid coordinates
      expect(centroid[0], closeTo(11.5047221, 1e-6));
      expect(centroid[1], closeTo(48.5299198, 1e-6));
    });
  });
}

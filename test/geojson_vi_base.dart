import 'dart:io';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('GeoJSON', () {
    final createdFilePath = './test/test_resources/created.geojson';

    void deleteCreatedFile() {
      final createdFile = File(createdFilePath);
      if (createdFile.existsSync()) {
        createdFile.deleteSync();
      }
    }
    setUpAll(deleteCreatedFile);
    tearDownAll(deleteCreatedFile);

    test('load address_41mb.geojson', () async {
      final geoJson =
          await GeoJSON.load('./test/test_resources/address_41mb.geojson');
      expect(geoJson.featureCollection.features.length, 86576);
    });

    test('load data.geojson', () async {
      final geoJson = await GeoJSON.load('./test/test_resources/data.geojson');
      expect(geoJson.featureCollection.features.length, 10);
    });

    test('create', () async {
      final geoJSON = GeoJSON.create(createdFilePath);
      
      // Create a Point geometry from one position
      final geom_point = GeoJSONPoint([105.7743099, 21.0717561]);
      final feature_point = GeoJSONFeature(geom_point);
      feature_point.properties = {
        'marker-color': '#7e7e7e',
        'marker-size': 'medium',
        'marker-symbol': 'college',
        'title': 'Hanoi University of Mining and Geology',
        'department': 'Geoinformation Technology',
        'address':
            'No.18 Vien Street - Duc Thang Ward - Bac Tu Liem District - Ha Noi',
        'url': 'http://humg.edu.vn'
      };
      geoJSON.featureCollection.features.add(feature_point);

      // Create a LineString geometry from array of position
      final geom_line_string = GeoJSONLineString([
        [105.7771289, 21.0715458],
        [105.7745218, 21.0715658],
        [105.7729125, 21.0715358]
      ]);
      final feature_line_string = GeoJSONFeature(geom_line_string);
      feature_line_string.properties = {'key1': 'value 1', 'key2': 10.5};
      geoJSON.featureCollection.features.add(feature_line_string);

      // Create a Polygon geometry from array of position
      final geom_polygon = GeoJSONPolygon([
        [
          [105.7739666, 21.0726795], // The first position
          [105.7739719, 21.0721991],
          [105.7743394, 21.0721966],
          [105.7743310, 21.0725269],
          [105.7742564, 21.0726120],
          [105.7741865, 21.0726095],
          [105.7741785, 21.0726746],
          [105.7739666, 21.0726795] // The last position
        ]
      ]);
      final feature_polygon = GeoJSONFeature(geom_polygon);
      feature_polygon.properties = {'key1': 'test', 'key2': 5};
      geoJSON.featureCollection.features.add(feature_polygon);

      await geoJSON.save();

      final geoJsonFromFile = await GeoJSON.load(createdFilePath);

      expect(geoJSON, geoJsonFromFile);
    });

    test('fromString', () {
      final path = './test/test_resources/address_41mb.geojson';
      final data = File(path).readAsStringSync();
      final geoJson = GeoJSON.fromString(data);
      expect(geoJson.featureCollection.features.length, 86576);
    });
  });
}

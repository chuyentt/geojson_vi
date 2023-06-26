import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('GeoJSONFeature', () {
    final expectedTitle = 'Example of Title';
    final expectedId = 'id1';
    final expectedProperties = {
      'key1': 'value for key 1',
      'key2': 'value for key 2',
      'key3': 'value for key 3'
    };
    final expectedBbox = [-43.230695, -22.912718, -43.229606, -22.911592];

    GeoJSONFeature? feature;

    setUp(() {
      final expectedMap = {
        'type': 'Feature',
        'id': expectedId,
        'properties': expectedProperties,
        'bbox': expectedBbox,
        'title': expectedTitle,
        'geometry': {
          'type': 'Polygon',
          'coordinates': [
            [
              [-43.230695, -22.912405],
              [-43.230128, -22.912718],
              [-43.229606, -22.911900],
              [-43.230167, -22.911592],
              [-43.230695, -22.912405]
            ]
          ]
        }
      };

      feature = GeoJSONFeature.fromMap(expectedMap);
    });

    test('create a feature from a defined map', () {
      expect(feature!.title, expectedTitle);
      expect(feature!.id, expectedId);
      expect(feature!.properties, expectedProperties);
      expect(feature!.bbox, expectedBbox);
      expect(feature!.type.value, 'Feature');
    });

    test('convert feature to map', () {
      final map = feature!.toMap();

      expect(map['type'], 'Feature');
      expect(map['id'], expectedId);
      expect(map['properties'], expectedProperties);
      expect(map['bbox'], expectedBbox);
      expect(map['title'], expectedTitle);
      expect(map['geometry']['type'], 'Polygon');
      expect(map['geometry']['coordinates'], [
        [
          [-43.230695, -22.912405],
          [-43.230128, -22.912718],
          [-43.229606, -22.911900],
          [-43.230167, -22.911592],
          [-43.230695, -22.912405]
        ]
      ]);
    });

    test('convert feature to JSON', () {
      final json = feature!.toJSON();

      final expectedJson =
          '{"type":"Feature","id":"id1","title":"Example of Title","properties":{"key1":"value for key 1","key2":"value for key 2","key3":"value for key 3"},"geometry":{"type":"Polygon","coordinates":[[[-43.230695,-22.912405],[-43.230128,-22.912718],[-43.229606,-22.9119],[-43.230167,-22.911592],[-43.230695,-22.912405]]]},"bbox":[-43.230695,-22.912718,-43.229606,-22.911592]}';

      expect(json, expectedJson);
    });

    test('equality', () {
      final expectedMap2 = {
        'type': 'Feature',
        'id': expectedId,
        'properties': expectedProperties,
        'bbox': expectedBbox,
        'title': expectedTitle,
        'geometry': {
          'type': 'Polygon',
          'coordinates': [
            [
              [-43.230695, -22.912405],
              [-43.230128, -22.912718],
              [-43.229606, -22.911900],
              [-43.230167, -22.911592],
              [-43.230695, -22.912405]
            ]
          ]
        }
      };
      final feature2 = GeoJSONFeature.fromMap(expectedMap2);

      expect(feature == feature2, true);
    });

    test('inequality - different properties', () {
      final expectedProperties2 = {
        'key1': 'different value',
        'key2': 'value for key 2',
        'key3': 'value for key 3'
      };
      final expectedMap2 = {
        'type': 'Feature',
        'id': expectedId,
        'properties': expectedProperties2,
        'bbox': expectedBbox,
        'title': expectedTitle,
        'geometry': {
          'type': 'Polygon',
          'coordinates': [
            [
              [-43.230695, -22.912405],
              [-43.230128, -22.912718],
              [-43.229606, -22.911900],
              [-43.230167, -22.911592],
              [-43.230695, -22.912405]
            ]
          ]
        }
      };
      final feature2 = GeoJSONFeature.fromMap(expectedMap2);

      expect(feature == feature2, false);
    });

    test('inequality - different geometry', () {
      final expectedMap2 = {
        'type': 'Feature',
        'id': expectedId,
        'properties': expectedProperties,
        'bbox': expectedBbox,
        'title': expectedTitle,
        'geometry': {
          'type': 'Point',
          'coordinates': [-43.230695, -22.912405]
        }
      };
      final feature2 = GeoJSONFeature.fromMap(expectedMap2);

      expect(feature == feature2, false);
    });
  });
}

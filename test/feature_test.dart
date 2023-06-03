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

    // You can replicate the similar changes for the other test cases
    // ...
  });
}

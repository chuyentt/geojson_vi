import 'dart:convert';
import 'dart:io';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final fakePos = [105.77389, 21.0720414];

  group('GeoJSON', () {
    test('creates an instance from Map for type FeatureCollection', () {
      final data = {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'properties': {
              'title': 'Hanoi University of Mining and Geology',
              'country': 'Vietnam'
            },
            'geometry': {'type': 'Point', 'coordinates': fakePos},
            'bbox': [105.77389, 21.0720414, 105.77389, 21.0720414]
          }
        ]
      };
      final geoJSON = GeoJSON.fromMap(data) as GeoJSONFeatureCollection;
      expect(geoJSON.type, GeoJSONType.featureCollection);
      expect(geoJSON.features.length, 1);
      expect(geoJSON.toMap(), data);
      expect(geoJSON.toJSON(), json.encode(data));
    });

    test('creates an instance from JSON for type FeatureCollection', () {
      final data =
          '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]},"bbox":[105.77389,21.0720414,105.77389,21.0720414]}]}';
      final geoJSON = GeoJSON.fromJSON(data) as GeoJSONFeatureCollection;
      expect(geoJSON.type, GeoJSONType.featureCollection);
      expect(geoJSON.features.length, 1);
      expect(geoJSON.toMap(), json.decode(data));
      expect(geoJSON.toJSON(), data);
    });

    test('creates an instance from JSON file for type FeatureCollection', () {
      final data =
          File('./test/test_resources/issue_13.geojson').readAsStringSync();
      final geoJSON = GeoJSON.fromJSON(data);
      expect(geoJSON.toMap(), json.decode(data));
    });

    test('creates an instance from Map for type Feature', () {
      final data = {
        'type': 'Feature',
        'properties': {
          'title': 'Hanoi University of Mining and Geology',
          'country': 'Vietnam'
        },
        'geometry': {'type': 'Point', 'coordinates': fakePos},
        'bbox': [105.77389, 21.0720414, 105.77389, 21.0720414]
      };
      final geoJSON = GeoJSON.fromMap(data) as GeoJSONFeature;
      expect(geoJSON.type, GeoJSONType.feature);
      expect(geoJSON.toMap(), data);
      expect(geoJSON.toJSON(), json.encode(data));
    });

    test('creates an instance from JSON for type Feature', () {
      final data =
          '{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]},"bbox":[105.77389,21.0720414,105.77389,21.0720414]}';
      final geoJSON = GeoJSON.fromJSON(data) as GeoJSONFeature;
      expect(geoJSON.type, GeoJSONType.feature);
      expect(geoJSON.toMap(), json.decode(data));
      expect(geoJSON.toJSON(), data);
    });
  });
}

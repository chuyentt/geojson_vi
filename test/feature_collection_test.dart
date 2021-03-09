import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('GeoJSONFeatureCollection', () {
    final expectedMap = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {'prop0': 'value0'},
          'bbox': [102.0, 0.5, 102.0, 0.5],
          'geometry': {
            'type': 'Point',
            'coordinates': [102.0, 0.5]
          }
        },
        {
          'type': 'Feature',
          'properties': {'prop0': 'value0', 'prop1': 0.0},
          'bbox': [102.0, 0.0, 105.0, 1.0],
          'geometry': {
            'type': 'LineString',
            'coordinates': [
              [102.0, 0.0],
              [103.0, 1.0],
              [104.0, 0.0],
              [105.0, 1.0]
            ]
          },
        },
        {
          'type': 'Feature',
          'properties': {'prop0': 'value0'},
          'bbox': [100.0, 0.0, 101.0, 1.0],
          'geometry': {
            'type': 'Polygon',
            'coordinates': [
              [
                [100.0, 0.0],
                [101.0, 0.0],
                [101.0, 1.0],
                [100.0, 1.0],
                [100.0, 0.0]
              ]
            ]
          },
        }
      ]
    };

    test('create instance from map', () {
      final featureCollection = GeoJSONFeatureCollection.fromMap(expectedMap);
      expect(featureCollection.features.length, 3);
    });

    test('toMap from an existing instance', () {
      final featureCollection = GeoJSONFeatureCollection.fromMap(expectedMap);
      expect(featureCollection.toMap(), expectedMap);
    });

    test('toString from an existing instance', () {
      final expectedString = jsonEncode(expectedMap);
      final featureCollection = GeoJSONFeatureCollection.fromMap(expectedMap);
      expect(featureCollection.toString(), expectedString);
    });
  });
}

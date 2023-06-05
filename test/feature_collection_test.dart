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
          'geometry': {
            'type': 'Point',
            'coordinates': [102.0, 0.5]
          }
        },
        {
          'type': 'Feature',
          'properties': {'prop0': 'value0', 'prop1': 0.0},
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
      expect(featureCollection.toJSON(), expectedString);
    });

    test('creates featureCollection with an existing feature', () {
      final point = GeoJSONPoint([105.780701, 21.067921]);

      final pointFeature = GeoJSONFeature(point);
      pointFeature.properties = {
        'title': 'Hanoi University of Mining and Geology',
        'url': 'http://humg.edu.vn',
      };

      final featureColl = GeoJSONFeatureCollection([pointFeature]);

      expect(featureColl.features.length, 1);
    });

    test('adds a new feature to an existing featurecollection', () {
      final point = GeoJSONPoint([105.780701, 21.067921]);

      final pointFeature = GeoJSONFeature(point);
      pointFeature.properties = {
        'title': 'Hanoi University of Mining and Geology',
        'url': 'http://humg.edu.vn',
      };

      var featureColl = GeoJSONFeatureCollection([pointFeature]);

      final polygonCoordinates = [
        [
          [104.765625, 20.468189],
          [106.545410, 20.468189],
          [106.545410, 21.596150],
          [104.765625, 21.596150],
          [104.765625, 20.468189]
        ]
      ];

      final polygon = GeoJSONPolygon(polygonCoordinates);
      final polygonFeature = GeoJSONFeature(polygon);
      featureColl.features.add(polygonFeature);

      expect(featureColl.features.length, 2);
    });

    test('creates an emtpy featurecollection and adds features', () {
      var featureColl = GeoJSONFeatureCollection([]);

      final point = GeoJSONPoint([105.780701, 21.067921]);

      final pointFeature = GeoJSONFeature(point);
      pointFeature.properties = {
        'title': 'Hanoi University of Mining and Geology',
        'url': 'http://humg.edu.vn',
      };

      final polygonCoordinates = [
        [
          [104.765625, 20.468189],
          [106.545410, 20.468189],
          [106.545410, 21.596150],
          [104.765625, 21.596150],
          [104.765625, 20.468189]
        ]
      ];

      featureColl.features.add(pointFeature);

      final polygon = GeoJSONPolygon(polygonCoordinates);
      final polygonFeature = GeoJSONFeature(polygon);
      featureColl.features.add(polygonFeature);

      expect(featureColl.features.length, 2);
    });

    test('Find nearest feature', () {
      // Assume we have a list of GeoJSONFeature objects
      final featureCollection = GeoJSONFeatureCollection.fromMap(expectedMap);

      // Define a point to find the nearest feature to
      var lat = 101.0;
      var lon = 0.5;

      // Call the findNearestFeature function
      var nearestFeature = featureCollection.findNearestFeature(lat, lon);

      // Check the result
      expect(nearestFeature, isNotNull); // Check that a feature was found
      expect(nearestFeature!.geometry.type,
          GeoJSONType.lineString); // Check the type of the feature
      var coords = (nearestFeature.geometry as GeoJSONLineString).coordinates;
      expect(coords, [
        [102.0, 0.0],
        [103.0, 1.0],
        [104.0, 0.0],
        [105.0, 1.0]
      ]); // Check that the correct feature was found
    });
  });
}

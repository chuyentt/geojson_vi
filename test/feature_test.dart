import 'dart:convert';

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

    test('create a feature from a defined map', () {
      final feature = GeoJSONFeature.fromMap(expectedMap);

      expect(feature.title, expectedTitle);
      expect(feature.id, expectedId);
      expect(feature.properties, expectedProperties);
      expect(feature.bbox, expectedBbox);
      expect(feature.type.name, 'Feature');
    });

    test(
        'when geometry is a Point, geometrySerialize returns a map of GeoJSONPoint',
        () {
      final expectedGeometrySerialize = {'type': 'Point', 'coordinates': []};
      final expectedMap = {
        'type': 'Feature',
        'geometry': expectedGeometrySerialize
      };
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.geometrySerialize, expectedGeometrySerialize);
    });

    test(
        'when geometry is a LineString, geometrySerialize returns a map of GeoJSONLineString',
        () {
      final expectedGeometrySerialize = {
        'type': 'LineString',
        'coordinates': []
      };
      final expectedMap = {
        'type': 'Feature',
        'geometry': expectedGeometrySerialize
      };
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.geometrySerialize, expectedGeometrySerialize);
    });

    test(
        'geometry is MultiPoint, geometrySerialize returns a map of GeoJSONMultiPoint',
        () {
      final expectedGeometrySerialize = {
        'type': 'MultiPoint',
        'coordinates': []
      };
      final expectedMap = {
        'type': 'Feature',
        'geometry': expectedGeometrySerialize
      };
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.geometrySerialize, expectedGeometrySerialize);
    });

    test(
        'geometry is Polygon, geometrySerialize returns a map of GeoJSONPolygon',
        () {
      final expectedGeometrySerialize = {'type': 'Polygon', 'coordinates': []};
      final expectedMap = {
        'type': 'Feature',
        'geometry': expectedGeometrySerialize
      };
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.geometrySerialize, expectedGeometrySerialize);
    });

    test(
        'geometry is MultiLineString, geometrySerialize returns a map of GeoJSONMultiLineString',
        () {
      final expectedGeometrySerialize = {
        'type': 'MultiLineString',
        'coordinates': []
      };
      final expectedMap = {
        'type': 'Feature',
        'geometry': expectedGeometrySerialize
      };
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.geometrySerialize, expectedGeometrySerialize);
    });

    test(
        'geometry is MultiPolygon, geometrySerialize returns a map of GeoJSONMultiPolygon',
        () {
      final expectedGeometrySerialize = {
        'type': 'MultiPolygon',
        'coordinates': []
      };
      final expectedMap = {
        'type': 'Feature',
        'geometry': expectedGeometrySerialize
      };
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.geometrySerialize, expectedGeometrySerialize);
    });

    // depends on PR: https://github.com/chuyentt/geojson_vi/pull/7
    // test(
    //     'geometry is GeometryCollection, geometrySerialize returns a map of GeoJSONGeometryCollection',
    //     () {
    //   final expectedGeometrySerialize = {
    //     'type': 'GeometryCollection',
    //     'geometries': []
    //   };
    //   final expectedMap = {
    //     'type': 'Feature',
    //     'geometry': expectedGeometrySerialize
    //   };
    //   final feature = GeoJSONFeature.fromMap(expectedMap);
    //   expect(feature.geometrySerialize, expectedGeometrySerialize);
    // });

    test('toMap from a defined feature', () {
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.toMap(), expectedMap);
    });

    test('toString from a defined feature', () {
      final expectedString = jsonEncode(expectedMap);
      final feature = GeoJSONFeature.fromMap(expectedMap);
      expect(feature.toString(), expectedString);
    });
  });
}

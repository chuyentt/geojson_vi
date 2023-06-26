import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('GeoJSONGeometryCollection', () {
    final expectedMap = {
      'type': 'GeometryCollection',
      'geometries': [
        {
          'type': 'Point',
          'coordinates': [-43.230695, -22.912405]
        },
        {
          'type': 'MultiPoint',
          'coordinates': [
            [-43.230695, -22.912405],
            [-43.230128, -22.912718]
          ]
        },
        {
          'type': 'LineString',
          'coordinates': [
            [-43.230695, -22.912405],
            [-43.230128, -22.912718]
          ],
        },
        {
          'type': 'MultiLineString',
          'coordinates': [
            [
              [-43.230695, -22.912405],
              [-43.230128, -22.912718],
              [-43.229606, -22.911900],
              [-43.230167, -22.911592],
              [-43.230695, -22.912405]
            ]
          ]
        },
        {
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
        },
        {
          'type': 'MultiPolygon',
          'coordinates': [
            [
              [
                [102.0, 2.0],
                [103.0, 2.0],
                [103.0, 3.0],
                [102.0, 3.0],
                [102.0, 2.0]
              ]
            ],
            [
              [
                [100.0, 0.0],
                [101.0, 0.0],
                [101.0, 1.0],
                [100.0, 1.0],
                [100.0, 0.0]
              ],
              [
                [100.2, 0.2],
                [100.8, 0.2],
                [100.8, 0.8],
                [100.2, 0.8],
                [100.2, 0.2]
              ]
            ]
          ]
        },
        {
          'type': 'GeometryCollection',
          'geometries': [
            {
              'type': 'Point',
              'coordinates': [-43.230695, -22.912405]
            },
            {
              'type': 'MultiPoint',
              'coordinates': [
                [-43.230695, -22.912405],
                [-43.230128, -22.912718]
              ]
            },
            {
              'type': 'LineString',
              'coordinates': [
                [-43.230695, -22.912405],
                [-43.230128, -22.912718]
              ],
            },
            {
              'type': 'MultiLineString',
              'coordinates': [
                [
                  [-43.230695, -22.912405],
                  [-43.230128, -22.912718],
                  [-43.229606, -22.911900],
                  [-43.230167, -22.911592],
                  [-43.230695, -22.912405]
                ]
              ]
            },
            {
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
            },
            {
              'type': 'MultiPolygon',
              'coordinates': [
                [
                  [
                    [102.0, 2.0],
                    [103.0, 2.0],
                    [103.0, 3.0],
                    [102.0, 3.0],
                    [102.0, 2.0]
                  ]
                ],
                [
                  [
                    [100.0, 0.0],
                    [101.0, 0.0],
                    [101.0, 1.0],
                    [100.0, 1.0],
                    [100.0, 0.0]
                  ],
                  [
                    [100.2, 0.2],
                    [100.8, 0.2],
                    [100.8, 0.8],
                    [100.2, 0.8],
                    [100.2, 0.2]
                  ]
                ]
              ]
            }
          ]
        }
      ]
    };

    test('creates an instance via fromMap', () {
      final geometryCollection = GeoJSONGeometryCollection.fromMap(expectedMap);
      expect(geometryCollection.geometries.length, 7);
    });

    test('toMap returns map with geometries', () {
      final geometryCollection = GeoJSONGeometryCollection.fromMap(expectedMap);
      expect(geometryCollection.toMap(), expectedMap);
    });

    test(
        'toString returns collection of key/value pairs of geospatial data as String',
        () {
      final expectedString = jsonEncode(expectedMap);
      final geometryCollection = GeoJSONGeometryCollection.fromMap(expectedMap);
      expect(geometryCollection.toJSON(), expectedString);
    });

    test('creates an instance with empty geometries array', () {
      final emptyMap = {'type': 'GeometryCollection', 'geometries': []};
      final geometryCollection = GeoJSONGeometryCollection.fromMap(emptyMap);
      expect(geometryCollection.geometries.length, 0);
    });

    test('handles adding a geometry to an empty GeometryCollection', () {
      final point = {
        'type': 'Point',
        'coordinates': [-43.230695, -22.912405]
      };

      var geometryCollection = GeoJSONGeometryCollection.fromMap(
          {'type': 'GeometryCollection', 'geometries': []});

      geometryCollection.geometries.add(GeoJSONGeometry.fromMap(point));
      expect(geometryCollection.geometries.length, 1);
    });

    test('converts to an empty geometries JSON correctly', () {
      var geometryCollection = GeoJSONGeometryCollection([]);

      expect(geometryCollection.toJSON(),
          '{"type":"GeometryCollection","geometries":[]}');
    });

    test('checks equality of GeometryCollection objects', () {
      final geometryCollection1 =
          GeoJSONGeometryCollection.fromMap(expectedMap);
      final geometryCollection2 =
          GeoJSONGeometryCollection.fromMap(expectedMap);
      final geometryCollection3 = GeoJSONGeometryCollection([]);

      expect(geometryCollection1 == geometryCollection2, true);
      expect(geometryCollection1 == geometryCollection3, false);
    });

    test('checks hashCode of GeometryCollection objects', () {
      final geometryCollection1 =
          GeoJSONGeometryCollection.fromMap(expectedMap);
      final geometryCollection2 =
          GeoJSONGeometryCollection.fromMap(expectedMap);

      expect(
          geometryCollection1.hashCode == geometryCollection2.hashCode, true);
    });
  });
}

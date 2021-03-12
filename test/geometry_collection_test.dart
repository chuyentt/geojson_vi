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
  });
}

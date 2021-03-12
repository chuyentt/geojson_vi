import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('GeoJSONGeometry', () {
    test('given a dataMap with type Point, it returns GeoJSONPoint', () {
      final data = {
        'type': 'Point',
        'coordinates': [-43.230695, -22.912405]
      };
      final geoJson = GeoJSONGeometry.fromMap(data);
      expect(geoJson.type.value, 'Point');
      expect(geoJson.runtimeType, GeoJSONPoint);
    });

    test('given a dataMap with type MultiPoint, it returns GeoJSONMultiPoint',
        () {
      final data = {
        'type': 'MultiPoint',
        'coordinates': [
          [-43.230695, -22.912405],
          [-43.230128, -22.912718]
        ]
      };
      final geoJson = GeoJSONGeometry.fromMap(data);
      expect(geoJson.type.value, 'MultiPoint');
      expect(geoJson.runtimeType, GeoJSONMultiPoint);
    });

    test('given a dataMap with type LineString, it returns GeoJSONLineString',
        () {
      final data = {
        'type': 'LineString',
        'coordinates': [
          [-43.230695, -22.912405],
          [-43.230128, -22.912718]
        ]
      };
      final geoJson = GeoJSONGeometry.fromMap(data);
      expect(geoJson.type.value, 'LineString');
      expect(geoJson.runtimeType, GeoJSONLineString);
    });

    test(
        'given a dataMap with type MultiLineString, it returns GeoJSONMultiLineString',
        () {
      final data = {
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
      };
      final geoJson = GeoJSONGeometry.fromMap(data);
      expect(geoJson.type.value, 'MultiLineString');
      expect(geoJson.runtimeType, GeoJSONMultiLineString);
    });

    test('given a dataMap with type Polygon, it returns GeoJSONPolygon', () {
      final data = {
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
      };
      final geoJson = GeoJSONGeometry.fromMap(data);
      expect(geoJson.type.value, 'Polygon');
      expect(geoJson.runtimeType, GeoJSONPolygon);
    });

    test(
        'given a dataMap with type GeometryCollection, it returns GeoJSONGeometryCollection',
        () {
      final data = {
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
      };
      final geoJson = GeoJSONGeometry.fromMap(data);
      expect(geoJson.type.value, 'GeometryCollection');
      expect(geoJson.runtimeType, GeoJSONGeometryCollection);
    });
  });
}

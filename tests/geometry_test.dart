import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('Geometry', () {
    test('given a dataMap with type Point, it returns GeoJSONPoint', () {
      final geoJson = Geometry.fromMap({'type': 'Point', 'coordinates': []});
      expect(geoJson.type.name, 'Point');
      expect(geoJson.runtimeType, GeoJSONPoint);
    });

    test('given a dataMap with type MultiPoint, it returns GeoJSONMultiPoint',
        () {
      final geoJson =
          Geometry.fromMap({'type': 'MultiPoint', 'coordinates': []});
      expect(geoJson.type.name, 'MultiPoint');
      expect(geoJson.runtimeType, GeoJSONMultiPoint);
    });

    test('given a dataMap with type LineString, it returns GeoJSONLineString',
        () {
      final geoJson =
          Geometry.fromMap({'type': 'LineString', 'coordinates': []});
      expect(geoJson.type.name, 'LineString');
      expect(geoJson.runtimeType, GeoJSONLineString);
    });

    test(
        'given a dataMap with type MultiLineString, it returns GeoJSONMultiLineString',
        () {
      final geoJson =
          Geometry.fromMap({'type': 'MultiLineString', 'coordinates': []});
      expect(geoJson.type.name, 'MultiLineString');
      expect(geoJson.runtimeType, GeoJSONMultiLineString);
    });

    test('given a dataMap with type Polygon, it returns GeoJSONPolygon', () {
      final geoJson = Geometry.fromMap({'type': 'Polygon', 'coordinates': []});
      expect(geoJson.type.name, 'Polygon');
      expect(geoJson.runtimeType, GeoJSONPolygon);
    });

    test(
        'given a dataMap with type GeometryCollection, it returns GeoJSONGeometryCollection',
        () {
      final geoJson =
          Geometry.fromMap({'type': 'GeometryCollection', 'geometries': []});
      expect(geoJson.type.name, 'GeometryCollection');
      expect(geoJson.runtimeType, GeoJSONGeometryCollection);
    });
  });
}

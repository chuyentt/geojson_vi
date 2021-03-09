import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('Geometry', () {
    test('given a dataMap with type Point, it returns GeoJSONPoint', () {
      final data = {'type': 'Point', 'coordinates': []};
      final geoJson = Geometry.fromMap(data);
      expect(geoJson.type.name, 'Point');
      expect(geoJson.runtimeType, GeoJSONPoint);
    });

    test('given a dataMap with type MultiPoint, it returns GeoJSONMultiPoint',
        () {
      final data = {'type': 'MultiPoint', 'coordinates': []};
      final geoJson = Geometry.fromMap(data);
      expect(geoJson.type.name, 'MultiPoint');
      expect(geoJson.runtimeType, GeoJSONMultiPoint);
    });

    test('given a dataMap with type LineString, it returns GeoJSONLineString',
        () {
      final data = {'type': 'LineString', 'coordinates': []};
      final geoJson = Geometry.fromMap(data);
      expect(geoJson.type.name, 'LineString');
      expect(geoJson.runtimeType, GeoJSONLineString);
    });

    test(
        'given a dataMap with type MultiLineString, it returns GeoJSONMultiLineString',
        () {
      final data = {'type': 'MultiLineString', 'coordinates': []};
      final geoJson = Geometry.fromMap(data);
      expect(geoJson.type.name, 'MultiLineString');
      expect(geoJson.runtimeType, GeoJSONMultiLineString);
    });

    test('given a dataMap with type Polygon, it returns GeoJSONPolygon', () {
      final data = {'type': 'Polygon', 'coordinates': []};
      final geoJson = Geometry.fromMap(data);
      expect(geoJson.type.name, 'Polygon');
      expect(geoJson.runtimeType, GeoJSONPolygon);
    });

    test(
        'given a dataMap with type GeometryCollection, it returns GeoJSONGeometryCollection',
        () {
      final data = {'type': 'GeometryCollection', 'geometries': []};
      final geoJson = Geometry.fromMap(data);
      expect(geoJson.type.name, 'GeometryCollection');
      expect(geoJson.runtimeType, GeoJSONGeometryCollection);
    });
  });
}

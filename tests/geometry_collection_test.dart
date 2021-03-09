import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  final expectedMap = {
    'type': 'GeometryCollection',
    'geometries': [
      {'type': 'Point', 'coordinates': []},
      {'type': 'Point', 'coordinates': []},
      {'type': 'MultiPoint', 'coordinates': []},
      {'type': 'LineString', 'coordinates': []},
      {'type': 'MultiLineString', 'coordinates': []},
      {'type': 'Polygon', 'coordinates': []},
      {'type': 'MultiPolygon', 'coordinates': []},
      {'type': 'GeometryCollection', 'geometries': []}
    ]
  };

  test('creates an instance via fromMap', () {
    final geometryCollection = GeoJSONGeometryCollection.fromMap(expectedMap);
    expect(geometryCollection.geometries.length, 8);
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
    expect(geometryCollection.toString(), expectedString);
  });
}

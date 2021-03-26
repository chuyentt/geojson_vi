import 'dart:convert';

import '../geojson_vi.dart';

/// GeoJSON - A geospatial data interchange format
abstract class GeoJSON {
  /// The GeometryType [type] must be initialized.
  late final GeoJSONType type;

  /// Bounding Box
  ///
  /// Returns array of double values [west, south, east, north]
  List<double>? get bbox;

  /// The constructor from map
  factory GeoJSON.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(
        [
          'FeatureCollection',
          'Feature',
          'Point',
          'MultiPoint',
          'LineString',
          'MultiLineString',
          'Polygon',
          'MultiPolygon',
          'GeometryCollection'
        ].contains(map['type']),
        'Invalid type');

    final _type = map['type'];
    late var _instance;
    switch (_type) {
      case 'FeatureCollection':
        _instance = GeoJSONFeatureCollection.fromMap(map);
        break;
      case 'Feature':
        _instance = GeoJSONFeature.fromMap(map);
        break;
      case 'Point':
        _instance = GeoJSONPoint.fromMap(map);
        break;
      case 'MultiPoint':
        _instance = GeoJSONMultiPoint.fromMap(map);
        break;
      case 'LineString':
        _instance = GeoJSONLineString.fromMap(map);
        break;
      case 'MultiLineString':
        _instance = GeoJSONMultiLineString.fromMap(map);
        break;
      case 'Polygon':
        _instance = GeoJSONPolygon.fromMap(map);
        break;
      case 'MultiPolygon':
        _instance = GeoJSONMultiPolygon.fromMap(map);
        break;
      case 'GeometryCollection':
        _instance = GeoJSONGeometryCollection.fromMap(map);
        break;
    }
    return _instance;
  }

  /// The constructor from JSON string
  factory GeoJSON.fromJSON(String source) =>
      GeoJSON.fromMap(json.decode(source));

  /// Converts GeoJSON to a Map
  Map<String, dynamic> toMap();

  /// Encodes GeoJSON to JSON string
  String toJSON();

  @override
  String toString() => 'GeoJSON(type: $type)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONGeometry && o.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

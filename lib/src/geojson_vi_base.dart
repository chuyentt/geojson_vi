import 'dart:convert';
import 'dart:io';

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

    final _type = ExtGeoJSONType.fromString(map['type']);
    late var _instance;
    switch (_type!) {
      case GeoJSONType.featureCollection:
        _instance = GeoJSONFeatureCollection.fromMap(map);
        break;
      case GeoJSONType.feature:
        _instance = GeoJSONFeature.fromMap(map);
        break;
      case GeoJSONType.point:
        _instance = GeoJSONPoint.fromMap(map);
        break;
      case GeoJSONType.multiPoint:
        _instance = GeoJSONMultiPoint.fromMap(map);
        break;
      case GeoJSONType.lineString:
        _instance = GeoJSONLineString.fromMap(map);
        break;
      case GeoJSONType.multiLineString:
        _instance = GeoJSONMultiLineString.fromMap(map);
        break;
      case GeoJSONType.polygon:
        _instance = GeoJSONPolygon.fromMap(map);
        break;
      case GeoJSONType.multiPolygon:
        _instance = GeoJSONMultiPolygon.fromMap(map);
        break;
      case GeoJSONType.geometryCollection:
        _instance = GeoJSONGeometryCollection.fromMap(map);
        break;
    }
    return _instance;
  }

  /// The constructor from JSON string
  factory GeoJSON.fromJSON(String source) =>
      GeoJSON.fromMap(json.decode(source));

  /// Load GeoJSON from file with file path
  static Future<GeoJSON> load(String path) async {
    return await _GeoJSON._load(path);
  }

  /// Save GeoJSON to file with file path
  Future<File> save(String path) async {
    var file = File(path);
    return file.writeAsString(toJSON());
  }

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

abstract class _GeoJSON implements GeoJSON {
  /// Private load
  static Future<GeoJSON> _load(String path) async {
    var file = File(path);
    assert(await file.exists(), 'File "$path" not found!');

    /// Read file as string
    final data = await file.readAsString();
    var map = json.decode(data);
    final geoJSON = GeoJSON.fromMap(map);
    return geoJSON;
  }
}

import '../helpers.dart';

import 'point.dart';
import 'multi_point.dart';
import 'line_string.dart';
import 'multi_line_string.dart';
import 'polygon.dart';
import 'multi_polygon.dart';
import 'geometry_collection.dart';

/// Geometry type
enum GeometryType {
  point,
  multiPoint,
  lineString,
  multiLineString,
  polygon,
  multiPolygon,
  geometryCollection
}

extension GeometryTypeExtension on GeometryType {
  String get name {
    switch (this) {
      case GeometryType.point:
        return 'Point';
      case GeometryType.multiPoint:
        return 'MultiPoint';
      case GeometryType.lineString:
        return 'LineString';
      case GeometryType.multiLineString:
        return 'MultiLineString';
      case GeometryType.polygon:
        return 'Polygon';
      case GeometryType.multiPolygon:
        return 'MultiPolygon';
      case GeometryType.geometryCollection:
        return 'GeometryCollection';
      default:
        return null;
    }
  }
}

abstract class Geometry {
  GeometryType get type;

  double get area;

  factory Geometry.fromMap(Map data) {
    GeometryType type = enumFromString(data['type'], GeometryType);
    switch (type) {
      case GeometryType.point:
        return GeoJSONPoint.fromMap(data);
      case GeometryType.multiPoint:
        return GeoJSONMultiPoint.fromMap(data);
      case GeometryType.lineString:
        return GeoJSONLineString.fromMap(data);
      case GeometryType.multiLineString:
        return GeoJSONMultiLineString.fromMap(data);
      case GeometryType.polygon:
        return GeoJSONPolygon.fromMap(data);
      case GeometryType.multiPolygon:
        return GeoJSONMultiPolygon.fromMap(data);
      case GeometryType.geometryCollection:
        return GeoJSONGeometryCollection.fromMap(data);
    }
    return null;
  }

  Map<String, dynamic> get toMap;
}

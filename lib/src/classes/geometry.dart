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
  List<double> get bbox;

  factory Geometry.fromMap(Map data) {
    String type = data['type'];
    switch (type) {
      case 'Point':
        return GeoJSONPoint.fromMap(data);
      case 'MultiPoint':
        return GeoJSONMultiPoint.fromMap(data);
      case 'LineString':
        return GeoJSONLineString.fromMap(data);
      case 'MultiLineString':
        return GeoJSONMultiLineString.fromMap(data);
      case 'Polygon':
        return GeoJSONPolygon.fromMap(data);
      case 'MultiPolygon':
        return GeoJSONMultiPolygon.fromMap(data);
      case 'GeometryCollection':
        return GeoJSONGeometryCollection.fromMap(data);
    }
    return null;
  }

  Map<String, dynamic> get toMap;
}

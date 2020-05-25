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
  final GeometryType type;

  int places = 6;

  Geometry(this.type);

  Map<String, dynamic> toMap();
}
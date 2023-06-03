part of geojson_vi;

/// Enumerates the types of geometry that can be used in a GeoJSON object.
enum GeoJSONType {
  featureCollection,
  feature,
  point,
  multiPoint,
  lineString,
  multiLineString,
  polygon,
  multiPolygon,
  geometryCollection
}

/// Defines extensions on the GeoJSONType enum.
extension ExtGeoJSONType on GeoJSONType {
  /// Gets the string representation of this GeoJSON type.
  String get value {
    var str = '';
    switch (this) {
      case GeoJSONType.featureCollection:
        str = 'FeatureCollection';
        break;
      case GeoJSONType.feature:
        str = 'Feature';
        break;
      case GeoJSONType.point:
        str = 'Point';
        break;
      case GeoJSONType.multiPoint:
        str = 'MultiPoint';
        break;
      case GeoJSONType.lineString:
        str = 'LineString';
        break;
      case GeoJSONType.multiLineString:
        str = 'MultiLineString';
        break;
      case GeoJSONType.polygon:
        str = 'Polygon';
        break;
      case GeoJSONType.multiPolygon:
        str = 'MultiPolygon';
        break;
      case GeoJSONType.geometryCollection:
        str = 'GeometryCollection';
        break;
    }
    return str;
  }
}

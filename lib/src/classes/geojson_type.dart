@Deprecated(
  'Use `GeoJSONType` instead. '
  'Will be removed in the next version.',
)
enum GeometryType {
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

extension ExtGeoJSONType on GeoJSONType {
  @Deprecated('Use `value` instead. Will be removed in the next version')
  String get name => value;

  /// Convert type into String
  String get value {
    var _str = '';
    switch (this) {
      case GeoJSONType.featureCollection:
        _str = 'FeatureCollection';
        break;
      case GeoJSONType.feature:
        _str = 'Feature';
        break;
      case GeoJSONType.point:
        _str = 'Point';
        break;
      case GeoJSONType.multiPoint:
        _str = 'MultiPoint';
        break;
      case GeoJSONType.lineString:
        _str = 'LineString';
        break;
      case GeoJSONType.multiLineString:
        _str = 'MultiLineString';
        break;
      case GeoJSONType.polygon:
        _str = 'Polygon';
        break;
      case GeoJSONType.multiPolygon:
        _str = 'MultiPolygon';
        break;
      case GeoJSONType.geometryCollection:
        _str = 'GeometryCollection';
        break;
    }
    return _str;
  }
}

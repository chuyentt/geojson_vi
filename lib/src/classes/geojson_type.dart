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

  static GeoJSONType fromString(String str) {
    var _type;
    switch (str) {
      case 'FeatureCollection':
        _type = GeoJSONType.featureCollection;
        break;
      case 'Feature':
        _type = GeoJSONType.feature;
        break;
      case 'Point':
        _type = GeoJSONType.point;
        break;
      case 'MultiPoint':
        _type = GeoJSONType.multiPoint;
        break;
      case 'LineString':
        _type = GeoJSONType.lineString;
        break;
      case 'MultiLineString':
        _type = GeoJSONType.multiLineString;
        break;
      case 'Polygon':
        _type = GeoJSONType.polygon;
        break;
      case 'MultiPolygon':
        _type = GeoJSONType.multiPolygon;
        break;
      case 'GeometryCollection':
        _type = GeoJSONType.geometryCollection;
    }
    return _type;
  }
}

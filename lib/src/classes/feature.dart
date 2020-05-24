import '../geojson_vi_base.dart';
import '../helpers.dart';
import 'geometry.dart';
import 'multi_point.dart';
import 'line_string.dart';
import 'multi_line_string.dart';
import 'point.dart';
import 'polygon.dart';
import 'multi_polygon.dart';
import 'geometry_collection.dart';

/// Định nghĩa nguyên mẫu đối tượng địa lý
class GeoJSONFeature {
  /// Trong GeoJSON mục B.1.  Normative Changes có nói
  /// A Feature object's "id" member is a string or number
  /// If a Feature has a commonly used identifier, that identifier
  /// SHOULD be included as a member of the Feature object with the name
  /// "id", and the value of this member is either a JSON string or number.
  /// TODO: Có thể viết báo đề xuất thêm id là bắt buộc và chứng minh
  /// cho việc này là việc tìm kiếm và truy xuất,...
  /// Vẽ lại mô hình UML
  
  final type = GeoJSONType.feature;
  final Geometry geometry;

  GeoJSONFeature(this.geometry);

  int _id;
  int get id => _id;

  var _properties = <String, dynamic>{};
  Map<String, dynamic> get properties => _properties;

  List<double> _bbox; // [west, south, east, north]
  List<double> get bbox => _bbox;

  String _title;
  String get title => _title;

  static GeoJSONFeature fromMap(Map data) {
    var geom;
    Map json = data['geometry'];
    GeometryType type = enumFromString(json['type'], GeometryType);
    switch (type) {
      case GeometryType.point:
        geom = GeoJSONPoint.fromMap(data['geometry']);
        break;
      case GeometryType.lineString:
        geom = GeoJSONLineString.fromMap(data['geometry']);
        break;
      case GeometryType.multiPoint:
        geom = GeoJSONMultiPoint.fromMap(data['geometry']);
        break;
      case GeometryType.polygon:
        geom = GeoJSONPolygon.fromMap(data['geometry']);
        break;
      case GeometryType.multiLineString:
        geom = GeoJSONMultiLineString.fromMap(data['geometry']);
        break;
      case GeometryType.multiPolygon:
        geom = GeoJSONMultiPolygon.fromMap(data['geometry']);
        break;
      case GeometryType.geometryCollection:
        geom = GeoJSONGeometryCollection.fromMap(data['geometry']);
        break;
      default:
    }
    var feature = GeoJSONFeature(geom);
    feature._id = data['id'];
    feature._properties = data['properties'];
    feature._bbox = data['bbox'];
    feature._title = data['title'];
    return GeoJSONFeature(geom);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      if (id != null) 'id': id,
      'properties': properties,
      if (bbox != null) 'bbox': bbox,
      if (title != null) 'title': title,
      'geometry': geometrySerialize
    };
  }

  Map<String, dynamic> get geometrySerialize {
    switch (geometry.type) {
      case GeometryType.point:
        final geom = geometry as GeoJSONPoint;
        return geom.toMap();
        break;
      case GeometryType.lineString:
        final geom = geometry as GeoJSONLineString;
        return geom.toMap();
        break;
      case GeometryType.multiPoint:
        final geom = geometry as GeoJSONMultiPoint;
        return geom.toMap();
        break;
      case GeometryType.polygon:
        final geom = geometry as GeoJSONPolygon;
        return geom.toMap();
        break;
      case GeometryType.multiLineString:
        final geom = geometry as GeoJSONMultiLineString;
        return geom.toMap();
        break;
      case GeometryType.multiPolygon:
        final geom = geometry as GeoJSONMultiPolygon;
        return geom.toMap();
        break;
      case GeometryType.geometryCollection:
        final geom = geometry as GeoJSONGeometryCollection;
        return geom.toMap();
        break;
      default:
    }
    return {};
  }

}
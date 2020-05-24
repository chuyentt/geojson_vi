import '../helpers.dart';
import 'geometry.dart';
import 'point.dart';
import 'multi_point.dart';
import 'line_string.dart';
import 'multi_line_string.dart';
import 'polygon.dart';
import 'multi_polygon.dart';


/// Định nghĩa nguyên mẫu tập hợp các đối tượng hình học
class GeoJSONGeometryCollection extends Geometry {

  GeoJSONGeometryCollection() : super(GeometryType.geometryCollection);

  final List<Geometry> _geometries = <Geometry>[];
  List<Geometry> get geometries => _geometries;

  static GeoJSONGeometryCollection fromMap(Map data) {
    List geomsMap = data['geometries'];
    var geoms = GeoJSONGeometryCollection();
    geomsMap.forEach((geomMap) {
      GeometryType type = enumFromString(geomMap['type'], GeometryType);
      Geometry geom;
      switch (type) {
        case GeometryType.point:
          geom = GeoJSONPoint.fromMap(geomMap);
          break;
        case GeometryType.lineString:
          geom = GeoJSONLineString.fromMap(geomMap);
          break;
        case GeometryType.multiPoint:
          geom = GeoJSONMultiPoint.fromMap(geomMap);
          break;
        case GeometryType.polygon:
          geom = GeoJSONPolygon.fromMap(geomMap);
          break;
        case GeometryType.multiLineString:
          geom = GeoJSONMultiLineString.fromMap(geomMap);
          break;
        case GeometryType.multiPolygon:
          geom = GeoJSONMultiPolygon.fromMap(geomMap);
          break;
        default:
      }
      geoms._geometries.add(geom);
    });
    return geoms;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'GeometryCollection',
      'geometries': geometries.map((e) => e.toMap()).toList(),
    };
  }

}
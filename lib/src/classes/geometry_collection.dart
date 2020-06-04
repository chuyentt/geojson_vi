import 'geometry.dart';

/// Định nghĩa nguyên mẫu tập hợp các đối tượng hình học
class GeoJSONGeometryCollection implements Geometry {
  final List<Geometry> geometries = <Geometry>[];
  GeoJSONGeometryCollection();

  @override
  GeometryType get type => GeometryType.geometryCollection;

  GeoJSONGeometryCollection.fromMap(Map data) {
    List geomsMap = data['geometries'];
    var geoms = GeoJSONGeometryCollection();
    geomsMap.forEach((geomMap) {
      var geom = Geometry.fromMap(geomMap);
      geoms.geometries.add(geom);
    });
    geometries.add(geoms);
  }

  @override
  Map<String, dynamic> get toMap => {
        'type': 'GeometryCollection',
        'geometries': geometries.map((e) => e.toMap).toList(),
      };

  @override
  double get area => 0;
}

import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng điểm
class GeoJSONPoint implements Geometry {
  List<double> coordinates;
  GeoJSONPoint(this.coordinates);

  @override
  GeometryType get type => GeometryType.point;

  GeoJSONPoint.fromMap(Map data) {
    var l = data['coordinates'];
    final pos = <double>[];
    l.forEach((value) {
      pos.add(value);
    });
    coordinates = pos;
  }

  @override
  Map<String, dynamic> get toMap => {
        'type': type.name,
        'coordinates': coordinates,
      };

  @override
  double get area => 0;
}

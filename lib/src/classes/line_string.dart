import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng đường
class GeoJSONLineString implements Geometry {
  List<List<double>> coordinates;
  GeoJSONLineString(this.coordinates);

  @override
  GeometryType get type => GeometryType.lineString;

  GeoJSONLineString.fromMap(Map data) {
    var ll = data['coordinates'];
    final posArray = <List<double>>[];
    ll.forEach((l) {
      final pos = <double>[];
      l.forEach((value) {
        pos.add(value);
      });
      posArray.add(pos);
    });
    coordinates = posArray;
  }

  @override
  Map<String, dynamic> get toMap => {
    'type': type.name,
    'coordinates': coordinates,
  };

  @override
  double get area => 0;
}
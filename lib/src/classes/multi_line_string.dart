import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các đường
class GeoJSONMultiLineString implements Geometry {
  List<List<List<double>>> coordinates;
  GeoJSONMultiLineString(this.coordinates);

  @override
  GeometryType get type => GeometryType.multiLineString;

  GeoJSONMultiLineString.fromMap(Map data) {
    var lll = data['coordinates'];
    final ringArray = <List<List<double>>>[];
    lll.forEach((ll) {
      final posArray = <List<double>>[];
      ll.forEach((l) {
        final pos = <double>[];
        l.forEach((value) {
          pos.add(value);
        });
        posArray.add(pos);
      });
      ringArray.add(posArray);
    });
    coordinates = ringArray;
  }

  @override
  Map<String, dynamic> get toMap => {
    'type': type.name,
    'coordinates': coordinates,
  };

  @override
  double get area => 0;
}
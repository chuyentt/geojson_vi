import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các vùng
class GeoJSONMultiPolygon implements Geometry {
  List<List<List<List<double>>>> coordinates;
  GeoJSONMultiPolygon(this.coordinates);

  @override
  GeometryType get type => GeometryType.multiPolygon;

  GeoJSONMultiPolygon.fromMap(Map data) {
    var llll = data['coordinates'];
    final polyArray = <List<List<List<double>>>>[];
    llll.forEach((lll) {
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
      polyArray.add(ringArray);
    });
    coordinates = polyArray;
  }

  @override
  Map<String, dynamic> get toMap => {
        'type': type.name,
        'coordinates': coordinates,
      };

  @override
  double get area => 0;
}

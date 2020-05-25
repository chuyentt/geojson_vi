import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các vùng
class GeoJSONMultiPolygon extends Geometry {
  GeoJSONMultiPolygon(this._coordinates) : super(GeometryType.multiPolygon);

  final List<List<List<List<double>>>> _coordinates;
  List<List<List<List<double>>>> get coordinates => _coordinates;

  static GeoJSONMultiPolygon fromMap(Map data) {
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
            // pos.add(double.parse(value.toStringAsFixed(places)));
          });
          posArray.add(pos);
        });
        ringArray.add(posArray);
      });
      polyArray.add(ringArray);
    });
    return GeoJSONMultiPolygon(polyArray);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': type.name, 'coordinates': coordinates};
  }
}
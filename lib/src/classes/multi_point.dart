import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các điểm
class GeoJSONMultiPoint extends Geometry {
  GeoJSONMultiPoint(this._coordinates) : super(GeometryType.multiPoint);

  final List<List<double>> _coordinates;
  List<List<double>> get coordinates => _coordinates;

  static GeoJSONMultiPoint fromMap(Map data) {
    var ll = data['coordinates'];
    final posArray = <List<double>>[];
    ll.forEach((l) {
      final pos = <double>[];
      l.forEach((value) {
        pos.add(value);
        // pos.add(double.parse(value.toStringAsFixed(places)));
      });
      posArray.add(pos);
    });
    return GeoJSONMultiPoint(posArray);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': type.name, 'coordinates': coordinates};
  }
}
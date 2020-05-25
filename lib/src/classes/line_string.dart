import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng đường
class GeoJSONLineString extends Geometry {
  GeoJSONLineString(this._coordinates) : super(GeometryType.lineString);

  final List<List<double>> _coordinates;
  List<List<double>> get coordinates => _coordinates;

  static GeoJSONLineString fromMap(Map data) {
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
    return GeoJSONLineString(posArray);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'coordinates': coordinates,
    };
  }
}
import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các đường
class GeoJSONMultiLineString extends Geometry {
  GeoJSONMultiLineString(this._coordinates)
      : super(GeometryType.multiLineString);

  final List<List<List<double>>> _coordinates;
  List<List<List<double>>> get coordinates => _coordinates;

  static GeoJSONMultiLineString fromMap(Map data) {
    var lll = data['coordinates'];
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
    return GeoJSONMultiLineString(ringArray);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'coordinates': coordinates,
    };
  }
}
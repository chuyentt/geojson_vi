import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng vùng
class GeoJSONPolygon extends Geometry {

  GeoJSONPolygon(this._coordinates) : super(GeometryType.polygon);
  
  final List<List<List<double>>> _coordinates;// = List<List<List<double>>>[];
  List<List<List<double>>> get coordinates => _coordinates;

  static GeoJSONPolygon fromMap(Map data) {
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
    return GeoJSONPolygon(ringArray);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'coordinates': coordinates
    };
  }

}
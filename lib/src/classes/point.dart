import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng điểm
class GeoJSONPoint extends Geometry {
  
  final List<double> _coordinates;
  List<double> get coordinates => _coordinates;

  GeoJSONPoint(this._coordinates): super(GeometryType.point);
  
  static GeoJSONPoint fromMap(Map data) {
    var l = data['coordinates'];
    final pos = <double>[];
    l.forEach((value) {
      pos.add(value);
      // pos.add(double.parse(value.toStringAsFixed(places)));
    });
    return GeoJSONPoint(pos);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'coordinates': coordinates, // mảng các vị trí
    };
  }

}
import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các điểm
class GeoJSONMultiPoint implements Geometry {
  List<List<double>> coordinates;
  GeoJSONMultiPoint(this.coordinates);

  @override
  GeometryType get type => GeometryType.multiPoint;

  GeoJSONMultiPoint.fromMap(Map data) {
    var ll = data['coordinates'];
    final posArray = <List<double>>[];
    ll.forEach((l) {
      final pos = <double>[];
      l.forEach((value) {
        pos.add(value.toDouble());
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

  @override
  List<double> get bbox {
    double swlat;
    double swlng;
    double nelat;
    double nelng;
    var first = coordinates.first;
    swlat ??= first[1];
    swlng ??= first[0];
    nelat ??= first[1];
    nelng ??= first[0];
    coordinates.forEach((List<double> pos) {
      if (swlat > pos[1]) swlat = pos[1];
      if (nelat < pos[1]) nelat = pos[1];
      if (swlng > pos[0]) swlng = pos[0];
      if (nelng < pos[0]) nelng = pos[0];
    });
    return [swlng, swlat, nelng, nelat]; //west, south, east, north
  }
}

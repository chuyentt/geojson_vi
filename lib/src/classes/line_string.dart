import 'dart:math' show cos, sqrt, asin;
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

  double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000.0;
  }

  @override
  double get distance {
    var _length = 0.0;
    for (var i = 0; i < coordinates.length - 1; i++) {
      var p1 = coordinates[i];
      var p2 = coordinates[i + 1];
      _length += _calculateDistance(p1[1], p1[0], p2[1], p2[0]);
    }
    return _length;
  }

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

import 'dart:convert';
import 'dart:math';

import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng vùng
class GeoJSONPolygon implements Geometry {
  List<List<List<double>>> coordinates;
  GeoJSONPolygon(this.coordinates);

  @override
  GeometryType get type => GeometryType.polygon;

  @override
  GeoJSONPolygon.fromMap(Map data) {
    var lll = data['coordinates'];
    final ringArray = <List<List<double>>>[];
    lll.forEach((ll) {
      final posArray = <List<double>>[];
      ll.forEach((l) {
        final pos = <double>[];
        l.forEach((value) {
          pos.add(value.toDouble());
        });
        posArray.add(pos);
      });
      ringArray.add(posArray);
    });
    coordinates = ringArray;
  }

  double _ringArea(List<List<double>> ringPos) {
    const WGS84_RADIUS = 6378137.0;
    const DEG_TO_RAD = pi / 180.0;
    var _area = 0.0;
    for (var i = 0; i < ringPos.length - 1; i++) {
      var p1 = ringPos[i];
      var p2 = ringPos[i + 1];
      _area += (p2[0] * DEG_TO_RAD - p1[0] * DEG_TO_RAD) *
          (2.0 + sin(p1[1] * DEG_TO_RAD) + sin(p2[1] * DEG_TO_RAD));
    }
    _area = _area * WGS84_RADIUS * WGS84_RADIUS / 2.0;
    return _area.abs();
  }

  @override
  double get area {
    var exteriorRing = coordinates[0];
    var _area = _ringArea(exteriorRing);
    for (var i = 1; i < coordinates.length; i++) {
      var interiorRing = coordinates[i];
      _area -= _ringArea(interiorRing);
    }
    return _area;
  }

  @override
  double get distance => 0;

  @override
  List<double> get bbox {
    double swlat;
    double swlng;
    double nelat;
    double nelng;
    var first = coordinates.first.first;
    swlat ??= first[1];
    swlng ??= first[0];
    nelat ??= first[1];
    nelng ??= first[0];
    coordinates.first.forEach((List<double> pos) {
      if (swlat > pos[1]) swlat = pos[1];
      if (nelat < pos[1]) nelat = pos[1];
      if (swlng > pos[0]) swlng = pos[0];
      if (nelng < pos[0]) nelng = pos[0];
    });
    return [swlng, swlat, nelng, nelat]; //west, south, east, north
  }

  /// A collection of key/value pairs of geospatial data
  @override
  Map<String, dynamic> get toMap => {
        'type': type.name,
        'coordinates': coordinates,
      };

  /// A collection of key/value pairs of geospatial data as String
  @override
  String toString() {
    return jsonEncode(toMap);
  }
}

import 'dart:convert';

import 'geometry.dart';

/// Định nghĩa nguyên mẫu đối tượng hình học dạng mảng các đường
class GeoJSONMultiLineString implements Geometry {
  List<List<List<double>>> coordinates;
  GeoJSONMultiLineString(this.coordinates);

  @override
  GeometryType get type => GeometryType.multiLineString;

  GeoJSONMultiLineString.fromMap(Map data) {
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

  @override
  double get area => 0;

  @override
  double get distance => 0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (ring) => ring.expand(
            (pos) => [pos.first],
          ),
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (ring) => ring.expand(
            (pos) => [pos.last],
          ),
        )
        .toList();
    longitudes.sort();
    latitudes.sort();

    return [
      longitudes.first,
      latitudes.first,
      longitudes.last,
      latitudes.last,
    ]; //west, south, east, north
  }

  /// A collection of key/value pairs of geospatial data
  @override
  Map<String, dynamic> toMap() => {
        'type': type.name,
        'coordinates': coordinates,
      };

  /// A collection of key/value pairs of geospatial data as String
  @override
  String toString() {
    return jsonEncode(toMap());
  }
}

import 'dart:convert';
import 'dart:io';

import '../../geojson_vi.dart';

/// The geometry type MultiPoint
class GeoJSONMultiPoint implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiPoint;

  ///The [coordinates] member is an array of positions.
  var coordinates = <List<double>>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => [element[0]],
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => [element[1]],
        )
        .toList();
    longitudes.sort();
    latitudes.sort();

    return [
      longitudes.first,
      latitudes.first,
      longitudes.last,
      latitudes.last,
    ];
  }

  @override
  double get distance => 0.0;

  /// The constructor for the [coordinates] member
  GeoJSONMultiPoint(this.coordinates)
      : assert(
            coordinates.isNotEmpty,
            'The coordinates is List<List<double>>. '
            'There MUST be one or more elements');

  /// The constructor forom map
  factory GeoJSONMultiPoint.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['MultiPoint'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');
    assert(
        map['coordinates'] is List, 'There MUST be array of positions.');
    final lll = map['coordinates'];
    final _coordinates = <List<double>>[];
    lll.forEach((ll) {
      assert(ll is List, 'There MUST be List');
      assert(
          (ll as List).length > 1, 'There MUST be two or more element');
      final _pos = ll.map((e) => e.toDouble()).cast<double>().toList();
      _coordinates.add(_pos);
    });
    return GeoJSONMultiPoint(_coordinates);
  }

  /// The constructor from JSON string
  factory GeoJSONMultiPoint.fromJSON(String source) =>
      GeoJSONMultiPoint.fromMap(json.decode(source));

  @override
  Future<File> save(String path) async {
    var file = File(path);
    return file.writeAsString(toJSON());
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'coordinates': coordinates,
    };
  }

  @override
  String toJSON() => json.encode(toMap());

  @override
  String toString() => 'MultiPoint($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONMultiPoint && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

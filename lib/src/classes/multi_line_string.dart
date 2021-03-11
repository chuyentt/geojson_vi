import 'dart:convert';

import '../../geojson_vi.dart';

/// The geometry type MultiLineString
class GeoJSONMultiLineString implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiLineString;

  /// The [coordinates] member is a array of LineString coordinate
  /// arrays.
  var coordinates = <List<List<double>>>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => [element[0]],
          ),
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => [element[1]],
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
    ];
  }

  @override
  double get distance => 0.0;

  /// The constructor for the [coordinates] member
  GeoJSONMultiLineString(this.coordinates)
      : assert(coordinates.isNotEmpty,
            'The coordinates MUST be one or more elements');

  /// The constructor from map
  factory GeoJSONMultiLineString.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');

    assert(['MultiLineString'].contains(map['type']), 'Invalid type');

    assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`');

    assert(map['coordinates'] is List<List<List<dynamic>>>,
        'There MUST be array of linear ring coordinate arrays.');

    final llll = map['coordinates'];

    final _coordinates = <List<List<double>>>[];
    llll.forEach((lll) {
      assert(lll is List, 'There MUST be List');
      final _rings = <List<double>>[];
      lll.forEach((ll) {
        assert(ll is List, 'There MUST be List');
        assert((ll as List).length > 1,
            'There MUST be two or more element');
        final _pos = ll.map((e) => e.toDouble()).cast<double>().toList();
        _rings.add(_pos);
      });
      _coordinates.add(_rings);
    });
    return GeoJSONMultiLineString(_coordinates);
  }

  /// The constructor from JSON string
  factory GeoJSONMultiLineString.fromJSON(String source) =>
      GeoJSONMultiLineString.fromMap(json.decode(source));

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
  String toString() => 'MultiLineString($coordinates)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONMultiLineString && o.coordinates == coordinates;
  }

  @override
  int get hashCode => coordinates.hashCode;
}

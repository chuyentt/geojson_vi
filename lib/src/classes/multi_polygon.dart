part of '../../geojson_vi.dart';

/// Class that represents a MultiPolygon geometry type in GeoJSON.
///
/// A MultiPolygon geometry is defined by a list of Polygon coordinate arrays.
class GeoJSONMultiPolygon implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiPolygon;

  /// A list of Polygon coordinate arrays that define the MultiPolygon.
  ///
  /// Each Polygon coordinate array is a list of linear rings, where each ring
  /// is represented by a list of points. Each point is a list of its
  /// coordinates (longitude and latitude).
  var coordinates = <List<List<List<double>>>>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => element.expand(
              (element) => [element[0]],
            ),
          ),
        )
        .toList();
    final latitudes = coordinates
        .expand(
          (element) => element.expand(
            (element) => element.expand(
              (element) => [element[1]],
            ),
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

  /// Constructs a GeoJSONMultiPolygon from the given [coordinates].
  ///
  /// The [coordinates] should contain at least one Polygon, and each Polygon
  /// should contain at least two points (the start and end point of a linear
  /// ring).
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  GeoJSONMultiPolygon(this.coordinates) {
    _assert(coordinates.first.first.length >= 2,
        'The coordinates MUST be two or more elements', coordinates);
  }

  /// Constructs a GeoJSONMultiPolygon from a map.
  ///
  /// The map must contain a 'type' key with the value 'MultiPolygon', and a
  /// 'coordinates' key with the value being a list of Polygon coordinate arrays.
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONMultiPolygon.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(
        ['MultiPolygon'].contains(map['type']), 'Invalid type', map['type']);
    _assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`', map);
    _assert(
        map['coordinates'] is List,
        'There MUST be array of Polygon coordinate arrays.',
        map['coordinates']);
    final lllll = map['coordinates'];
    final coords = <List<List<List<double>>>>[];
    lllll.forEach((llll) {
      final polygon = <List<List<double>>>[];
      _assert(llll is List, 'There MUST be List', [map, llll]);
      llll.forEach((lll) {
        _assert(lll is List, 'There MUST be List', [map, lll]);
        final rings = <List<double>>[];
        lll.forEach((ll) {
          _assert(ll is List, 'There MUST be List', [map, ll]);
          _assert((ll as List).length > 1, 'There MUST be two or more element',
              [map, ll]);
          final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
          rings.add(pos);
        });
        polygon.add(rings);
      });
      coords.add(polygon);
    });
    return GeoJSONMultiPolygon(coords);
  }

  /// Constructs a GeoJSONMultiPolygon from a JSON string.
  ///
  /// The JSON string must represent a map containing a 'type' key with the
  /// value 'MultiPolygon', and a 'coordinates' key with the value being a list
  /// of Polygon coordinate arrays.
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONMultiPolygon.fromJSON(String source) =>
      GeoJSONMultiPolygon.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'coordinates': coordinates,
    };
  }

  @override
  String toJSON({int indent = 0}) {
    if (indent > 0) {
      return JsonEncoder.withIndent(' ' * indent).convert(toMap());
    } else {
      return json.encode(toMap());
    }
  }

  @override
  String toString() =>
      'GeoJSONMultiPolygon(type: $type, coordinates: $coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GeoJSONMultiPolygon) {
      if (other.type != type ||
          other.coordinates.length != coordinates.length ||
          other.coordinates.first.length != coordinates.first.length) {
        return false;
      }

      return coordinates.asMap().entries.map((entry) {
        int i = entry.key;
        List<List<List<double>>> polygon1 = entry.value;
        List<List<List<double>>> polygon2 = other.coordinates[i];

        return polygon1.asMap().entries.map((entry) {
          int j = entry.key;
          List<List<double>> lineString1 = polygon1[j];
          List<List<double>> lineString2 = polygon2[j];
          if (lineString1.length != lineString2.length) return false;
          return lineString1.asMap().entries.map((entry) {
            int k = entry.key;
            return doubleListsEqual(lineString1[k], lineString2[k]);
          }).reduce((value, element) => value && element);
        }).reduce((value, element) => value && element);
      }).reduce((value, element) => value && element);
    }
    return false;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      coordinates
          .expand((list) => list)
          .expand((innerList) => innerList)
          .expand((innerInnerList) => innerInnerList)
          .fold(0, (hash, value) => hash ^ value.hashCode);
}

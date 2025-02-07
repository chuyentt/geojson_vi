part of '../../geojson_vi.dart';

/// This class represents the geometry type MultiLineString according to the
/// GeoJSON specification.
///
/// A MultiLineString is composed of an array of LineString coordinate arrays.
class GeoJSONMultiLineString implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiLineString;

  /// The 'coordinates' member must be an array of LineString coordinate arrays.
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

  /// Creates a new GeoJSONMultiLineString object with the given [coordinates].
  ///
  /// The [coordinates] must represent one or more valid LineString coordinates.
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  GeoJSONMultiLineString(this.coordinates) {
    _assert(coordinates.isNotEmpty,
        'The coordinates MUST be one or more elements', coordinates);
  }

  /// Creates a new GeoJSONMultiLineString object from a map.
  ///
  /// The map must include a 'type' key with the value 'MultiLineString' and
  /// a 'coordinates' key with an array of linear ring coordinate arrays.
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONMultiLineString.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(
        ['MultiLineString'].contains(map['type']), 'Invalid type', map['type']);
    _assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`', map);
    _assert(
        map['coordinates'] is List,
        'There MUST be array of linear ring coordinate arrays.',
        map['coordinates']);
    final llll = map['coordinates'];
    final coords = <List<List<double>>>[];
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
      coords.add(rings);
    });
    return GeoJSONMultiLineString(coords);
  }

  /// Creates a new GeoJSONMultiLineString object from a JSON string.
  ///
  /// The JSON string must represent a valid GeoJSON MultiLineString object.
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
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
  String toJSON({int indent = 0}) {
    if (indent > 0) {
      return JsonEncoder.withIndent(' ' * indent).convert(toMap());
    } else {
      return json.encode(toMap());
    }
  }

  @override
  String toString() =>
      'GeoJSONMultiLineString(type: $type, coordinates: $coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GeoJSONMultiLineString) {
      if (other.type != type ||
          other.coordinates.length != coordinates.length ||
          other.coordinates.first.length != coordinates.first.length) {
        return false;
      }

      return coordinates.asMap().entries.map((entry) {
        int i = entry.key;
        List<List<double>> lineString1 = entry.value;
        List<List<double>> lineString2 = other.coordinates[i];
        if (lineString1.length != lineString2.length) return false;
        return lineString1.asMap().entries.map((entry) {
          int j = entry.key;
          return doubleListsEqual(lineString1[j], lineString2[j]);
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
          .fold(0, (hash, value) => hash ^ value.hashCode);
}

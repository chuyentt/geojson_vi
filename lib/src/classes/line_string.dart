part of '../../geojson_vi.dart';

/// A class representing a GeoJSON LineString.
///
/// A LineString is a curve with linear interpolation between points. Each
/// segment of the LineString is a line in the two-dimensional coordinate plane.
class GeoJSONLineString implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.lineString;

  /// The coordinates of this LineString, represented as an array of point
  /// coordinates.
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
  double get distance {
    var length = 0.0;
    for (var i = 0; i < coordinates.length - 1; i++) {
      var p1 = coordinates[i];
      var p2 = coordinates[i + 1];
      length += calculateHaversineDistance(p1[1], p1[0], p2[1], p2[0]);
    }
    return length;
  }

  /// Constructs a GeoJSONLineString from the provided list of [coordinates].
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  GeoJSONLineString(this.coordinates) {
    _assert(coordinates.length >= 2,
        'The coordinates MUST be two or more positions', coordinates);
  }

  /// Constructs a GeoJSONLineString from a Map.
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONLineString.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(['LineString'].contains(map['type']), 'Invalid type', map['type']);
    _assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`', map);
    _assert(map['coordinates'] is List,
        'There MUST be array of two or more positions.', map['coordinates']);
    final lll = map['coordinates'];
    final coordinates = <List<double>>[];
    lll.forEach((ll) {
      _assert(ll is List, 'There MUST be List', [map, lll]);
      _assert((ll as List).length > 1, 'There MUST be two or more element',
          [map, lll, ll]);
      final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
      coordinates.add(pos);
    });
    return GeoJSONLineString(coordinates);
  }

  /// Constructs a GeoJSONLineString from a JSON string.
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONLineString.fromJSON(String source) =>
      GeoJSONLineString.fromMap(json.decode(source));

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
      'GeoJSONLineString(type: $type, coordinates: $coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GeoJSONLineString) {
      return type == other.type &&
          coordinates.length == other.coordinates.length &&
          coordinates.asMap().entries.every((entry) {
            int i = entry.key;
            List<double> l1 = entry.value;
            return doubleListsEqual(l1, other.coordinates[i]);
          });
    }
    return false;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      coordinates
          .expand((list) => list)
          .fold(0, (hash, value) => hash ^ value.hashCode);
}

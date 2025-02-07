part of '../../geojson_vi.dart';

/// A class representing a GeoJSON MultiPoint.
///
/// A MultiPoint object represents a set of points in coordinate space.
/// The [coordinates] property of the MultiPoint object is an array of point
/// coordinates, where each point coordinate is an array of length 2
/// (for 2D points).
class GeoJSONMultiPoint implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.multiPoint;

  /// The coordinates of this MultiPoint, represented as an array of point
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
  double get distance => 0.0;

  /// Constructs a GeoJSONMultiPoint from the provided list of [coordinates].
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  GeoJSONMultiPoint(this.coordinates) {
    _assert(
        coordinates.isNotEmpty,
        'The coordinates is List<List<double>>. '
        'There MUST be one or more elements',
        coordinates);
  }

  /// Constructs a GeoJSONMultiPoint from a Map.
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONMultiPoint.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(['MultiPoint'].contains(map['type']), 'Invalid type', map['type']);
    _assert(map.containsKey('coordinates'),
        'There MUST be contains key `coordinates`', map);
    _assert(map['coordinates'] is List, 'There MUST be array of positions.',
        map['coordinates']);
    final lll = map['coordinates'];
    final coords = <List<double>>[];
    lll.forEach((ll) {
      _assert(ll is List, 'There MUST be List', [map, ll]);
      _assert((ll as List).length > 1, 'There MUST be two or more element',
          [map, ll]);
      final pos = ll.map((e) => e.toDouble()).cast<double>().toList();
      coords.add(pos);
    });
    return GeoJSONMultiPoint(coords);
  }

  /// Constructs a GeoJSONMultiPoint from a JSON string.
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONMultiPoint.fromJSON(String source) =>
      GeoJSONMultiPoint.fromMap(json.decode(source));

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
      'GeoJSONMultiPoint(type: $type, coordinates: $coordinates)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GeoJSONMultiPoint) {
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

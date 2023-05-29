import 'dart:convert';

import '../../geojson_vi.dart';

/// An abstract base class for GeoJSON Geometry objects.
///
/// This class must be subclassed to provide specific GeoJSON Geometry types
/// like Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon,
/// and GeometryCollection.
abstract class GeoJSONGeometry implements GeoJSON {
  /// Specifies the type of GeoJSON Geometry.
  ///
  /// This field should be overridden by subclasses to specify the correct
  /// GeoJSON type.
  @override
  late final GeoJSONType type;

  /// Gets the area of the geometry.
  ///
  /// This should be implemented by subclasses to compute the correct area.
  double get area;

  /// Gets the distance of the geometry.
  ///
  /// This should be implemented by subclasses to compute the correct distance.
  double get distance;

  /// Creates a new instance of GeoJSONGeometry from a Map object.
  ///
  /// The Map must contain a 'type' key with one of the valid GeoJSON Geometry
  /// types.
  factory GeoJSONGeometry.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(
        [
          'Point',
          'MultiPoint',
          'LineString',
          'MultiLineString',
          'Polygon',
          'MultiPolygon',
          'GeometryCollection'
        ].contains(map['type']),
        'Invalid type');
    return GeoJSON.fromMap(map) as GeoJSONGeometry;
  }

  /// Creates a new instance of GeoJSONGeometry from a JSON string.
  ///
  /// The JSON string must represent a Map containing a 'type' key with one of
  /// the valid GeoJSON Geometry types.
  factory GeoJSONGeometry.fromJSON(String source) =>
      GeoJSONGeometry.fromMap(json.decode(source));

  /// Converts the GeoJSONGeometry object to a Map.
  @override
  Map<String, dynamic> toMap();

  /// Converts the GeoJSONGeometry object to a JSON string.
  @override
  String toJSON();

  /// Returns a string representation of the GeoJSONGeometry object.
  @override
  String toString() => 'Geometry(type: $type)';

  /// Checks if this GeoJSONGeometry object is equal to the [other] object.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONGeometry && other.type == type;
  }

  /// Returns a hash code for this GeoJSONGeometry object.
  @override
  int get hashCode => type.hashCode;
}

part of '../../geojson_vi.dart';

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
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONGeometry.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(
        [
          'Point',
          'MultiPoint',
          'LineString',
          'MultiLineString',
          'Polygon',
          'MultiPolygon',
          'GeometryCollection'
        ].contains(map['type']),
        'Invalid type',
        map['type']);
    return GeoJSON.fromMap(map) as GeoJSONGeometry;
  }

  /// Creates a new instance of GeoJSONGeometry from a JSON string.
  ///
  /// The JSON string must represent a Map containing a 'type' key with one of
  /// the valid GeoJSON Geometry types.
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONGeometry.fromJSON(String source) =>
      GeoJSONGeometry.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toMap();

  @override
  String toJSON({int indent = 0});

  @override
  String toString();

  @override
  bool operator ==(Object other);

  /// Returns a hash code for this GeoJSONGeometry object.
  @override
  int get hashCode;
}

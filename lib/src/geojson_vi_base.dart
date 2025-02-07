part of '../geojson_vi.dart';

class GeoJSONFormatException extends FormatException {
  GeoJSONFormatException(msg, [source]) : super(msg, source);
}

void _assert(condition, msg, [source]) {
  if (!condition) throw GeoJSONFormatException(msg, source);
}

/// `GeoJSON` is an abstract class representing a geospatial data interchange
/// format.
///
/// All GeoJSON objects must contain a member named "type". A GeoJSON object
/// may have an optional "bbox" member.
abstract class GeoJSON {
  /// The GeoJSONType [type] member of the GeoJSON object.
  ///
  /// It is a string that determines the type of the GeoJSON object.
  late final GeoJSONType type;

  /// An optional bounding box [bbox] of the GeoJSON object.
  ///
  /// It is an array of of double values [west, south, east, north]
  /// represented in the contained geometries.
  /// Array contains minimum and maximum values of all axes of all geometries.
  List<double>? get bbox;

  /// Constructs a GeoJSON object from a map [map].
  ///
  /// Map must contain a member with the name "type".
  /// The value of the type member must be one of:
  /// "FeatureCollection", "Feature", "Point", "MultiPoint", "LineString",
  /// "MultiLineString", "Polygon", "MultiPolygon", "GeometryCollection"
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSON.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(
        [
          'FeatureCollection',
          'Feature',
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

    final type = map['type'];
    late GeoJSON instance;
    switch (type) {
      case 'FeatureCollection':
        instance = GeoJSONFeatureCollection.fromMap(map);
        break;
      case 'Feature':
        instance = GeoJSONFeature.fromMap(map);
        break;
      case 'Point':
        instance = GeoJSONPoint.fromMap(map);
        break;
      case 'MultiPoint':
        instance = GeoJSONMultiPoint.fromMap(map);
        break;
      case 'LineString':
        instance = GeoJSONLineString.fromMap(map);
        break;
      case 'MultiLineString':
        instance = GeoJSONMultiLineString.fromMap(map);
        break;
      case 'Polygon':
        instance = GeoJSONPolygon.fromMap(map);
        break;
      case 'MultiPolygon':
        instance = GeoJSONMultiPolygon.fromMap(map);
        break;
      case 'GeometryCollection':
        instance = GeoJSONGeometryCollection.fromMap(map);
        break;
    }
    return instance;
  }

  /// Constructs a GeoJSON object from a JSON string [source].
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSON.fromJSON(String source) =>
      GeoJSON.fromMap(json.decode(source));

  /// Converts GeoJSON object to a Map.
  Map<String, dynamic> toMap();

  /// Converts the object to a JSON string representation.
  ///
  /// The [indent] parameter specifies the number of spaces to use for indentation.
  /// Set [indent] to 0 or a negative value for no indentation.
  ///
  /// Returns the JSON string representation of the object.
  String toJSON({int indent = 0});

  @override
  String toString() => 'GeoJSON(type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONGeometry && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

import 'dart:convert';

import '../../geojson_vi.dart';

/// The abstract class of the geometry
abstract class GeoJSONGeometry implements GeoJSON {
  /// The GeometryType [type] must be initialized.
  @override
  late final GeoJSONType type;

  /// Area geometry
  ///
  /// Returns double value
  double get area;

  /// Distance geometry
  ///
  /// Returns double value
  double get distance;

  /// The constructor from map
  factory GeoJSONGeometry.fromMap(Map<String, dynamic> map) {
    return GeoJSON.fromMap(map) as GeoJSONGeometry;
  }

  /// The constructor from JSON string
  factory GeoJSONGeometry.fromJSON(String source) =>
      GeoJSONGeometry.fromMap(json.decode(source));

  /// Converts geometry to a Map
  @override
  Map<String, dynamic> toMap();

  /// Encodes geometry to JSON string
  @override
  String toJSON();

  @override
  String toString() => 'Geometry(type: $type)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONGeometry && o.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

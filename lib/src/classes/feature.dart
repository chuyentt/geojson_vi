import 'dart:convert';

import '../../geojson_vi.dart';

/// The Feature represents a spatially bounded thing.
class GeoJSONFeature implements GeoJSON {
  /// A Feature object has a [type] member with the value "Feature".
  @override
  GeoJSONType type = GeoJSONType.feature;

  GeoJSONGeometry _geometry;

  /// A Feature object has a member with the name [geometry]. The value
  /// of the geometry member SHALL be either a Geometry object as types:
  /// Point, MultiPoint, LineString, MultiLineString, Polygon,
  /// MultiPolygon, or GeometryCollection
  GeoJSONGeometry get geometry => _geometry;
  set geometry(value) {
    _geometry = value;
    _bbox = _geometry.bbox;
  }

  /// A Feature object has a member with the name [properties]. The
  /// value of the properties member is an object (any JSON object or a
  /// JSON null value).
  Map<String, dynamic>? properties = <String, dynamic>{};

  /// The [id] is a custom member commonly used as an identifier
  String? id;

  /// The [title] is a custom member commonly used as foreign member
  String? title;

  List<double>? _bbox;

  /// The constructor for the [geometry] member.
  GeoJSONFeature(GeoJSONGeometry geometry,
      {this.properties, this.id, this.title})
      : _geometry = geometry,
        _bbox = geometry.bbox;

  /// The constructor from map
  factory GeoJSONFeature.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['Feature'].contains(map['type']), 'Invalid type');
    assert(
        map.containsKey('geometry'), 'There MUST be contains key `geometry`');
    assert(map['geometry'] is Map, 'There MUST be geometry object.');
    return GeoJSONFeature(
      GeoJSONGeometry.fromMap(map['geometry']),
      properties: Map.castFrom(map['properties']),
      id: map['id'],
      title: map['title'],
    );
  }

  /// The constructor from JSON string
  factory GeoJSONFeature.fromJSON(String source) =>
      GeoJSONFeature.fromMap(json.decode(source));

  @override
  List<double>? get bbox => _bbox;

  @Deprecated(
    'Use `geometry.toMap()` instead. '
    'Will be removed in the next version',
  )
  Map<String, dynamic> get geometrySerialize => geometry.toMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      'type': type.value,
      'properties': properties ?? {},
      'geometry': geometry.toMap(),
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
  String toString() => 'Feature(geometry: $geometry)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONFeature && o.geometry == geometry;
  }

  @override
  int get hashCode => geometry.hashCode;
}

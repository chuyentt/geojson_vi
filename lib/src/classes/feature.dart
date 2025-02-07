part of '../../geojson_vi.dart';

/// The Feature represents a spatially bounded thing.
class GeoJSONFeature implements GeoJSON {
  /// A Feature object has a [type] member with the value "Feature".
  @override
  GeoJSONType type = GeoJSONType.feature;

  GeoJSONGeometry? _geometry;

  /// A Feature object has a member with the name [geometry]. The value
  /// of the geometry member SHALL be either a Geometry object as types:
  /// Point, MultiPoint, LineString, MultiLineString, Polygon,
  /// MultiPolygon, or GeometryCollection
  GeoJSONGeometry? get geometry => _geometry;
  set geometry(value) {
    _geometry = value;
    _bbox = _geometry?.bbox;
  }

  /// A Feature object has a member with the name [properties]. The
  /// value of the properties member is an object (any JSON object or a
  /// JSON null value).
  Map<String, dynamic>? properties = <String, dynamic>{};

  /// The [id] is a custom member commonly used as an identifier
  dynamic id;

  /// The [title] is a custom member commonly used as foreign member
  String? title;

  List<double>? _bbox;

  /// The constructor for the [geometry] member.
  GeoJSONFeature(GeoJSONGeometry? geometry,
      {this.properties, this.id, this.title})
      : _geometry = geometry,
        _bbox = geometry?.bbox;

  /// The constructor from map
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONFeature.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(['Feature'].contains(map['type']), 'Invalid type', map['type']);
    _assert(map.containsKey('geometry'),
        'There MUST be contains key `geometry`', map);
    final geometry = map['geometry'] != null
        ? GeoJSONGeometry.fromMap(map['geometry'])
        : null;
    return GeoJSONFeature(
      geometry,
      properties:
          map['properties'] != null ? Map.castFrom(map['properties']) : null,
      id: map['id'],
      title: map['title'],
    );
  }

  /// The constructor from JSON string
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONFeature.fromJSON(String source) =>
      GeoJSONFeature.fromMap(json.decode(source));

  @override
  List<double>? get bbox => _bbox;

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      'properties': properties ?? {},
      'geometry': geometry?.toMap(),
      if (bbox != null) 'bbox': bbox,
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
      'GeoJSONFeature(type: $type, geometry: $geometry, id: $id, title: $title, bbox: $bbox)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is GeoJSONFeature) {
      return type == other.type &&
          id == other.id &&
          title == other.title &&
          geometry == other.geometry &&
          mapEquals(other.properties, properties);
    }
    return false;
  }

  @override
  int get hashCode =>
      type.hashCode ^
      id.hashCode ^
      title.hashCode ^
      geometry.hashCode ^
      (properties?.entries ?? {})
          .map((entry) => entry.key.hashCode ^ entry.value.hashCode)
          .fold(0, (hash, value) => hash ^ value);
}

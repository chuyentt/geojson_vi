import 'dart:convert';

import '../../geojson_vi.dart';

/// A GeoJSON object representing a Geometry Collection.
///
/// A Geometry Collection is a geometry type which groups multiple geometries
/// together.
class GeoJSONGeometryCollection implements GeoJSONGeometry {
  /// Specifies the GeoJSON type of this object.
  @override
  GeoJSONType type = GeoJSONType.geometryCollection;

  /// A list of geometries included in this collection.
  var geometries = <GeoJSONGeometry>[];

  /// Returns the area of the Geometry Collection, which is always 0.0.
  @override
  double get area => 0.0;

  /// Returns the bounding box of the Geometry Collection.
  @override
  List<double> get bbox {
    final longitudes = geometries
        .expand((element) => [element.bbox?[0], element.bbox?[2]])
        .toList();
    final latitudes = geometries
        .expand((element) => [element.bbox?[1], element.bbox?[3]])
        .toList();
    longitudes.sort();
    latitudes.sort();

    return [
      longitudes.first ?? 0,
      latitudes.first ?? 0,
      longitudes.last ?? 0,
      latitudes.last ?? 0,
    ];
  }

  /// Returns the distance of the Geometry Collection, which is always 0.0.
  @override
  double get distance => 0.0;

  /// Constructs a new Geometry Collection with the given list of geometries.
  GeoJSONGeometryCollection(this.geometries);

  /// Constructs a new Geometry Collection from a Map object.
  ///
  /// The Map must represent a valid Geometry Collection.
  factory GeoJSONGeometryCollection.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['GeometryCollection'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('geometries'),
        'There MUST be contains key `geometries`');
    assert(map['geometries'] is List, 'There MUST be array of the geometry.');
    final value = map['geometries'];
    final geoms = <GeoJSONGeometry>[];
    value.forEach((map) {
      geoms.add(GeoJSONGeometry.fromMap(map));
    });
    return GeoJSONGeometryCollection(geoms);
  }

  /// Constructs a new Geometry Collection from a JSON string.
  ///
  /// The JSON string must represent a valid Geometry Collection.
  factory GeoJSONGeometryCollection.fromJSON(String source) =>
      GeoJSONGeometryCollection.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'geometries': geometries.map((e) => e.toMap()).toList(),
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
  String toString() => 'GeometryCollection(geometries: $geometries)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONGeometryCollection && other.geometries == geometries;
  }

  @override
  int get hashCode => geometries.hashCode;
}

import 'dart:convert';

import '../../geojson_vi.dart';

class GeoJSONGeometryCollection implements GeoJSONGeometry {
  @override
  GeoJSONType get type => GeoJSONType.geometryCollection;

  /// The [geometries] member is a array of the geometry
  var geometries = <GeoJSONGeometry>[];

  @override
  double get area => 0.0;

  @override
  List<double> get bbox {
    final longitudes = geometries
        .expand((element) => [element.bbox[0], element.bbox[2]])
        .toList();
    final latitudes = geometries
        .expand((element) => [element.bbox[1], element.bbox[3]])
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

  /// The constructor for the [geometries] member
  GeoJSONGeometryCollection(this.geometries)
      : assert(geometries != null && geometries.isNotEmpty,
            'The coordinates MUST be one or more elements');

  /// The constructor from map
  factory GeoJSONGeometryCollection.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    if (map.containsKey('geometries')) {
      final value = map['geometries'];
      if (value is List) {
        final _geometries = <GeoJSONGeometry>[];
        value.forEach((map) {
          _geometries.add(GeoJSONGeometry.fromMap(map));
        });

        return GeoJSONGeometryCollection(_geometries);
      }
    }
    return null;
  }

  /// The constructor from JSON string
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
  String toJSON() => json.encode(toMap());

  @override
  String toString() => 'GeometryCollection(geometries: $geometries)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONGeometryCollection && o.geometries == geometries;
  }

  @override
  int get hashCode => geometries.hashCode;
}

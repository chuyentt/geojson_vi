import 'dart:convert';

import '../../geojson_vi.dart';

class GeoJSONGeometryCollection implements GeoJSONGeometry {
  @override
  GeoJSONType type = GeoJSONType.geometryCollection;

  /// The [geometries] member is a array of the geometry
  var geometries = <GeoJSONGeometry>[];

  @override
  double get area => 0.0;

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

  @override
  double get distance => 0.0;

  /// The constructor for the [geometries] member
  GeoJSONGeometryCollection(this.geometries);

  /// The constructor from map
  factory GeoJSONGeometryCollection.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['GeometryCollection'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('geometries'),
        'There MUST be contains key `geometries`');
    assert(map['geometries'] is List, 'There MUST be array of the geometry.');
    final value = map['geometries'];
    final _geometries = <GeoJSONGeometry>[];
    value.forEach((map) {
      _geometries.add(GeoJSONGeometry.fromMap(map));
    });
    return GeoJSONGeometryCollection(_geometries);
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
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONGeometryCollection && o.geometries == geometries;
  }

  @override
  int get hashCode => geometries.hashCode;
}

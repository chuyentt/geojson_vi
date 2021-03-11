import 'package:geojson_vi/geojson_vi.dart';

Future<void> main() async {
  final pointDataMap = {
    'type': 'Point',
    'coordinates': [105.77389, 21.0720414]
  };

  /// Create GeoJSON object from data without knowing its type
  final geoJSONPoint = GeoJSON.fromMap(pointDataMap);
  if (geoJSONPoint is GeoJSONPoint) {
    final type = geoJSONPoint.type;
    final area = geoJSONPoint.area;
    final bbox = geoJSONPoint.bbox;
    final coordinates = geoJSONPoint.coordinates;
    final distance = geoJSONPoint.distance;
    final map = geoJSONPoint.toMap();
    final json = geoJSONPoint.toJSON();
    final string = geoJSONPoint.toString();
    print('$type\n$area\n$bbox\n$coordinates\n'
        '$distance\n$map\n$json\n$string');

    /// Create GeoJSONPoint object from JSON string already know its type
    final geoJSONPoint1 = GeoJSONPoint.fromJSON(json);
    final type1 = geoJSONPoint1.type;
    final area1 = geoJSONPoint1.area;
    final bbox1 = geoJSONPoint1.bbox;
    final coordinates1 = geoJSONPoint1.coordinates;
    final distance1 = geoJSONPoint1.distance;
    final map1 = geoJSONPoint1.toMap();
    final json1 = geoJSONPoint1.toJSON();
    final string1 = geoJSONPoint1.toString();
    print('$type1\n$area1\n$bbox1\n$coordinates1\n'
        '$distance1\n$map1\n$json1\n$string1');
  }

  /// Create GeoJSONGeometry object from data without knowing its type
  final geoJSONGeometry = GeoJSONGeometry.fromMap(pointDataMap);
  if (geoJSONGeometry is GeoJSONPoint) {
    final type = geoJSONGeometry.type;
    final area = geoJSONGeometry.area;
    final bbox = geoJSONGeometry.bbox;
    final coordinates = geoJSONGeometry.coordinates;
    final distance = geoJSONGeometry.distance;
    final map = geoJSONGeometry.toMap();
    final json = geoJSONGeometry.toJSON();
    final string = geoJSONGeometry.toString();
    print('$type\n$area\n$bbox\n$coordinates\n'
        '$distance\n$map\n$json\n$string');

    /// Create GeoJSONPoint object from JSON string already know its type
    final geoJSONGeometr1 = GeoJSONPoint.fromJSON(json);
    final type1 = geoJSONGeometr1.type;
    final area1 = geoJSONGeometr1.area;
    final bbox1 = geoJSONGeometr1.bbox;
    final coordinates1 = geoJSONGeometr1.coordinates;
    final distance1 = geoJSONGeometr1.distance;
    final map1 = geoJSONGeometr1.toMap();
    final json1 = geoJSONGeometr1.toJSON();
    final string1 = geoJSONGeometr1.toString();
    print('$type1\n$area1\n$bbox1\n$coordinates1\n'
        '$distance1\n$map1\n$json1\n$string1');
  }

  final startTime = DateTime.now();
  print(startTime.toString());
  final path = '../test/test_resources/data.geojson';
  final newPath = '../test/test_resources/data_new.geojson';
  final geoJSONFromFile = await GeoJSON.load(path);
  print(geoJSONFromFile.type);
  print(geoJSONFromFile.bbox);
  await geoJSONFromFile.save(newPath);
  print(DateTime.now().difference(startTime));
}

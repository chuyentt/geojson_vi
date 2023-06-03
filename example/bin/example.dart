import 'package:geojson_vi/geojson_vi.dart';

Future<void> main() async {
  // Create GeoJSONPoint
  final geoJSONPoint = GeoJSONPoint([105.77389, 21.0720414]);
  print('GeoJSONPoint:\n${geoJSONPoint.toMap()}');
  print('Area: ${geoJSONPoint.area}');
  print('Distance: ${geoJSONPoint.distance}');

  // Create GeoJSONPoint from Map
  final pointDataMap = {
    'type': 'Point',
    'coordinates': [105.77389, 21.0720414]
  };
  final geoJSONPointFromMap = GeoJSONPoint.fromMap(pointDataMap);
  print('\nGeoJSONPoint from Map:\n${geoJSONPointFromMap.toMap()}');

  // Create GeoJSONPoint from JSON
  final pointJSON = '{"type": "Point", "coordinates": [105.77389, 21.0720414]}';
  final geoJSONPointFromJSON = GeoJSONPoint.fromJSON(pointJSON);
  print('\nGeoJSONPoint from JSON:\n${geoJSONPointFromJSON.toMap()}');

  // Create GeoJSONPolygon
  final geoJSONPolygon = GeoJSONPolygon([
    [
      [105.77389, 21.0720414],
      [105.77123, 21.074412],
      [105.77015, 21.075051],
      [105.77389, 21.0720414]
    ]
  ]);
  print('\nGeoJSONPolygon:\n${geoJSONPolygon.toMap()}');
  print('Area: ${geoJSONPolygon.area}');
  print('Distance: ${geoJSONPolygon.distance}');

  // Create GeoJSONPolygon from Map
  final polygonDataMap = {
    'type': 'Polygon',
    'coordinates': [
      [
        [105.77389, 21.0720414],
        [105.77123, 21.074412],
        [105.77015, 21.075051],
        [105.77389, 21.0720414]
      ]
    ]
  };
  final geoJSONPolygonFromMap = GeoJSONPolygon.fromMap(polygonDataMap);
  print('\nGeoJSONPolygon from Map:\n${geoJSONPolygonFromMap.toMap()}');

  // Create GeoJSONPolygon from JSON
  final polygonJSON = '''
  {
    "type": "Polygon",
    "coordinates": [[
      [105.77389, 21.0720414],
      [105.77123, 21.074412],
      [105.77015, 21.075051],
      [105.77389, 21.0720414]
    ]]
  }
  ''';
  final geoJSONPolygonFromJSON = GeoJSONPolygon.fromJSON(polygonJSON);
  print('\nGeoJSONPolygon from JSON:\n${geoJSONPolygonFromJSON.toMap()}');

  // Create GeoJSONFeatureCollection
  final geoJSONFeatureCollection = GeoJSONFeatureCollection([
    GeoJSONFeature(geoJSONPoint, properties: {'name': 'My Point'}),
    GeoJSONFeature(geoJSONPolygon, properties: {'name': 'My Polygon'}),
  ]);
  print('\nGeoJSONFeatureCollection:\n${geoJSONFeatureCollection.toMap()}');

  // Find features
  print('\nFind features with name "My Point":');
  final foundFeaturesExact = geoJSONFeatureCollection
      .findProperties('name', 'My Point', contains: false);
  for (var feature in foundFeaturesExact) {
    print(feature.toMap());
  }

  // Find features using containment
  print('\nFind features with name containing "My":');
  final foundFeaturesContainment =
      geoJSONFeatureCollection.findProperties('name', 'My', contains: true);
  for (var feature in foundFeaturesContainment) {
    print(feature.toMap());
  }
}

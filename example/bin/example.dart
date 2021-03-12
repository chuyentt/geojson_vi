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

  /// Creating a new feature collection
  final newFeatureColl = GeoJSONFeatureCollection([]);

  final point = GeoJSONPoint([105.780701, 21.067921]);
  final pointFeature = GeoJSONFeature(point);
  pointFeature.properties = {
    'title': 'Hanoi University of Mining and Geology',
    'url': 'http://humg.edu.vn',
  };

  final polygonCoordinates = [
    [
      [104.765625, 20.468189],
      [106.545410, 20.468189],
      [106.545410, 21.596150],
      [104.765625, 21.596150],
      [104.765625, 20.468189]
    ]
  ];
  newFeatureColl.features.add(pointFeature);
  final polygon = GeoJSONPolygon(polygonCoordinates);
  final polygonFeature = GeoJSONFeature(polygon);
  newFeatureColl.features.add(polygonFeature);
  print(newFeatureColl.toMap());
  /*
    {
    'type': 'FeatureCollection',
    'features': [
      {
        'type': 'Feature',
        'properties': {'name': 'This is a Point'},
        'geometry': {
          'type': 'Point',
          'coordinates': [105.780163, 21.067921]
        }
      },
      {
        'type': 'Feature',
        'properties': {'name': 'Example of Polygon'},
        'geometry': {
          'type': 'Polygon',
          'coordinates': [
            [
              [104.765625, 20.468189],
              [106.54541, 20.468189],
              [106.54541, 21.59615],
              [104.765625, 21.59615],
              [104.765625, 20.468189]
            ]
          ]
        }
      }
    ]
  }
  */
}

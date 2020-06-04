import 'package:geojson_vi/geojson_vi.dart';

Future<void> main() async {
  // ### Create a Feature with Point geometry

  // New GeoJSON
  final geoJSON = GeoJSON.create('example/data/new.geojson');

  // One position
  final pos = <double>[];
  pos.add(105.7743099);
  pos.add(21.0717561);
  // or pos.addAll([105.7743099,21.0717561]);

  // Create a Point geometry from one position
  final geom_point = GeoJSONPoint(pos);

  // Create a Feature
  final feature_point = GeoJSONFeature(geom_point);
  feature_point.properties['marker-color'] = '#7e7e7e';
  feature_point.properties['marker-size'] = 'medium';
  feature_point.properties['marker-symbol'] = 'college';
  feature_point.properties['title'] = 'Hanoi University of Mining and Geology';
  feature_point.properties['department'] = 'Geoinformation Technology';
  feature_point.properties['address'] =
      'No.18 Vien Street - Duc Thang Ward - Bac Tu Liem District - Ha Noi';
  feature_point.properties['url'] = 'http://humg.edu.vn';

  // Add the feature to featureCollection
  geoJSON.featureCollection.features.add(feature_point);

  // ### Create a Feature with LineString geometry

  // LineString from 3 positions
  final pos1 = [105.7771289, 21.0715458];
  final pos2 = [105.7745218, 21.0715658];
  final pos3 = [105.7729125, 21.0715358];

  // Create a LineString geometry from array of position
  final geom_line_string = GeoJSONLineString([pos1, pos2, pos3]);

  // Create a Feature
  final feature_line_string = GeoJSONFeature(geom_line_string);
  feature_line_string.properties['stroke'] = '#7e7e7e';
  feature_line_string.properties['stroke-width'] = 2;
  feature_line_string.properties['stroke-opacity'] = 1;
  feature_line_string.properties['title'] = 'Vien St.';

  // Add the fearture to featureCollection
  geoJSON.featureCollection.features.add(feature_line_string);

  // ### Create a Feature with Polygon geometry

  // A linear ring is a closed LineString with four or more positions.
  // The first and last positions are equivalent, and they MUST contain
  // identical values; their representation SHOULD also be identical.
  final p01 = [105.7739666, 21.0726795]; // The first position
  final p02 = [105.7739719, 21.0721991];
  final p03 = [105.7743394, 21.0721966];
  final p04 = [105.7743310, 21.0725269];
  final p05 = [105.7742564, 21.0726120];
  final p06 = [105.7741865, 21.0726095];
  final p07 = [105.7741785, 21.0726746];
  final p08 = [105.7739666, 21.0726795]; // The last position

  //The exterior ring (boundary)
  final linerRing = [p01, p02, p03, p04, p05, p06, p07, p08];

  // Create a Polygon geometry from array of position
  final geom_polygon = GeoJSONPolygon([
    linerRing,
    // and others the interior rings (if present) bound holes within the surface
  ]);

  // Create a Feature
  final feature_polygon = GeoJSONFeature(geom_polygon);
  feature_polygon.properties['stroke'] = '#555555';
  feature_polygon.properties['stroke-width'] = 2;
  feature_polygon.properties['stroke-opacity'] = 1;
  feature_polygon.properties['fill'] = '#ab7942';
  feature_polygon.properties['fill-opacity'] = 0.5;
  feature_polygon.properties['title'] = 'HUMG\'s Office';

  // Add to featureCollection
  geoJSON.featureCollection.features.add(feature_polygon);

  await geoJSON.save();

  // # Read the GeoJSON file
  var launchTime = DateTime.now();
  await GeoJSON.load('example/data/parcels_82mb.geojson')
      .then((GeoJSON geoJSON) {
    print(geoJSON.featureCollection.features.length);
    print(DateTime.now().difference(launchTime));
  });

  // Calculate area of polygon
  await GeoJSON.load('example/data/polygon_with_holes.geojson').then((value) {
    value.featureCollection.features.forEach((element) {
      if (element.geometry.type == GeometryType.polygon) {
        GeoJSONPolygon pg = element.geometry;
        print('Area: ${pg.area}');
      }
    });
  });

  // Search by geometry and properties
  var polygonFeatures = geoJSON.featureCollection.features.where((element) {
    return (element.geometry.type == GeometryType.polygon &&
        (element.properties['title']).contains('HUMG'));
  }).toList();

  print(polygonFeatures.isNotEmpty ? polygonFeatures.first.toMap : 'not found');

  // # Read the GeoJSON file (cache applied)
  launchTime = DateTime.now();
  await GeoJSON.load('example/data/parcels_82mb.geojson')
      .then((GeoJSON geoJSON) {
    print(geoJSON.featureCollection.features.length);
    print(DateTime.now().difference(launchTime));
  });
}

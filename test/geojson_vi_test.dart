import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final geoJSON = GeoJSON.create('example/data/new.geojson');

    setUp(() {
      geoJSON.save();
    });

    test('First Test', () {
      expect(geoJSON.featureCollection.features.isEmpty, isTrue);
    });
  });
}

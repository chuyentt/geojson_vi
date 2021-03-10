import 'package:geojson_vi/geojson_vi.dart';
import 'package:test/test.dart';

void main() {
  /// A position is an array of numbers. The first two elements
  /// are longitude and latitude
  final fakePos = [105.77389, 21.0720414];

  // final fakeLineString

  group('GeoJSON', () {
    test(
        'creates an instances by using fromMap for '
        'type FeatureCollection', () {
      final data = {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'properties': {
              'title': 'Hanoi University of Mining and Geology',
              'country': 'Vietnam'
            },
            'geometry': {'type': 'Point', 'coordinates': fakePos}
          }
        ]
      };
      final geoJSON = GeoJSON.fromMap(data);
      expect(geoJSON.type, GeoJSONType.featureCollection);
      expect(geoJSON is GeoJSONFeatureCollection, true);
      expect(geoJSON.toMap(), {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'properties': {
              'title': 'Hanoi University of Mining and Geology',
              'country': 'Vietnam'
            },
            'geometry': {
              'type': 'Point',
              'coordinates': [105.77389, 21.0720414]
            }
          }
        ]
      });
      expect(geoJSON.toJSON(),
          '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]}}]}');
    });
    test(
        'creates an instances by using fromJSON for '
        'type FeatureCollection', () {
      final data =
          '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]}}]}';
      final geoJSON = GeoJSON.fromJSON(data);
      expect(geoJSON.type, GeoJSONType.featureCollection);
      expect(geoJSON is GeoJSONFeatureCollection, true);
      expect(geoJSON.toMap(), {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'properties': {
              'title': 'Hanoi University of Mining and Geology',
              'country': 'Vietnam'
            },
            'geometry': {
              'type': 'Point',
              'coordinates': [105.77389, 21.0720414]
            }
          }
        ]
      });
      expect(geoJSON.toJSON(),
          '{"type":"FeatureCollection","features":[{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]}}]}');
    });
    test(
        'creates an instances by using fromMap for '
        'type Feature', () {
      final data = {
        'type': 'Feature',
        'properties': {
          'title': 'Hanoi University of Mining and Geology',
          'country': 'Vietnam'
        },
        'geometry': {'type': 'Point', 'coordinates': fakePos}
      };
      final geoJSON = GeoJSON.fromMap(data);
      expect(geoJSON.type, GeoJSONType.feature);
      expect(geoJSON is GeoJSONFeature, true);
      expect(geoJSON.toMap(), {
        'type': 'Feature',
        'properties': {
          'title': 'Hanoi University of Mining and Geology',
          'country': 'Vietnam'
        },
        'geometry': {
          'type': 'Point',
          'coordinates': [105.77389, 21.0720414]
        }
      });
      expect(geoJSON.toJSON(),
          '{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]}}');
    });
    test(
        'creates an instances by using fromJSON for '
        'type Feature', () {
      final data =
          '{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]}}';
      final geoJSON = GeoJSON.fromJSON(data);
      expect(geoJSON.type, GeoJSONType.feature);
      expect(geoJSON is GeoJSONFeature, true);
      expect(geoJSON.toMap(), {
        'type': 'Feature',
        'properties': {
          'title': 'Hanoi University of Mining and Geology',
          'country': 'Vietnam'
        },
        'geometry': {
          'type': 'Point',
          'coordinates': [105.77389, 21.0720414]
        }
      });
      expect(geoJSON.toJSON(),
          '{"type":"Feature","properties":{"title":"Hanoi University of Mining and Geology","country":"Vietnam"},"geometry":{"type":"Point","coordinates":[105.77389,21.0720414]}}');
    });
  });
}

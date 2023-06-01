# geojson_vi: An Open-Source Dart and Flutter Library for Efficiently Handling GeoJSON Data in Compliance with RFC 7946

[![pub package](https://img.shields.io/pub/v/geojson_vi.svg)](https://pub.dartlang.org/packages/geojson_vi)

**geojson_vi** is an open-source library for Dart and Flutter developers, specifically designed to provide comprehensive support for the GeoJSON geospatial data interchange format as per the RFC 7946 standard. The software is a flexible, reliable tool that allows developers to parse, read, create, update, search, and delete geospatial data effectively.

## Feature Highlights of geojson_vi

Powerful Tools for Efficient GeoJSON Data Handling. Some of the primary ones include:
- **Parsing and Reading GeoJSON Data:** geojson\_vi allows developers to quickly parse and read GeoJSON data, ensuring full compliance with RFC 7946 standard.
- **Creating, Updating, Searching, and Deleting GeoJSON Data:** With geojson\_vi, developers can easily manipulate GeoJSON data, from creating new data entries to updating, searching, and deleting existing data.
- **Support for All GeoJSON Objects:** geojson\_vi offers comprehensive support for a wide range of Geometry types (`GeoJSONPoint`, `GeoJSONMultiPoint`, `GeoJSONLineString`, `GeoJSONMultiLineString`, `GeoJSONPolygon`, `GeoJSONMultiPolygon`, `GeoJSONGeometryCollection`), `Feature`, and `FeatureCollection`, making it a versatile tool for effectively managing diverse geospatial data.

## GeoJSON UML Model

| ![GeoJSON Class Diagram](https://raw.githubusercontent.com/chuyentt/geojson_vi/master/doc/GeoJSON_Class_Diagram.svg) | 
|:--:| 
| *Class structure of the geojson_vi library* |

| ![GeoJSON Geometry Class Diagram](https://raw.githubusercontent.com/chuyentt/geojson_vi/master/doc/GeoJSON_Geometry_Class_Diagram.svg) | 
|:--:| 
| *Detailed Class Diagram of GeoJSON Geometry in the geojson_vi library* |

## Usage

### Create GeoJSON object

```dart
  final map = {
    'type': 'Point',
    'coordinates': [105.77389, 21.0720414]
  };

  final jsonString =
      '{"type": "Point", "coordinates": [105.78070163726807, 21.067921688241626]}';

  final polygonCoordinates = [
    [
      [104.765625, 20.468189],
      [106.545410, 20.468189],
      [106.545410, 21.596150],
      [104.765625, 21.596150],
      [104.765625, 20.468189]
    ]
  ];

  // Creating a GeoJSON object from data without knowing its type
  final pointFromMap = GeoJSON.fromMap(map);

  // Creating GeoJSONPoint object from JSON string already know its type
  final pointFromJSON = GeoJSONPoint.fromJSON(jsonString);

  // Creating GeoJSONGeometry object from data without knowing its type
  final geometryFromMap = GeoJSONGeometry.fromMap(map);

  // Creating GeoJSONPoint object from JSON string already know its type
  final geometryFromJSON = GeoJSONPoint.fromJSON(jsonString);

  // Creating GeoJSONPoint object from coordinates data
  final pointFromCoordinates = GeoJSONPoint([105.77389, 21.0720414]);

  // Creating a GeoJSONFeature object
  final feature = GeoJSONFeature(
    GeoJSONPoint([105.780701, 21.067921]),
    properties: {
      'title': 'Hanoi University of Mining and Geology',
      'url': 'http://humg.edu.vn',
    },
  );

  // Creating GeoJSONFeatureCollection object
  final featureCollection = GeoJSONFeatureCollection([]);
  featureCollection.features.add(feature);

  // Creating more GeoJSONFeature
  final polygon = GeoJSONPolygon(polygonCoordinates);
  final polygonFeature = GeoJSONFeature(polygon);
  featureCollection.features.add(polygonFeature);
```

### Demo

```dart
import 'package:geojson_vi/geojson_vi.dart';

void main() {
  final featureCollection = GeoJSONFeatureCollection([]);
  final point = GeoJSONPoint([105.7743099, 21.0717561]);
  final feature = GeoJSONFeature(point, properties: {
    'marker-color': '#7e7e7e',
    'marker-size': 'medium',
    'marker-symbol': 'college',
    'title': 'Hanoi University of Mining and Geology',
    'department': 'Geoinformation Technology',
    'address':
        'No.18 Vien Street - Duc Thang Ward - Bac Tu Liem District - Ha Noi, Vietnam',
    'url': 'http://humg.edu.vn'
  });
  featureCollection.features.add(feature);
  final pos1 = [105.7771289, 21.0715458];
  final pos2 = [105.7745218, 21.0715658];
  final pos3 = [105.7729125, 21.0715358];
  final lineString = GeoJSONLineString([pos1, pos2, pos3]);
  featureCollection.features.add(GeoJSONFeature(lineString, properties: {
    'stroke': '#7e7e7e',
    'stroke-width': 2,
    'stroke-opacity': 1,
    'title': 'Vien St.'
  }));
  final p01 = [105.7739666, 21.0726795]; // The first position
  final p02 = [105.7739719, 21.0721991];
  final p03 = [105.7743394, 21.0721966];
  final p04 = [105.7743310, 21.0725269];
  final p05 = [105.7742564, 21.0726120];
  final p06 = [105.7741865, 21.0726095];
  final p07 = [105.7741785, 21.0726746];
  final p08 = [105.7739666, 21.0726795]; // The last position
  final linerRing = [p01, p02, p03, p04, p05, p06, p07, p08];
  featureCollection.features.add(
    GeoJSONFeature(
      GeoJSONPolygon([linerRing]),
      properties: {
        'stroke': '#555555',
        'stroke-width': 2,
        'stroke-opacity': 1,
        'fill': '#ab7942',
        'fill-opacity': 0.5,
        'title': "HUMG's Office"
      },
    ),
  );
  print(featureCollection.toJSON());
}
```
Output: ```new.geojson```
```JavaScript
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "marker-color": "#7e7e7e",
        "marker-size": "medium",
        "marker-symbol": "college",
        "title": "Hanoi University of Mining and Geology",
        "department": "Geoinformation Technology",
        "address": "No.18 Vien Street - Duc Thang Ward - Bac Tu Liem District - Ha Noi, Vietnam",
        "url": "http://humg.edu.vn"
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          105.7743099,
          21.0717561
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "stroke": "#7e7e7e",
        "stroke-width": 2,
        "stroke-opacity": 1,
        "title": "Vien St."
      },
      "geometry": {
        "type": "LineString",
        "coordinates": [
          [
            105.7771289,
            21.0715458
          ],
          [
            105.7745218,
            21.0715658
          ],
          [
            105.7729125,
            21.0715358
          ]
        ]
      }
    },
    {
      "type": "Feature",
      "properties": {
        "stroke": "#555555",
        "stroke-width": 2,
        "stroke-opacity": 1,
        "fill": "#ab7942",
        "fill-opacity": 0.5,
        "title": "HUMG's Office"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              105.7739666,
              21.0726795
            ],
            [
              105.7739719,
              21.0721991
            ],
            [
              105.7743394,
              21.0721966
            ],
            [
              105.774331,
              21.0725269
            ],
            [
              105.7742564,
              21.072612
            ],
            [
              105.7741865,
              21.0726095
            ],
            [
              105.7741785,
              21.0726746
            ],
            [
              105.7739666,
              21.0726795
            ]
          ]
        ]
      }
    }
  ]
}
```
Quick viewing on geojson.io
![Quick viewing](doc/vs.png)

## Reference
H. Butler, M. Daly, A. Doyle, S. Gillies, S. Hagen, and T. Schaub, "The GeoJSON Format", August 2016, https://tools.ietf.org/html/rfc7946.


## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/chuyentt/geojson_vi/issues
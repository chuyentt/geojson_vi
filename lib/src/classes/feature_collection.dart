import 'dart:convert';
import 'dart:collection';
import 'dart:io';

import '../../geojson_vi.dart';

class ListExt<T> extends ListBase<T?> {
  List innerList = [];

  /// We defined some callback functions
  void Function(T? element)? onAdd;
  void Function(Iterable<T?> iterable)? onAddAll;
  void Function(T? element)? onRemove;

  @override
  int get length => innerList.length;

  @override
  set length(int length) {
    innerList.length = length;
  }

  @override
  void operator []=(int index, T? value) {
    innerList[index] = value;
  }

  @override
  T? operator [](int index) => innerList[index];

  @override
  void add(T? element) {
    if (onAdd != null) onAdd!(element);
    super.add(element);
  }

  @override
  void addAll(Iterable<T?> iterable) {
    if (onAddAll != null) onAddAll!(iterable);
    super.addAll(iterable);
  }

  @override
  bool remove(Object? element) {
    final result = super.remove(element);
    if (result && onRemove != null) onRemove!(element as T?);
    return result;
  }

  @override
  T? removeAt(int index) {
    final result = super.removeAt(index);
    if (result != null && onRemove != null) onRemove!(result);
    return result;
  }

  @override
  T? removeLast() {
    final result = super.removeLast();
    if (result != null && onRemove != null) onRemove!(result);
    return result;
  }
}

/// Get bbox
///
/// Returns bbox from list of the features
List<double> _getBbox(List<GeoJSONFeature?> features) {
  if (features.isEmpty) return [-180.0, -90.0, 180.0, 90.0];
  final longitudes = <double>[];
  final latitudes = <double>[];
  Future.forEach(features, (GeoJSONFeature? element) {
    longitudes.addAll([element!.bbox![0], element.bbox![2]]);
    latitudes.addAll([element.bbox![1], element.bbox![3]]);
  });

  longitudes.removeWhere((e) => (e == -180.0) || (e == 180.0));
  latitudes.removeWhere((e) => (e == -90.0) || (e == 90.0));
  longitudes.sort();
  latitudes.sort();
  return [
    longitudes.first,
    latitudes.first,
    longitudes.last,
    latitudes.last,
  ];
}

/// Add bbox
///
/// Returns bbox1 union bbox2
List<double> _addBbox(List<double> bbox1, List<double> bbox2) {
  final longitudes = <double>[];
  final latitudes = <double>[];

  longitudes.addAll([bbox1[0], bbox1[2]]);
  longitudes.addAll([bbox2[0], bbox2[2]]);
  latitudes.addAll([bbox1[1], bbox1[3]]);
  latitudes.addAll([bbox2[1], bbox2[3]]);

  longitudes.removeWhere((e) => (e == -180.0) || (e == 180.0));
  latitudes.removeWhere((e) => (e == -90.0) || (e == 90.0));
  longitudes.sort();
  latitudes.sort();
  return [
    longitudes.first,
    latitudes.first,
    longitudes.last,
    latitudes.last,
  ];
}

/// Remove bbox
///
/// Returns bbox1 \ bbox2
List<double> _removeBbox(List<double> bbox1, List<double>? bbox2) {
  final longitudes = <double>[];
  final latitudes = <double>[];

  longitudes.addAll([bbox1[0], bbox1[2]]);
  latitudes.addAll([bbox1[1], bbox1[3]]);

  longitudes.removeWhere((e) => (e == bbox2![0]) || (e == bbox2[2]));
  latitudes.removeWhere((e) => (e == bbox2![1]) || (e == bbox2[3]));
  longitudes.removeWhere((e) => (e == -180.0) || (e == 180.0));
  latitudes.removeWhere((e) => (e == -90.0) || (e == 90.0));
  longitudes.sort();
  latitudes.sort();
  return [
    longitudes.first,
    latitudes.first,
    longitudes.last,
    latitudes.last,
  ];
}

/// The FeatureCollection has a member with the name "features". The
/// value of [features] is an array of Feature object. It is possible
/// for this array to be empty.
class GeoJSONFeatureCollection implements GeoJSON {
  @override
  GeoJSONType type = GeoJSONType.featureCollection;

  ListExt<GeoJSONFeature> _features = ListExt<GeoJSONFeature>();

  /// The [features] member is a array of the GeoJSONFeature
  List<GeoJSONFeature?> get features => _features;
  set features(List<GeoJSONFeature?> features) {
    final listFeature = ListExt<GeoJSONFeature>();
    listFeature.onAdd = (feature) => onAdd(feature!);
    listFeature.onAddAll = (features) => onAddAll(features);
    listFeature.onRemove = (feature) => onRemove(feature!);
    listFeature.addAll(features);
    _features = listFeature;
  }

  List<double>? _bbox;

  /// The constructor for the [features] member
  GeoJSONFeatureCollection(List<GeoJSONFeature> features) {
    final listFeature = ListExt<GeoJSONFeature>();
    listFeature.onAdd = (feature) => onAdd(feature!);
    listFeature.onAddAll = (features) => onAddAll(features);
    listFeature.onRemove = (feature) => onRemove(feature!);
    listFeature.addAll(features);
    _features = listFeature;
  }

  /// The constructor from map
  factory GeoJSONFeatureCollection.fromMap(Map<String, dynamic> map) {
    assert(map.containsKey('type'), 'There MUST be contains key `type`');
    assert(['FeatureCollection'].contains(map['type']), 'Invalid type');
    assert(map.containsKey('features'),
        'There MUST be contains key `features`');
    assert(
        map['features'] is List, 'There MUST be array of the feature.');
    final value = map['features'] as List;
    final _features = <GeoJSONFeature>[];
    Future.forEach(value, (map) {
      _features.add(GeoJSONFeature.fromMap(map as Map<String, dynamic>));
    });
    return GeoJSONFeatureCollection(_features);
  }

  /// The constructor from JSON string
  factory GeoJSONFeatureCollection.fromJSON(String source) =>
      GeoJSONFeatureCollection.fromMap(json.decode(source));

  /// The callback function is passed when the feature is added
  void onAdd(GeoJSONFeature feature) {
    _bbox = _addBbox(_bbox!, feature.bbox!);
  }

  /// The callback function is passed when the features is added
  void onAddAll(Iterable<GeoJSONFeature?> features) {
    _bbox = _getBbox(features as List<GeoJSONFeature?>);
  }

  /// The callback function is passed when the feature is removed
  void onRemove(GeoJSONFeature feature) {
    _bbox = _removeBbox(_bbox!, feature.bbox);
  }

  @override
  List<double>? get bbox => _bbox;

  @override
  Future<File> save(String path) async {
    var file = File(path);
    return file.writeAsString(toJSON());
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'features': features.map((e) => e!.toMap()).toList(),
    };
  }

  @override
  String toJSON() => json.encode(toMap());

  @override
  String toString() => 'FeatureCollection(features: $features)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GeoJSONFeatureCollection && o.features == features;
  }

  @override
  int get hashCode => features.hashCode;
  final t = {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "properties": {
          "marker-color": "#7e7e7e",
          "marker-size": "medium",
          "marker-symbol": ""
        },
        "geometry": {
          "type": "Point",
          "coordinates": [0.0, 0.0]
        }
      },
      {
        "type": "Feature",
        "properties": {
          "marker-color": "#ab7942",
          "marker-size": "medium",
          "marker-symbol": "building",
          "name": "Trần Trung Chuyên"
        },
        "geometry": {
          "type": "Point",
          "coordinates": [105.78070163726807, 21.067921688241626]
        }
      },
      {
        "type": "Feature",
        "properties": {
          "marker-color": "#ab7942",
          "marker-symbol": "bar"
        },
        "geometry": {
          "type": "MultiPoint",
          "coordinates": [
            [105.78209638595581, 21.063896943906965],
            [105.78145265579224, 21.06537870324324]
          ]
        }
      },
      {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [105.78005790710449, 21.0681619680406],
            [105.7803475856781, 21.067501197659364],
            [105.78048706054688, 21.067170811367916],
            [105.78066945075989, 21.06680037738058],
            [105.7816457748413, 21.067200846515643]
          ]
        }
      },
      {
        "type": "Feature",
        "properties": {
          "stroke": "#ff2600",
          "stroke-width": 2,
          "stroke-opacity": 1,
          "fill": "#ff9300",
          "fill-opacity": 0.5
        },
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [105.7812488079071, 21.068442293982127],
              [105.78128099441527, 21.06793169990766],
              [105.78195691108704, 21.06669024817941],
              [105.78265428543091, 21.06703064726499],
              [105.78174233436584, 21.06848234050207],
              [105.7812488079071, 21.068442293982127]
            ]
          ]
        }
      },
      {
        "type": "Feature",
        "properties": {
          "stroke": "#ff40ff",
          "stroke-width": 2,
          "stroke-opacity": 1
        },
        "geometry": {
          "type": "MultiLineString",
          "coordinates": [
            [
              [105.78205884992713, 21.066605085498942],
              [105.7821446806156, 21.066640126637317],
              [105.78222514688605, 21.066700197141024],
              [105.78228415548438, 21.066720220636878],
              [105.7823592573368, 21.066795308722305],
              [105.78232707082861, 21.066835355685683]
            ],
            [
              [105.78228548169136, 21.06671402608202],
              [105.78239813446999, 21.066696505522565],
              [105.78247055411337, 21.066741558385548],
              [105.78249067068099, 21.066821652330493],
              [105.78263685107231, 21.066847933146782],
              [105.78268647193909, 21.066880471293846],
              [105.78269854187965, 21.066900494765427]
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
          "fill": "#ff9300",
          "fill-opacity": 0.5
        },
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [105.7830660045147, 21.06779278798116],
              [105.78365877270697, 21.067782776305762],
              [105.78367888927458, 21.068359698000688],
              [105.78304588794708, 21.068352189272833],
              [105.7830660045147, 21.06779278798116]
            ],
            [
              [105.78315854072571, 21.06799427280515],
              [105.78329131007195, 21.06807061170443],
              [105.7833194732666, 21.06810940686774],
              [105.78332081437111, 21.06827585051808],
              [105.78348308801651, 21.068269593241347],
              [105.78346967697144, 21.06813193308696],
              [105.78349784016608, 21.068074366075525],
              [105.78364670276642, 21.067993021347455],
              [105.78356891870499, 21.067864121148805],
              [105.78343346714973, 21.067950471779675],
              [105.78337579965591, 21.067950471779675],
              [105.7832282781601, 21.067871629901315],
              [105.78315854072571, 21.06799427280515]
            ]
          ]
        }
      },
      {
        "type": "Feature",
        "properties": {
          "marker-color": "#ff9300",
          "marker-size": "medium",
          "marker-symbol": "college",
          "title":
              "Faculty of Information Technology Department of Hanoi University of Mining and Geology",
          "name": "Trần Trung Chuyên"
        },
        "geometry": {
          "type": "Point",
          "coordinates": [105.77525407075882, 21.071956335064222]
        }
      },
      {
        "type": "Feature",
        "properties": {
          "stroke": "#942092",
          "stroke-width": 2,
          "stroke-opacity": 1,
          "fill": "#942092",
          "fill-opacity": 0.5
        },
        "geometry": {
          "type": "MultiPolygon",
          "coordinates": [
            [
              [
                [105.77490001916885, 21.072431875555388],
                [105.77545523643494, 21.072431875555388],
                [105.77545523643494, 21.072557017537154],
                [105.77490001916885, 21.072557017537154],
                [105.77490001916885, 21.072431875555388]
              ]
            ],
            [
              [
                [105.77490270137787, 21.071871238184343],
                [105.77504217624664, 21.071871238184343],
                [105.77504217624664, 21.072184094120804],
                [105.77490270137787, 21.072184094120804],
                [105.77490270137787, 21.071871238184343]
              ]
            ],
            [
              [
                [105.77538549900055, 21.071866232484005],
                [105.77566713094711, 21.071866232484005],
                [105.77566713094711, 21.072174082741032],
                [105.77538549900055, 21.072174082741032],
                [105.77538549900055, 21.071866232484005]
              ]
            ]
          ]
        }
      },
      {
        "type": "Feature",
        "properties": {"name": "GeometryCollection"},
        "geometry": {
          "type": "GeometryCollection",
          "geometries": [
            {
              "type": "Point",
              "coordinates": [105.78840494155884, 21.063696705026796]
            },
            {
              "type": "MultiPoint",
              "coordinates": [
                [105.78561544418335, 21.06611957737646],
                [105.785915851593, 21.06728094021327]
              ]
            },
            {
              "type": "LineString",
              "coordinates": [
                [105.78583002090454, 21.062675482545593],
                [105.78958511352539, 21.062675482545593],
                [105.78990697860718, 21.06285569878695]
              ]
            },
            {
              "type": "MultiLineString",
              "coordinates": [
                [
                  [105.7863450050354, 21.068662549708385],
                  [105.7883620262146, 21.067080705888344]
                ],
                [
                  [105.78810453414917, 21.06680037738058],
                  [105.78872680664062, 21.067441127479146]
                ]
              ]
            }
          ]
        }
      }
    ]
  };
}

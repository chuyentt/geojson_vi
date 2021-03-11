import 'dart:convert';
import 'dart:collection';

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
    assert(
        map.containsKey('features') && map['features'] is List,
        'The map is Map<String, dynamic>. '
        'There MUST be contains key `features`');
    final value = map['features'];
    final _features = <GeoJSONFeature>[];
    value.forEach((map) {
      _features.add(GeoJSONFeature.fromMap(map));
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
}

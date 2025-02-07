part of '../../geojson_vi.dart';

/// The ListExt class extends the ListBase class to provide additional
/// functionality.
class ListExt<T> extends ListBase<T?> {
  List innerList = [];

  /// Callback function called when an element is added.
  void Function(T? element)? onAdd;

  /// Callback function called when a collection of elements is added.
  void Function(Iterable<T?> iterable)? onAddAll;

  /// Callback function called when an element is removed.
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
/// Returns the bbox from a list of features.
List<double> _getBbox(List<GeoJSONFeature?> features) {
  if (features.isEmpty) return [-180.0, -90.0, 180.0, 90.0];
  final longitudes = <double>[];
  final latitudes = <double>[];
  Future.forEach(features, (GeoJSONFeature? element) {
    if (element?.geometry != null) {
      longitudes.addAll([element!.bbox![0], element.bbox![2]]);
      latitudes.addAll([element.bbox![1], element.bbox![3]]);
    }
  });

  longitudes.removeWhere((e) => (e == -180.0) || (e == 180.0));
  latitudes.removeWhere((e) => (e == -90.0) || (e == 90.0));
  longitudes.sort();
  latitudes.sort();
  if (longitudes.isEmpty) return [-180.0, -90.0, 180.0, 90.0];
  return [
    longitudes.first,
    latitudes.first,
    longitudes.last,
    latitudes.last,
  ];
}

/// Add bbox
///
/// Returns the union of two bboxes.
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
/// Returns the difference of two bboxes.
List<double> _removeBbox(List<double> bbox1, List<double>? bbox2) {
  if (bbox2 == null) return bbox1;
  if (numListEquals(bbox1, bbox2)) return bbox1;
  final longitudes = <double>[];
  final latitudes = <double>[];

  longitudes.addAll([bbox1[0], bbox1[2]]);
  latitudes.addAll([bbox1[1], bbox1[3]]);

  longitudes.removeWhere((e) => (e == bbox2[0]) || (e == bbox2[2]));
  latitudes.removeWhere((e) => (e == bbox2[1]) || (e == bbox2[3]));
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

/// The GeoJSONFeatureCollection represents a collection of features.
class GeoJSONFeatureCollection implements GeoJSON {
  @override
  GeoJSONType type = GeoJSONType.featureCollection;

  ListExt<GeoJSONFeature> _features = ListExt<GeoJSONFeature>();

  /// The [features] member is an array of GeoJSONFeature objects.
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

  /// The constructor for the [features] member.
  GeoJSONFeatureCollection(List<GeoJSONFeature> features) {
    final listFeature = ListExt<GeoJSONFeature>();
    listFeature.onAdd = (feature) => onAdd(feature!);
    listFeature.onAddAll = (features) => onAddAll(features);
    listFeature.onRemove = (feature) => onRemove(feature!);
    listFeature.addAll(features);
    _features = listFeature;
  }

  /// The constructor from map.
  ///
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONFeatureCollection.fromMap(Map<String, dynamic> map) {
    _assert(map.containsKey('type'), 'There MUST be contains key `type`', map);
    _assert(['FeatureCollection'].contains(map['type']), 'Invalid type',
        map['type']);
    _assert(map.containsKey('features'),
        'There MUST be contains key `features`', map);
    _assert(map['features'] is List, 'There MUST be an array of features.',
        map['features']);
    final value = map['features'] as List;
    final fs = <GeoJSONFeature>[];
    Future.forEach(value, (map) {
      fs.add(GeoJSONFeature.fromMap(map as Map<String, dynamic>));
    });
    return GeoJSONFeatureCollection(fs);
  }

  /// The constructor from JSON string.
  ///
  /// Throws [FormatException] if argument is not valid JSON
  /// Throws [GeoJSONFormatException] if argument is not valid GeoJSON
  factory GeoJSONFeatureCollection.fromJSON(String source) =>
      GeoJSONFeatureCollection.fromMap(json.decode(source));

  /// The callback function called when a feature is added.
  void onAdd(GeoJSONFeature feature) {
    if (feature.bbox != null) {
      _bbox = _addBbox(_bbox!, feature.bbox!);
    }
  }

  /// The callback function called when features are added.
  void onAddAll(Iterable<GeoJSONFeature?> features) {
    _bbox = _getBbox(features as List<GeoJSONFeature?>);
  }

  /// The callback function called when a feature is removed.
  void onRemove(GeoJSONFeature feature) {
    _bbox = _removeBbox(_bbox!, feature.bbox);
  }

  @override
  List<double>? get bbox => _bbox;

  /// Finds all features where the specified property matches the given value.
  ///
  /// This method will iterate over all features in the collection and check if the
  /// provided property exists and matches the specified value.
  ///
  /// If the [contains] argument is set to `true`, the method will find all features
  /// where the property contains the specified value, instead of exactly matching it.
  ///
  /// Returns a list of all features that match the criteria.
  ///
  /// Example:
  /// ```dart
  /// var foundFeatures = featureCollection.findProperties('name', 'na', contains: true);
  /// print('Found ${foundFeatures.length} feature(s) with name containing "na".');
  /// ```
  ///
  /// [property]: The property to match.
  /// [value]: The value to match.
  /// [contains]: Whether to look for a partial match (default is `false`).
  List<GeoJSONFeature> findProperties(String property, String value,
      {bool contains = false}) {
    List<GeoJSONFeature> foundFeatures = [];

    for (var feature in features) {
      var properties = feature?.properties;

      if (properties != null && properties.containsKey(property)) {
        if (contains) {
          if (properties[property].toString().contains(value)) {
            foundFeatures.add(feature!);
          }
        } else {
          if (properties[property].toString() == value) {
            foundFeatures.add(feature!);
          }
        }
      }
    }
    return foundFeatures;
  }

  /// Finds the nearest GeoJSON feature to a given point.
  ///
  /// This function iterates over a list of features and calculates the distance
  /// between the given point and each feature. The feature with the shortest
  /// distance to the point is considered the nearest.
  ///
  /// [lat] and [lon] are the latitude and longitude coordinates of the given point.
  ///
  /// Returns the nearest GeoJSON feature to the given point. If the features list
  /// is empty, returns null.
  ///
  /// Note: This function only calculates distances for point, lineString, and polygon features.
  /// Distances for other types of features will need to be handled separately.
  GeoJSONFeature? findNearestFeature(double lat, double lon) {
    GeoJSONFeature? nearestFeature;
    double? shortestDistance;

    if (features.isEmpty) return null; // Return null if features list is empty

    for (var feature in features) {
      double? distance;
      if (feature?.geometry == null) continue;
      switch (feature!.geometry!.type) {
        case GeoJSONType.point:
          var coords = (feature.geometry as GeoJSONPoint).coordinates;
          distance = calculateHaversineDistance(lat, lon, coords[1], coords[0]);
          break;
        case GeoJSONType.lineString:
          var coords = (feature.geometry as GeoJSONLineString).coordinates;
          distance = coords
              .map((coord) =>
                  calculateHaversineDistance(lat, lon, coord[1], coord[0]))
              .reduce(min);
          break;
        case GeoJSONType.polygon:
          var polygon = (feature.geometry as GeoJSONPolygon).coordinates;
          distance = polygon.first
              .map((coord) =>
                  calculateHaversineDistance(lat, lon, coord[1], coord[0]))
              .reduce(min);
          break;
        // Handle other cases if needed
        case GeoJSONType.featureCollection:
          break;
        case GeoJSONType.feature:
          break;
        case GeoJSONType.multiPoint:
          break;
        case GeoJSONType.multiLineString:
          break;
        case GeoJSONType.multiPolygon:
          break;
        case GeoJSONType.geometryCollection:
          break;
      }

      // Only compare if distance is not null
      if (distance != null &&
          (shortestDistance == null || distance < shortestDistance)) {
        shortestDistance = distance;
        nearestFeature = feature;
      }
    }

    return nearestFeature;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': type.value,
      'features': features.map((e) => e!.toMap()).toList(),
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
  String toString() => 'FeatureCollection(features: $features)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoJSONFeatureCollection && other.features == features;
  }

  @override
  int get hashCode => features.hashCode;
}

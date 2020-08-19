import 'dart:convert';
import 'package:universal_io/io.dart';

import 'classes/feature_collection.dart';
import 'classes/feature.dart';

/// The abstract class of GeoJSON
abstract class GeoJSON {
  /// The GeoJSON file path
  String get path;

  /// The FeatureCollection object
  GeoJSONFeatureCollection get featureCollection;

  /// Load GeoJSON from file with file path
  static Future<GeoJSON> load(String path) async {
    return await _GeoJSON._load(path);
  }

  /// Create new GeoJSON with file path
  static GeoJSON create(String path) {
    var geoJSON = _GeoJSON(path);
    geoJSON._featureCollection ??= GeoJSONFeatureCollection();
    return geoJSON;
  }

  /// Save to file or save as for new file path
  Future<File> save({String newPath});
}

/// The GeoJSON Type
enum GeoJSONType { feature, featureCollection }

extension GeoJSONTypeExtension on GeoJSONType {
  String get name {
    switch (this) {
      case GeoJSONType.feature:
        return 'Feature';
      case GeoJSONType.featureCollection:
        return 'FeatureCollection';
      default:
        return null;
    }
  }
}

/// The implement of the GeoJSON abstract class
class _GeoJSON implements GeoJSON {
  /// Private cache
  static final _cache = <String, _GeoJSON>{};

  /// Default private constructor with cache applied
  factory _GeoJSON(String path) {
    _GeoJSON geoJSON;
    if (_cache[path] == null) {
      geoJSON = _GeoJSON._init(path);
    }
    return _cache.putIfAbsent(path, () => geoJSON);
  }

  /// Private constructor
  _GeoJSON._init(this._path);

  /// Private GeoJSON file path
  String _path;

  /// Private FeatureCollection object
  GeoJSONFeatureCollection _featureCollection;

  /// Private load
  static Future<_GeoJSON> _load(String path) async {
    var file = File(path);
    if (!await file.exists()) {
      return null;
    }
    var geoJSON = _GeoJSON(path);
    if (geoJSON._featureCollection != null) {
      return geoJSON;
    } else {
      /// Read file as string
      await file.readAsString().then((data) async {
        var json = jsonDecode(data);
        if (json != null) {
          String type = json['type'];
          switch (type) {
            case 'FeatureCollection':
              geoJSON._featureCollection =
                  GeoJSONFeatureCollection.fromMap(json);
              break;
            case 'Feature':
              geoJSON._featureCollection.features
                  .add(GeoJSONFeature.fromMap(json));
              break;
          }
        }
      }).catchError((onError) {
        print('Error, could not open file');
        return null;
      });

      /// For empty file
      geoJSON._featureCollection ??= GeoJSONFeatureCollection();
      return geoJSON;
    }
  }

  @override
  String get path => _path;

  @override
  GeoJSONFeatureCollection get featureCollection => _featureCollection;

  @override
  Future<File> save({String newPath}) {
    var filePath = newPath ?? path;
    var file = File(filePath);
    return file.writeAsString(JsonEncoder().convert(_featureCollection.toMap));
  }
}

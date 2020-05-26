import 'dart:convert';
import 'dart:io';
import 'helpers.dart';
import 'classes/feature_collection.dart';

/// Nguyên mẫu trừu tượng
abstract class GeoJSON {
  GeoJSONFeatureCollection featureCollection = GeoJSONFeatureCollection();

  String _path;
  String get path => _path;

  /// Mở file GeoJSON có sẵn
  static Future<GeoJSON> load(String path) async {
    _GeoJSON geoJson;
    var file = File(path);
    await file.readAsString().then((data) async {
      var json = jsonDecode(data);
      geoJson = _GeoJSON();
      await geoJson._parse(json);
    }).catchError((onError) => print('Error, could not open file'));
    return geoJson;
  }

  /// Tạo mới file GeoJSON
  static GeoJSON create(String path) {
    var geoJSON = _GeoJSON();
    geoJSON._path = path;
    return geoJSON;
  }

  /// Lưu GeoJSON vào file
  Future<File> save({String newPath}) async {
    var filePath = newPath ?? path;
    var file = File(filePath);
    // Write the file.
    return file.writeAsString(toGeoJSONString());
  }

  String toGeoJSONString();
}

/// Kiểu dữ liệu GeoJSON
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

/// Nguyên mẫu private GeoJSON
class _GeoJSON extends GeoJSON {
  @override
  String _path;

  void _parse(Map<String, dynamic> data) {
    if (data == null) return null;
    GeoJSONType type = enumFromString(data['type'], GeoJSONType);
    switch (type) {
      case GeoJSONType.featureCollection:
        featureCollection.fromMap(data);
        break;
      case GeoJSONType.feature:
        featureCollection.featureFromMap(data);
        break;
    }
    return null;
  }

  @override
  String toGeoJSONString() {
    return JsonEncoder().convert(featureCollection.toMap());
  }
}
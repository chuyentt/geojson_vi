import '../geojson_vi_base.dart';
import 'feature.dart';

/// Định nghĩa nguyên mẫu tập hợp các đối tượng địa lý
class GeoJSONFeatureCollection {

  final _type = GeoJSONType.featureCollection;
  GeoJSONType get type => _type;

  final _features = <GeoJSONFeature>[];
  List<GeoJSONFeature> get features => _features;

  void fromMap(Map data) {
    if (data == null) return null;
    var items = data['features'];
    items.forEach((element) {
      //GeoJSONType type = enumFromString(element['type'], GeoJSONType);
      // Có thể kiểm tra lỗi ở đây
      featureFromMap(element);
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'features': features.map((f) => f.toMap()).toList(),
    };
  }

  void featureFromMap(Map data) {
    var item = GeoJSONFeature.fromMap(data);
    _features.add(item);
  }
}
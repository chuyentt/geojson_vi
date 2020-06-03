import '../geojson_vi_base.dart';
import 'feature.dart';

/// Định nghĩa nguyên mẫu tập hợp các đối tượng địa lý
class GeoJSONFeatureCollection {
  GeoJSONType get type => GeoJSONType.featureCollection;

  List<GeoJSONFeature> features = <GeoJSONFeature>[];
  
  GeoJSONFeatureCollection();

  GeoJSONFeatureCollection.fromMap(Map data) {
    if (data == null) return;
    var items = data['features'];
    items.forEach((element) {
      featureFromMap(element);
    });
  }

  Map<String, dynamic> get toMap => {
    'type': type.name,
    'features': features.map((f) => f.toMap).toList(),
  };

  void featureFromMap(Map data) {
    var item = GeoJSONFeature.fromMap(data);
    features.add(item);
  }
}
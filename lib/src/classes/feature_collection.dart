import '../geojson_vi_base.dart';
import 'feature.dart';

/// Định nghĩa nguyên mẫu tập hợp các đối tượng địa lý
class GeoJSONFeatureCollection {
  GeoJSONType get type => GeoJSONType.featureCollection;

  final List<GeoJSONFeature> features = <GeoJSONFeature>[];

  GeoJSONFeatureCollection();

  GeoJSONFeatureCollection.fromMap(Map data) {
    if (data == null) return;
    var items = data['features'];
    items.forEach((element) {
      var feature = GeoJSONFeature.fromMap(element);
      features.add(feature);
    });
  }

  Map<String, dynamic> get toMap => {
        'type': type.name,
        'features': features.map((f) => f.toMap).toList(),
      };
}

# Examples

## GeoJSON

- [x] creates an instances by using fromMap for type FeatureCollection
- [x] creates an instances by using fromJSON for type FeatureCollection
- [x] creates an instances by using fromMap for type Feature
- [x] creates an instances by using fromJSON for type Feature
- [x] given a dataMap with type Point, it returns GeoJSONPoint

## GeoJSONGeometry

- [x] given a dataMap with type MultiPoint, it returns GeoJSONMultiPoint
- [x] given a dataMap with type LineString, it returns GeoJSONLineString
- [x] given a dataMap with type MultiLineString, it returns GeoJSONMultiLineString
- [x] given a dataMap with type Polygon, it returns GeoJSONPolygon
- [x] given a dataMap with type GeometryCollection, it returns GeoJSONGeometryCollection

### GeoJSONPoint

- [x] creates an instances by using fromMap
- [x] toMap of an object created by the constructor

### GeoJSONMultiPoint

- [x] creates an instances by using fromMap
- [x] toMap of an object created by the constructor
- [x] get bbox of a given multipoint
- [x] toString returns collection of key/value pairs of geospatial data as String

### GeoJSONLineString

- [x] creates an instances by using fromMap
- [x] toMap of an object created by the constructor
- [x] get bbox of a given GeoJSONLineString
- [x] toString returns collection of key/value pairs of geospatial data as String
- [x] distance of a given GeoJSONLineString

### GeoJSONMultiLineString

- [x] creates an instances by using fromMap
- [x] toMap of an object created by the constructor
- [x] get bbox of a given multiLineString
- [x] toString returns collection of key/value pairs of geospatial data as String

### GeoJSONPolygon

- [x] creates an instances by using fromMap
- [x] toMap of an object created by the constructor
- [x] calculates area of a given polygon
- [x] get bbox of a given polygon

### GeoJSONMultiPolygon

- [x] creates an instances by using fromMap
- [x] toMap of an object created by the constructor
- [x] get bbox of a given multipolygon

### GeoJSONGeometryCollection

- [x] creates an instance via fromMap
- [x] toMap returns map with geometries
- [x] toString returns collection of key/value pairs of geospatial data as String

## GeoJSONFeature

- [x] create a feature from a defined map
- [x] when geometry is a Point, geometrySerialize returns a map of GeoJSONPoint
- [x] when geometry is a LineString, geometrySerialize returns a map of GeoJSONLineString
- [x] geometry is MultiPoint, geometrySerialize returns a map of GeoJSONMultiPoint
- [x] geometry is Polygon, geometrySerialize returns a map of GeoJSONPolygon
- [x] geometry is MultiLineString, geometrySerialize returns a map of GeoJSONMultiLineString
- [x] geometry is MultiPolygon, geometrySerialize returns a map of GeoJSONMultiPolygon
- [x] geometry is GeometryCollection, geometrySerialize returns a map of GeoJSONGeometryCollection

## GeoJSONFeatureCollection

- [x] create instance from map
- [x] toMap from an existing instance
- [x] toString from an existing instance

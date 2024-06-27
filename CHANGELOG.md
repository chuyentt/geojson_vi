# CHANGELOG

## 2.2.5 - 2024-06-27
### Added
- Support for null geometry values in GeoJSONFeature and GeoJSONFeatureCollection according to the GeoJSON spec.

### Fixed
- Issue with GeoJSONFeature.fromMap(...) and GeoJSONFeatureCollection.fromMap(...) not allowing null geometry values.
- Updated `findNearestFeature` to handle features with null geometry.
- Updated bbox calculation to handle null geometry.

## 2.2.4 - 2024-04-27
### Added
- None

### Changed
- Enhanced the `_removeBbox` function to include null safety checks and an identity comparison to optimize performance and reliability. This improvement prevents unnecessary computations by checking if the input bounding boxes (`bbox1` and `bbox2`) are identical or if `bbox2` is `null`, thereby returning `bbox1` directly under these conditions.

### Deprecated
- None

### Removed
- None

### Fixed
- None

### Security
- None

## 2.2.3 - 2024-03-27
### Added
- Added `isPointInside` method in `GeoJSONPolygon` to check if a point is inside a given polygon.
- Added `isPointInsideComplex` in `GeoJSONPolygon` to determine if a point lies within a complex polygon while considering holes.
- Added `optimalPointInside` method to `GeoJSONPolygon` for calculating the optimal point within a polygon, enhancing label placement in geospatial analyses.

## [2.2.2] - 2024-03-15

- Resolved `RangeError` in equality comparison for `GeoJSONPolygon` when comparing polygons with different point counts (Issue #23).
- Improved equality comparison for `GeoJSONMultiPolygon` and `GeoJSONMultiLineString` to handle nested structures more effectively, addressing the concerns raised in Issue #23

## [2.2.1] - 2023-11-15

* Fix centroid calculation to address algebraic sign issues for clockwise and counterclockwise polygons (Issue #22).
* Update part-of directive to use the URI instead of the library name.

## [2.2.0] - 2023-06-26

* Updated the equality operator (==) and hashCode methods for the objects
* Revised the implementation of the toMap() method to ensure correct behavior
* Added comprehensive unit tests to verify the functionality of the objects
* Add findNearestFeature function to GeoJSONFeatureCollection
* Rename distance calculation function to calculateHaversineDistance and move to geojson_utils.dart
* Add utils/geojson_utils.dart
* Updated unit tests for GeoJSONLineString and GeoJSONPolygon.
* Added perimeter function to GeoJSONPolygon.
* Updated Earth's radius in distance calculation.

## [2.1.0] - 2023-06-03

* Add example usage of findProperties in GeoJSONFeatureCollection
* Add feature search in findProperties with containment
* Refactor imports and apply 'part of' directive

## [2.0.9] - 2023-06-01

* Update unit tests for GeoJSONFeature class
* Update unit tests for GeoJSONGeometryCollection class
* Update unit tests for GeoJSONMultiPolygon class
* Update unit tests for GeoJSONPolygon class
* Update unit tests for GeoJSONMultiLineString class
* Update unit tests for GeoJSONLineString class
* Update unit tests for GeoJSONMultiPoint class
* Update unit tests for GeoJSONPoint class
* Update README.md
* Add unit test for Creating a Polygon with Holes
* Update README.md with feature highlights

## [2.0.8] - 2023-05-29

* Add dartdoc comments to source code

## [2.0.7] - 2022-03-07

* Fix Unhandled Exception: type 'int' is not a subtype of type 'String?'

## [2.0.6] - 2021-12-24

* Fix GeometryCollection.bbox crashes when geometries is empty list #15

## [2.0.5] - 2021-12-24

* Fix casting null value of "properties" to map #18

## [2.0.4] - 2021-11-08

* Fix empty map casting

## [2.0.3] - 2021-06-08

* Fixes "The coordinates MUST be one or more elements" in GeoJSONGeometryCollection #16

## [2.0.2+1] - 2021-03-26

* Updated API documentation

## 2.0.2

* fixes issue 13 - multipolygon assert
* adds indent parameter toJSON

## 2.0.1+1

* Fixed: formatting issues
* Changed: README

## 2.0.1

* Removed: load, save methods
* Fixed: formatting issues

## 2.0.0

* Internal refactor
* Migrate to null-safety

## 1.6.1

* Fixed bbox of multipolygons
* Adds unit tests to:
  * points
  * polygons
  * multipolygons

## 1.6.0

* Changed toMap to toMap()

## 1.5.0

* Added toString() to save GeoJSON objects as string

## 1.4.0

* GeoJSON from GeoJSON String Objects is supported: FeatureCollection, Feature and all the Geometries like Point, MultiPoint, LineString, MultiLineString, Polygon, MultiPolygon and GeometryCollection string

## 1.3.3+1

* Formatting issues

## 1.3.3

* Create GeoJSON from GeoJSON String Objects, clear cache

## 1.3.2

* Added distance getter for LineString

## 1.3.1+3

* Make properties member public

## 1.3.1+2

* Removed debugging info

## 1.3.1+1

* Removed debugging info

## 1.3.1

* Fixed bbox reading

## 1.3.0

* Added bbox properties and fixed minor bugs

## 1.2.4

* Handles errors

## 1.2.3+3

* Removed some sample data files

## 1.2.3+2

* Make the title property of the feature writable

## 1.2.3+1

* Make the id property of the feature writable

## 1.2.3

* Export FeatureCollection

## 1.2.2

* Compatible with runtime flutter-web of web

## 1.2.1+1

* Update the document

## 1.2.1

* Compatiple with Flutter

## 1.2.0+3

* Compatibility issues

## 1.2.0+2

* Compatibility issues

## 1.2.0+1

* Format code

## 1.2.0

* Refactoring the code, create instance from a cache if available

## 1.1.0+3

* Update the document

## 1.1.0+2

* Update the document

## 1.1.0+1

* Update the package export

## 1.1.0

* Added calculate area example into the readme

## 1.0.6+2

* Update the document

## 1.0.6+1

* Update GeoJSON UML model

## 1.0.6

* Fix encode issues

## 1.0.5+4

* Fix formatting issues

## 1.0.5+3

* Update the package description

## 1.0.5+2

* Update the package description

## 1.0.5+1

* Update the package description

## 1.0.5

* Update the package description

## 1.0.3

* Update the package description

## 1.0.2

* Update the package description

## 1.0.1

* Update the document

## 1.0.0

* Initial version, created by chuyentt

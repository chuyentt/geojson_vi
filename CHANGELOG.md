# CHANGELOG

## [2.0.9] - 2023-06-01


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

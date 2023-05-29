// Copyright (c) 2020-2021 Hanoi University of Mining and Geology, Vietnam.
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// `geojson_vi` is a comprehensive GeoJSON library for Dart and Flutter
/// developers.
///
/// It is designed to facilitate parsing, reading, creating, updating,
/// searching, and deleting geospatial data following the RFC 7946 standard.
///
/// Its robust support for all GeoJSON objects makes it an ideal tool for
/// managing GIS data.
library geojson_vi;

// Base package library
export 'src/geojson_vi_base.dart';

// Classes that represent the various GeoJSON objects.
export 'src/classes/feature_collection.dart';
export 'src/classes/feature.dart';
export 'src/classes/geojson_type.dart';
export 'src/classes/geometry.dart';
export 'src/classes/point.dart';
export 'src/classes/multi_point.dart';
export 'src/classes/line_string.dart';
export 'src/classes/multi_line_string.dart';
export 'src/classes/polygon.dart';
export 'src/classes/multi_polygon.dart';
export 'src/classes/geometry_collection.dart';

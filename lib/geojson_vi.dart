// Copyright (c) 2020-2023 Hanoi University of Mining and Geology, Vietnam.
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

import 'dart:convert';
import 'dart:collection';
import 'dart:math';

// Base package library
part 'src/geojson_vi_base.dart';

// Classes that represent the various GeoJSON objects.
part 'src/classes/feature_collection.dart';
part 'src/classes/feature.dart';
part 'src/classes/geojson_type.dart';
part 'src/classes/geometry.dart';
part 'src/classes/point.dart';
part 'src/classes/multi_point.dart';
part 'src/classes/line_string.dart';
part 'src/classes/multi_line_string.dart';
part 'src/classes/polygon.dart';
part 'src/classes/multi_polygon.dart';
part 'src/classes/geometry_collection.dart';
part 'src/utils/geojson_utils.dart';

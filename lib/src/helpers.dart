import 'dart:mirrors';

/// Convert String sang enum
class EnumFromString<T> {
  T get(String value) {
    return (reflectType(T) as ClassMirror)
        .getField(#values)
        .reflectee
        .firstWhere((e) =>
            e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
  }
}

dynamic enumFromString(String value, t) {
  try {
    return (reflectType(t) as ClassMirror)
        .getField(#values)
        .reflectee
        .firstWhere((e) =>
            e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
  } catch (e) {
    print('Error, could not determine string: ${e.toString()}');
  }
  return null;
}
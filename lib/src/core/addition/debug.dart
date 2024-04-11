///
///
/// this file contains:
///
/// [KErrorMessage]
/// [StateErrorExtension]
///
///
part of damath_core;

///
///
/// there are some comments that i use for this project:
///
///


// this type of comment is used when a file contains more than one class, extension ...
///
///
/// this file contains:
///
///
/// part of damath_...;


// this type of comment is used on extension
///
/// static methods:
///
/// instance methods:
///
///

// this type of comment is used on class or mixin that contains rich properties
///
///
/// [], ...(overrides)
/// [], ...(setter, getter)
/// [], ...(functions)
/// [], ...(constructors)
/// [], ...(factories)
/// [], ...(static methods)
///
///



///
/// [iteratorNoElement], ...
///
abstract interface class KErrorMessage {
  const KErrorMessage();

  ///
  /// iterator
  ///
  static const String iteratorNoElement = 'iterator no element';
  static const String iteratorElementNotFound = 'iterator element not found';
  static const String iteratorElementNotNest = 'iterator element not nested';

  ///
  /// vertex
  ///
  static const String vertexDataCannotAssignDirectly =
      'cannot assign data directly';
  static const String vertexDataRequiredNotNull = 'data require not null';
  static const String vertexDataLazyNotInitialized =
      'lazy data not been initialized';

  ///
  /// general
  ///
  static const String nodeCannotAssignDirectly =
      'cannot assign next general directly';
  static const String nodeNotHoldComparator = 'general not hold comparator';

  static const String lerperNoImplementation = 'lerper no implementation';

  ///
  /// others
  ///
  static String indexOutOfBoundary = 'index out of boundary';
  static String generateByNegative = 'invalid to generate by negative';
  static String modifyImmutable = 'cannot modify immutable value';
}


///
///
///
extension StateErrorExtension on StateError {
  bool not(String message) => this.message != message;
}
///
///
/// this file contains:
///
/// [FErrorMessage]
/// [StateErrorExtension]
///
///
part of '../core.dart';

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
abstract interface class FErrorMessage {
  const FErrorMessage();

  ///
  /// iterator, iterable
  ///
  static const String iteratorNoElement = 'iterator no element';
  static const String iteratorElementNotFound = 'iterator element not found';
  static const String iteratorElementNotNest = 'iterator element not nested';
  static const String iterableBoundaryInvalid = 'iterable boundary invalid';
  static const String iterableSizeInvalid = 'iterable size invalid';

  ///
  /// comparable
  ///
  static String comparableValueNotProvided = 'comparable value not provided';
  static String comparableDisordered = 'comparable disordered';

  ///
  /// vertex
  ///
  static const String vertexDataCannotAssignDirectly =
      'cannot assign data directly';
  static const String vertexDataRequiredNotNull = 'data require not null';
  static const String vertexDataLazyNotInited = 'lazy data not been inited';

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
  static const String indexOutOfBoundary = 'index out of boundary';
  static const String generateByNegative = 'invalid to generate by negative';
  static const String modifyImmutable = 'cannot modify immutable value';
  static const String percentileOutOfBoundary = 'percentile out of boundary';
  static const String unsupportedSwitchCase = 'unsupported switch case';
  static const String intFactorialOverflow =
      'integer factorial over 20 require BigInt';
  static const String numberNatural = 'number is natural';
  static const String regexNotMatchAny = 'regex not match any';

  ///
  ///
  ///
  /// functions
  ///
  ///
  ///
  static String intStoneTakingFinal(
    int n,
    int total,
    int limitLower,
    int limitUpper,
  ) =>
      'invalid stone taking final argument($n, $total, $limitLower, $limitUpper)';

  static String intPascalTriangle(int n, int k) =>
      'invalid pascal triangle argument($n, $k)';

  static String intBinomialCoefficient(int n, int k) =>
      'invalid binomial coefficient argument($n, $k)';

  static String intPartitionM(int m) => 'cannot partition negative integer: $m';

  static String intPartitionN(int m, int n) =>
      'it is impossible to partition $m into $n group';

  static String invalidInteger(int n) => 'invalid integer: $n';

  static String invalidIntegerFromBigInt(BigInt i) =>
      'invalid int from BigInt: $i';

  ///
  /// set
  ///
  static String setNotIdentical<K>(Set<K> a, Set<K> b) =>
      'set not identical:\n$a\n$b';
}

///
///
///
extension StateErrorExtension on StateError {
  bool not(String message) => this.message != message;
}

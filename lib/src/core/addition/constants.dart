///
///
/// this file contains:
///
/// [KMath]
///
///
part of damath_core;

abstract interface class KCore {
  const KCore();

  static const durationMilli1 = Duration(milliseconds: 1);
  static const durationMilli5 = Duration(milliseconds: 5);
  static const durationMilli10 = Duration(milliseconds: 10);
  static const durationMilli100 = Duration(milliseconds: 100);
  static const durationMilli200 = Duration(milliseconds: 200);
  static const durationMilli300 = Duration(milliseconds: 300);
  static const durationMilli400 = Duration(milliseconds: 400);
  static const durationMilli500 = Duration(milliseconds: 500);
  static const durationMilli600 = Duration(milliseconds: 600);
  static const durationMilli700 = Duration(milliseconds: 700);
  static const durationMilli800 = Duration(milliseconds: 800);
  static const durationMilli900 = Duration(milliseconds: 900);
  static const durationSecond1 = Duration(seconds: 1);
  static const durationSecond2 = Duration(seconds: 2);
  static const durationSecond3 = Duration(seconds: 3);
  static const durationSecond4 = Duration(seconds: 4);
  static const durationSecond5 = Duration(seconds: 5);
  static const durationSecond6 = Duration(seconds: 6);
  static const durationSecond7 = Duration(seconds: 7);
  static const durationSecond8 = Duration(seconds: 8);
  static const durationSecond9 = Duration(seconds: 9);
  static const durationSecond10 = Duration(seconds: 10);
  static const durationMin1 = Duration(minutes: 1);
  static const durationMin2 = Duration(minutes: 2);
  static const durationMin3 = Duration(minutes: 3);
  static const durationMin4 = Duration(minutes: 4);
  static const durationMin5 = Duration(minutes: 5);
}

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
  /// node
  ///
  static const String nodeNextCannotAssignDirectly =
      'cannot assign next node directly';
  static const String nodeNotHoldComparator = 'node not hold comparator';

  static const String lerperNoImplementation = 'lerper no implementation';

  ///
  /// others
  ///
  static String indexOutOfBoundary = 'index out of boundary';
  static String generateByNegative = 'invalid to generate by negative';
  static String modifyImmutable = 'cannot modify immutable value';
}

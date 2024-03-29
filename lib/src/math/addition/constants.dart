///
///
/// this file contains:
/// [KMath]
///
///
///
part of damath_math;

abstract interface class KMath {
  const KMath();

  static bool get randomBinary => math.Random().nextBool();

  static double get randomDoubleIn1 => math.Random().nextDouble();

  static int randomIntTo(int max) => math.Random().nextInt(max);

  static double randomDoubleOf(int max, [int digit = 1]) =>
      (math.Random().nextInt(max) * 0.1.powBy(digit)).toDouble();
}
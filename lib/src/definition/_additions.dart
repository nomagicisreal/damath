///
///
/// this file contains:
///
/// [DamathException]
/// [ComparableData]
///
///
/// [Radian]
///
///
/// [Operator]
///
///
/// [Combination]
///
///
/// [DurationFR]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of damath;

class DamathException implements Exception {
  final String message;

  DamathException(this.message);

  @override
  String toString() => "DamathException: $message";
}

//
mixin ComparableData<D extends Comparable, C extends ComparableData<D, C>>
    implements Comparable<C> {
  D get data;

  @override
  int compareTo(C other) => data.compareTo(other.data);

  bool operator >(C other) => Comparable.compare(this, other) == 1;

  bool operator <(C other) => Comparable.compare(this, other) == -1;

  @override
  bool operator ==(covariant C other) => Comparable.compare(this, other) == 0;

  @override
  int get hashCode => data.hashCode;
}

///
///
///
/// [Radian]
///
///
///

///
/// positive radian means clockwise for [Transform] widget and [Offset.direction],
/// but means counterclockwise for math discussion
/// the radian of dart and math are different.
/// See also [Direction], and the comment above [Coordinate.fromDirection]
///
///
/// [angle_001], [angle_01], ...
/// [radianFromAngle], [radianFromRound], ...
/// [complementaryOf], [supplementaryOf], ...
///
/// [ifWithinAngle90_90N], [ifOverAngle90_90N], ...
/// [ifInQuadrant1], [ifInQuadrant2], [ifInQuadrant3], [ifInQuadrant4]
/// [ifOnRight], [ifOnLeft], [ifOnTop], [ifOnBottom]
///

//
class Radian {
  final double value;

  const Radian(this.value);

  Radian.fromAngle(double angle) : value = radianFromAngle(angle);

  Radian.fromRound(double round) : value = radianFromAngle(round);

  static const angle_001 = angle_1 * 0.01;
  static const angle_01 = angle_1 * 0.1;
  static const angle_1 = math.pi / 180;
  static const angle_5 = math.pi / 36;
  static const angle_10 = math.pi / 18;
  static const angle_15 = math.pi / 12;
  static const angle_20 = math.pi / 9;
  static const angle_30 = math.pi / 6;
  static const angle_40 = math.pi * 2 / 9;
  static const angle_45 = math.pi / 4;
  static const angle_50 = math.pi * 5 / 18;
  static const angle_60 = math.pi / 3;
  static const angle_70 = math.pi * 7 / 18;
  static const angle_75 = math.pi * 5 / 12;
  static const angle_80 = math.pi * 4 / 9;
  static const angle_85 = math.pi * 17 / 36;
  static const angle_90 = math.pi / 2;
  static const angle_120 = math.pi * 2 / 3;
  static const angle_135 = math.pi * 3 / 4;
  static const angle_150 = math.pi * 5 / 6;
  static const angle_180 = math.pi;
  static const angle_225 = math.pi * 5 / 4;
  static const angle_240 = math.pi * 4 / 3;
  static const angle_270 = math.pi * 3 / 2;
  static const angle_315 = math.pi * 7 / 4;
  static const angle_360 = math.pi * 2;
  static const angle_390 = math.pi * 13 / 6;
  static const angle_420 = math.pi * 7 / 3;
  static const angle_450 = math.pi * 5 / 2;

  static double radianFromAngle(double angle) => angle * Radian.angle_1;

  static double radianFromRound(double round) => round * Radian.angle_360;

  static double angleOf(double radian) => radian / Radian.angle_1;

  static double roundOf(double radian) => radian / Radian.angle_360;

  static double modulus90AngleOf(double radian) => radian % Radian.angle_90;

  static double modulus180AngleOf(double radian) => radian % Radian.angle_180;

  static double modulus360AngleOf(double radian) => radian % Radian.angle_360;

  ///
  /// [complementaryOf], [supplementaryOf], [restrict180AbsForAngle]
  ///
  static double complementaryOf(double radian) {
    assert(radian.rangeIn(0, Radian.angle_90));
    return radianFromAngle(90 - angleOf(radian));
  }

  static double supplementaryOf(double radian) {
    assert(radian.rangeIn(0, Radian.angle_180));
    return radianFromAngle(180 - angleOf(radian));
  }

  static double restrict180AbsForAngle(double angle) {
    final r = angle % 360;
    return r >= Radian.angle_180 ? r - Radian.angle_360 : r;
  }

  ///
  /// [ifWithinAngle90_90N], [ifOverAngle90_90N], [ifWithinAngle0_180], [ifWithinAngle0_180N]
  ///
  static bool ifWithinAngle90_90N(double radian) =>
      radian.abs() < Radian.angle_90;

  static bool ifOverAngle90_90N(double radian) =>
      radian.abs() > Radian.angle_90;

  static bool ifWithinAngle0_180(double radian) =>
      radian > 0 && radian < Radian.angle_180;

  static bool ifWithinAngle0_180N(double radian) =>
      radian > -Radian.angle_180 && radian < 0;

  ///
  /// [ifInQuadrant1], [ifInQuadrant2], [ifInQuadrant3], [ifInQuadrant4]
  ///
  static bool ifInQuadrant1(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(0, Radian.angle_90) ||
            r.within(-Radian.angle_360, -Radian.angle_270)
        : r.within(Radian.angle_270, Radian.angle_360) ||
            r.within(-Radian.angle_90, 0);
  }

  static bool ifInQuadrant2(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(Radian.angle_90, Radian.angle_180) ||
            r.within(-Radian.angle_270, -Radian.angle_180)
        : r.within(Radian.angle_180, Radian.angle_270) ||
            r.within(-Radian.angle_180, -Radian.angle_90);
  }

  static bool ifInQuadrant3(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(Radian.angle_180, Radian.angle_270) ||
            r.within(-Radian.angle_180, -Radian.angle_90)
        : r.within(Radian.angle_90, Radian.angle_180) ||
            r.within(-Radian.angle_270, -Radian.angle_180);
  }

  static bool ifInQuadrant4(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion
        ? r.within(Radian.angle_270, Radian.angle_360) ||
            r.within(-Radian.angle_90, 0)
        : r.within(0, Radian.angle_90) ||
            r.within(-Radian.angle_360, -Radian.angle_270);
  }

  ///
  /// [ifOnRight], [ifOnLeft], [ifOnTop], [ifOnBottom]
  /// 'right' and 'left' are the same no matter in dart or in math
  ///
  static bool ifOnRight(double radian) =>
      ifWithinAngle90_90N(modulus360AngleOf(radian));

  static bool ifOnLeft(double radian) =>
      ifOverAngle90_90N(modulus360AngleOf(radian));

  static bool ifOnTop(double radian, {bool isInMathDiscussion = false}) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion ? ifWithinAngle0_180(r) : ifWithinAngle0_180N(r);
  }

  static bool ifOnBottom(
    double radian, {
    bool isInMathDiscussion = false,
  }) {
    final r = modulus360AngleOf(radian);
    return isInMathDiscussion ? ifWithinAngle0_180N(r) : ifWithinAngle0_180(r);
  }
}

///
///
///
/// [Operator]
///
///
///

//
enum Operator {
  plus,
  minus,
  multiply,
  divide,
  modulus,
  ;

  @override
  String toString() => switch (this) {
        Operator.plus => '+',
        Operator.minus => '-',
        Operator.multiply => '*',
        Operator.divide => '/',
        Operator.modulus => '%',
      };

  String get latex => switch (this) {
        Operator.plus => r'+',
        Operator.minus => r'-',
        Operator.multiply => r'\times',
        Operator.divide => r'\div',
        Operator.modulus => throw UnimplementedError(),
      };

  ///
  /// latex operation
  ///
  String latexOperationOf(String a, String b) => "$a $latex $b";

  String latexOperationOfDouble(double a, double b, {int fix = 0}) =>
      "${a.toStringAsFixed(fix)} "
      "$latex "
      "${b.toStringAsFixed(fix)}";

  ///
  /// operate value
  ///
  double operateDouble(double a, double b) => switch (this) {
        Operator.plus => a + b,
        Operator.minus => a - b,
        Operator.multiply => a * b,
        Operator.divide => a / b,
        Operator.modulus => a % b,
      };

  static double operateDoubleAll(
    double value,
    Iterable<MapEntry<Operator, double>> operations,
  ) =>
      operations.fold(
        value,
        (a, operation) => switch (operation.key) {
          Operator.plus => a + operation.value,
          Operator.minus => a - operation.value,
          Operator.multiply => a * operation.value,
          Operator.divide => a / operation.value,
          Operator.modulus => a % operation.value,
        },
      );

  Duration operateDuration(Duration a, Duration b) => switch (this) {
        Operator.plus => a + b,
        Operator.minus => a - b,
        _ => throw UnimplementedError(),
      };

  DurationFR operateDurationFR(DurationFR a, DurationFR b) => switch (this) {
        Operator.plus =>
          DurationFR(a.forward + b.forward, a.reverse + b.reverse),
        Operator.minus =>
          DurationFR(a.forward - b.forward, a.reverse - b.reverse),
        _ => throw UnimplementedError(),
      };

  T operationOf<T>(T a, T b) => switch (a) {
        double _ => operateDouble(a, b as double),
        Duration _ => operateDuration(a, b as Duration),
        DurationFR _ => operateDurationFR(a, b as DurationFR),
        _ => throw UnimplementedError(),
      } as T;

  ///
  /// mapper
  ///

  double Function(double value) doubleCompanion(double b) => switch (this) {
        Operator.plus => (a) => a + b,
        Operator.minus => (a) => a - b,
        Operator.multiply => (a) => a * b,
        Operator.divide => (a) => a / b,
        Operator.modulus => (a) => a % b,
      };
}

///
///
///
/// [Combination]
///
///
///

//
class Combination {
  final int m;
  final int n;

  const Combination(this.m, this.n) : assert(m >= 0 && n <= m);

  int get c => IntExtension.binomialCoefficient(m, n + 1);

  int get p => IntExtension.partition(m, n);

  List<List<int>> get pGroups =>
      IntExtension.partitionGroups(m, n)..sortAccordingly();

  @override
  String toString() => 'Combination(\n'
      '($m, $n), c: $c\n'
      'p: $p------${pGroups.fold('', (a, b) => '$a \n $b')}\n'
      ')';
}

///
///
///
/// [DurationFR]
///
///
///

//
class DurationFR {
  final Duration forward;
  final Duration reverse;

  const DurationFR(this.forward, this.reverse);

  const DurationFR.constant(Duration duration)
      : forward = duration,
        reverse = duration;

  static const DurationFR zero = DurationFR.constant(Duration.zero);

  DurationFR operator ~/(int value) =>
      DurationFR(forward ~/ value, reverse ~/ value);

  DurationFR operator +(Duration value) =>
      DurationFR(forward + value, reverse + value);

  DurationFR operator -(Duration value) =>
      DurationFR(forward - value, reverse - value);

  @override
  int get hashCode => Object.hash(forward, reverse);

  @override
  bool operator ==(covariant DurationFR other) => hashCode == other.hashCode;

  @override
  String toString() => 'DurationFR(forward: $forward, reverse:$reverse)';

  ///
  /// constants
  ///

  static const milli100 = DurationFR.constant(KDuration.milli100);
  static const milli300 = DurationFR.constant(KDuration.milli300);
  static const milli500 = DurationFR.constant(KDuration.milli500);
  static const milli800 = DurationFR.constant(KDuration.milli800);
  static const milli1500 = DurationFR.constant(KDuration.milli1500);
  static const milli2500 = DurationFR.constant(KDuration.milli2500);
  static const second1 = DurationFR.constant(KDuration.second1);
  static const second2 = DurationFR.constant(KDuration.second2);
  static const second3 = DurationFR.constant(KDuration.second3);
  static const second4 = DurationFR.constant(KDuration.second4);
  static const second5 = DurationFR.constant(KDuration.second5);
  static const second6 = DurationFR.constant(KDuration.second6);
  static const second7 = DurationFR.constant(KDuration.second7);
  static const second8 = DurationFR.constant(KDuration.second8);
  static const second9 = DurationFR.constant(KDuration.second9);
  static const second10 = DurationFR.constant(KDuration.second10);
  static const second20 = DurationFR.constant(KDuration.second20);
  static const second30 = DurationFR.constant(KDuration.second30);
  static const min1 = DurationFR.constant(KDuration.min1);
}

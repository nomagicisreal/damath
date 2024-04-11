///
///
/// this file contains:
///
/// [NullableExtension]
/// [BoolExtension]
/// [NumExtension]
///
/// [RandomExtension]
///
///
/// 'flutter pub add rational' for rational number
///
///
part of damath_typed_data;

///
/// nullable
///
extension NullableExtension<T> on T? {
  ///
  /// [nullOr]
  /// [nullOrMap]
  ///
  S? nullOr<S>(S value) => this == null ? null : value;

  S? nullOrMap<S>(Mapper<T, S> toVal) => this == null ? null : toVal(this!);

  ///
  /// [applyNotNullOr]
  /// [mapNotNullOr]
  /// [consumeNotNull]
  ///
  T applyNotNullOr(Applier<T> apply, Supplier<T> ifNull) =>
      this == null ? ifNull() : apply(this as T);

  S mapNotNullOr<S>(Mapper<T, S> toVal, Supplier<S> ifNull) =>
      this == null ? ifNull() : toVal(this as T);

  void consumeNotNull(Consumer<T> consume) {
    if (this != null) consume(this as T);
  }

  ///
  /// [expandTo]
  ///
  Iterable<S> expandTo<S>(
      Mapper<T, Iterable<S>> expanding, [
        Supplier<Iterable<S>>? supplyNull,
      ]) =>
      this == null ? supplyNull?.call() ?? Iterable.empty() : expanding(this!);
}

///
///
///
///
extension BoolExtension on bool {
  String get toStringTOrF => this ? 'T' : 'F';
}

///
///
/// static methods:
/// [predicateALess], ...
///
/// instance methods:
/// [squared], [isPositive]
/// [rangeClose], ...
/// [constraintsClose], ...
///
extension NumExtension on num {
  ///
  /// [predicateALess], [predicateALarger]
  ///
  static bool predicateALess(num a, num b) => a < b;

  static bool predicateALarger(num a, num b) => a > b;


  ///
  /// [isPositiveOrZero]
  /// [isPositive]
  /// [squared]
  ///
  bool get isPositiveOrZero => !isNegative;

  bool get isPositive => this > 0;

  num get squared => this * this;

  ///
  /// [powBy]
  ///
  num powBy(num x) => math.pow(x, this);

  ///
  /// [rangeClose]
  /// [rangeOpen], [rangeOpenLower], [rangeOpenUpper]
  ///

  /// [ lower, upper ]
  bool rangeClose(num lower, num upper) => this >= lower && this <= upper;

  /// ( lower, upper )
  bool rangeOpen(num lower, num upper) => this > lower && this < upper;

  /// ( lower, upper ]
  bool rangeOpenLower(num lower, num upper) => this > lower && this <= upper;

  /// [ lower, upper )
  bool rangeOpenUpper(num lower, num upper) => this >= lower && this < upper;

  ///
  /// [constraintsClose]
  /// [constraintsOpen]
  ///
  bool constraintsClose(int begin, int end, [int from = 0]) =>
      from <= begin && begin <= end && end <= this;

  bool constraintsOpen(int begin, int end, [int from = -1]) =>
      from < begin && begin < end && end < this;
}




///
///
///
extension RandomExtension on math.Random {
  static bool get randomBinary => math.Random().nextBool();

  static double get randomDoubleIn1 => math.Random().nextDouble();

  static int randomIntTo(int max) => math.Random().nextInt(max);

  static double randomDoubleOf(int max, [int digit = 1]) =>
      (math.Random().nextInt(max) * 0.1.powBy(digit)).toDouble();
}
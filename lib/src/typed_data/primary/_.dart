///
///
/// this file contains:
///
/// [NullableExtension]
/// [BoolExtension]
/// [TypeExtension]
///
/// [NumExtension]
/// [BigIntExtension]
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
///
extension TypeExtension on Type {
  ///
  ///
  /// '_TypeError' is happened when something like
  ///   - invoke typed [Iterator.current], but there is no current value
  /// ...
  ///
  bool get isErrorTypeError => toString() == '_TypeError';
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
/// [digit], ...
///
extension NumExtension on num {
  ///
  /// logarithm base 10 for primes within 100 in 20 digit
  ///
  static const num log10_2 = 0.30102999566398114251; // math.ln2 / math.ln10;
  static const num log10_3 = 0.47712125471966243540;
  static const num log10_5 = 0.69897000433601874647;
  static const num log10_7 = 0.84509804001425670172;
  static const num log10_11 = 1.04139268515822491779;
  static const num log10_13 = 1.11394335230683672044;
  static const num log10_17 = 1.23044892137827388545;
  static const num log10_19 = 1.27875360095282886164;
  static const num log10_23 = 1.36172783601759284089;
  static const num log10_29 = 1.46239799789895608129;
  static const num log10_31 = 1.49136169383427263924;
  static const num log10_37 = 1.56820172406699476220;
  static const num log10_41 = 1.61278385671973545357;
  static const num log10_43 = 1.63346845557958642026;
  static const num log10_47 = 1.67209785793571730217;
  static const num log10_53 = 1.72427586960078893519;
  static const num log10_59 = 1.77085201164214423031;
  static const num log10_61 = 1.78532983501076691901;
  static const num log10_67 = 1.82607480270082622731;
  static const num log10_71 = 1.85125834871907501977;
  static const num log10_73 = 1.86332286012045567070;
  static const num log10_79 = 1.89762709129044115919;
  static const num log10_83 = 1.91907809237607396291;
  static const num log10_89 = 1.94939000664491257631;
  static const num log10_97 = 1.98677173426624475994;

  ///
  /// [predicateALess], [predicateALarger]
  ///
  static bool predicateALess(num a, num b) => a < b;

  static bool predicateALarger(num a, num b) => a > b;

  ///
  /// [digit]
  ///
  int get digit {
    if (this == 0) return 0;
    var value = abs();
    var n = 0;
    for (; value >= 1; value /= 10, n++) {}
    return n;
  }

  ///
  /// [isPositiveOrZero]
  /// [isPositive]
  /// [squared]
  ///
  bool get isPositive => this > 0;

  bool get isPositiveOrZero => !isNegative;

  num get squared => this * this;

  ///
  /// [powBy]
  ///
  num powBy(num x) => math.pow(x, this);

  ///
  /// [rangeClose]
  /// [rangeOpen], [rangeOpenLower], [rangeOpenUpper]
  ///
  /// [outsideClose]
  /// [outsideOpen], [outsideOpenLower], [outsideOpenUpper]
  ///

  /// [ lower, upper ]
  bool rangeClose(num lower, num upper) => this >= lower && this <= upper;

  /// ( lower, upper )
  /// ( lower, upper ]
  /// [ lower, upper )
  bool rangeOpen(num lower, num upper) => this > lower && this < upper;

  bool rangeOpenLower(num lower, num upper) => this > lower && this <= upper;

  bool rangeOpenUpper(num lower, num upper) => this >= lower && this < upper;

  ///
  /// reverse to range
  ///
  bool outsideClose(num lower, num upper) => this <= lower || this >= upper;

  bool outsideOpen(num lower, num upper) => this < lower || this > upper;

  bool outsideOpenLower(num lower, num upper) => this < lower || this >= upper;

  bool outsideOpenUpper(num lower, num upper) => this <= lower || this > upper;

  ///
  /// [constraintsClose]
  /// [constraintsOpen]
  ///
  bool constraintsClose(int start, int end, [int from = 0]) =>
      from <= start && start < end && end <= this;

  bool constraintsOpen(int start, int end, [int from = 0]) =>
      from < start && start < end && end < this;
}

///
///
/// see also [IntExtension.isCoprime], ...
///
extension BigIntExtension on BigInt {
  ///
  /// [toIntValidated]
  /// [validateThenMap]
  ///
  int get toIntValidated => isValidInt
      ? toInt()
      : throw StateError(FErrorMessage.invalidIntegerFromBigInt(this));

  S validateThenMap<S>(Mapper<int, S> toVal) => isValidInt
      ? toVal(toInt())
      : throw StateError(FErrorMessage.invalidIntegerFromBigInt(this));

  ///
  ///
  /// [isPrime], [isComposite]
  ///
  /// see also [IntExtension.isPrime], ...
  ///
  bool get isPrime {
    if (this < BigInt.two) return false;
    if (this == BigInt.two || this == 3.toBigInt) return true;
    if (isEven) return false;
    return validateThenMap((value) {
      final max = math.sqrt(value);
      if (max.isInteger) return false;
      final m = BigInt.from(max);
      for (var i = 3.toBigInt; i < m; i += BigInt.two) {
        if (this % i == BigInt.zero) return false;
      }
      return true;
    });
  }

  bool get isComposite {
    if (this < BigInt.two) return false;
    if (isEven) return true;
    return validateThenMap((value) {
      final max = math.sqrt(value);
      if (max.isInteger) return true;
      final m = BigInt.from(max);
      for (var i = 3.toBigInt; i < m; i += BigInt.two) {
        if (this % i == BigInt.zero) return true;
      }
      return false;
    });
  }

  ///
  /// [isCoprime], [modInverseOrNull]
  ///
  bool isCoprime(BigInt other) => gcd(other) == BigInt.one;

  BigInt? modInverseOrNull(BigInt other) =>
      isCoprime(other) ? modInverse(other) : null;

  ///
  /// [isPseudoPrimeTo]
  ///
  // 561 is Carmichael Number (is pseudo prime for all Z)
  bool isPseudoPrimeTo(BigInt base) =>
      isComposite &&
      gcd(base) == BigInt.one &&
      (base.pow((this - BigInt.one).toIntValidated) - BigInt.one) % this ==
          BigInt.zero;
}

///
///
///
extension RandomExtension on math.Random {
  ///
  /// primary
  ///
  static bool get binary => math.Random().nextBool();

  static double get doubleIn1 => math.Random().nextDouble();

  static int intTo(int max) => math.Random().nextInt(max);

  static double doubleOf(int max, [int digit = 1]) =>
      (math.Random().nextInt(max) * 0.1.powBy(digit)).toDouble();

  ///
  /// list
  ///
  static List<double> sample(int length, [math.Random? random]) =>
      List.generate(length, FMapper.intToDouble)..shuffle(random);
}

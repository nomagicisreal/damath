///
///
/// this file contains:
///
/// [NumExtension], [DoubleExtension], [IntExtension]
///
/// [DurationExtension], [DateTimeExtension]
///
/// [NullableExtension]
/// [StringExtension], [MatchExtension]
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
///
///
///
///
part of damath;

///
///
/// [square]
/// [rangeIn], [rangeFromMaxTo], [rangeFromMinTo], [within]
/// [isLowerOrEqualTo], [isHigherOrEqualTo]
/// [isLowerOneOrEqualTo], [isHigherOneOrEqualTo]
///
///
extension NumExtension on num {
  num get square => math.pow(this, 2);

  bool rangeIn(num min, num max) => this >= min && this <= max;

  bool rangeFromMaxTo(num max, num min) => this > min && this <= max;

  bool rangeFromMinTo(num min, num max) => this >= min && this < max;

  bool within(num min, num max) => this > min && this < max;

  bool isLowerOrEqualTo(num value) => this == value || this < value;

  bool isHigherOrEqualTo(num value) => this == value || this > value;

  bool isLowerOneOrEqualTo(num value) => this == value || this + 1 == value;

  bool isHigherOneOrEqualTo(num value) => this == value || this == value + 1;
}

///
///
/// [sqrt2], ...
/// [isNearlyInt]
///
/// [proximateInfinityOf], [proximateNegativeInfinityOf]
/// [infinity2_31], ...
/// [filterInfinity]
///
///
extension DoubleExtension on double {
  static const double sqrt2 = math.sqrt2;
  static const double sqrt3 = 1.7320508075688772;
  static const double sqrt5 = 2.23606797749979;
  static const double sqrt6 = 2.44948974278317;
  static const double sqrt7 = 2.6457513110645907;
  static const double sqrt8 = 2.8284271247461903;
  static const double sqrt10 = 3.1622776601683795;
  static const double sqrt1_2 = math.sqrt1_2;
  static const double sqrt1_3 = 0.5773502691896257;
  static const double sqrt1_5 = 0.4472135954999579;
  static const double sqrt1_6 = 0.408248290463863;
  static const double sqrt1_7 = 0.3779644730092272;
  static const double sqrt1_8 = 0.3535533905932738;
  static const double sqrt1_10 = 0.31622776601683794;

  bool get isNearlyInt => (ceil() - this) <= 0.01;

  ///
  /// infinity usages
  ///
  static double proximateInfinityOf(double precision) =>
      1.0 / math.pow(0.1, precision);

  static double proximateNegativeInfinityOf(double precision) =>
      -1.0 / math.pow(0.1, precision);

  static final double infinity2_31 = proximateInfinityOf(2.31);
  static final double infinity3_2 = proximateInfinityOf(3.2);

  double filterInfinity(double precision) => switch (this) {
        double.infinity => proximateInfinityOf(precision),
        double.negativeInfinity => proximateNegativeInfinityOf(precision),
        _ => this,
      };
}

///
/// instance methods, getters:
/// [isPositive]
/// [accumulate], [factorial]
/// [digit], [digitFirst]
///
/// static methods:
/// [accumulation]
/// [fibonacci]
/// [pascalTriangle]
/// [binomialCoefficient]
/// [partition], [partitionOf], [partitionGroups]
///
///
extension IntExtension on int {
  bool get isPositiveOrZero => !isNegative;

  bool get isPositive => !isNegative && this != 0;

  int get accumulate {
    assert(isPositiveOrZero, 'invalid accumulate integer: $this');
    int accelerator = 0;
    for (var i = 1; i <= this; i++) {
      accelerator += i;
    }
    return accelerator;
  }

  int get factorial {
    assert(isPositive, 'invalid factorial integer: $this');
    int accelerator = 1;
    for (var i = 1; i <= this; i++) {
      accelerator *= i;
    }
    return accelerator;
  }

  int digit({int carry = 10}) {
    int value = abs();
    int d = 0;
    for (var i = 1; i < value; i *= carry, d++) {}
    return d;
  }

  int digitFirst({int carry = 10}) {
    final value = math.pow(carry, digit(carry: carry) - 1).toInt();
    int i = 0;
    for (; value * i < this; i++) {}
    return i - 1;
  }

  ///
  /// [1, 3, 6, 10, 15, ...]
  ///
  static List<int> accumulation(int end, {int start = 0}) {
    final list = <int>[];
    for (int i = start; i <= end; i++) {
      list.add(i.accumulate);
    }
    return list;
  }

  ///
  /// [fibonacci] calculate the sequence be like: 1, 1, 2, 3, 5, 8, 13, ...
  /// when [k] == 1, return 1
  /// when [k] == 2, return 1
  /// when [k] == 3, return 2
  /// ...
  ///
  static int fibonacci(int k) {
    assert(k > 0);
    int a = 0;
    int b = 1;

    for (var i = 2; i <= k; i++) {
      final next = a + b;
      a = b;
      b = next;
    }
    return b;
  }

  ///
  /// [pascalTriangle] calculate the 2D array like
  /// 1,
  /// 1, 1
  /// 1, 2, 1
  /// 1, 3, 3, 1
  /// 1, 4, 6, 4, 1
  /// 1, 5, 10, 10, 5, 1
  /// 1, 6, 15, 20, 15, 6, 1 ...,
  /// and this function do
  /// 1. create temporary [Array2D], for example,
  ///   row0: [1, 2, 1, 0, 0, 0]
  ///   row1: [1, 3, 3, 1, 0, 0]
  ///   row2: [1, 4, 0, 4, 1, 0]
  ///   row3: [1, 5, 0, 0, 5, 1] ...
  /// 2. replace 'middle 0' with the correct value. for example,
  ///   row0: [1, 2, 1, 0, 0, 0]
  ///   row1: [1, 3, 3, 1, 0, 0]
  ///   row2: [1, 4, 6, 4, 1, 0]
  ///   row3: [1, 5, 10, 10, 5, 1] ...
  /// 3. return [Array2D]
  ///
  /// when [rowStart] == 2, return array be like:
  ///   row0: [1, 2, 1, 0, ....]
  ///   row1: [1, 3, 3, 1, ....]
  ///   row2: [1, 4, 6, 4, ....] ...
  /// when [rowStart] == 3, return array be like:
  ///   row0: [1, 3, 3, 1, ....]
  ///   row1: [1, 4, 6, 4, ....]
  ///   row2: [1, 5, 10, 10, ....] ...
  /// ...
  ///
  static List<List<int>> pascalTriangle(
    int n,
    int k, {
    int rowStart = 0,
    bool isColumnEndAtK = true,
  }) {
    assert(
      n > 0 && k > 0 && k <= n + 1 && rowStart < 4,
      throw ArgumentError('($n, $k)'),
    );

    final rowEnd = n + 1 - rowStart;
    final columnEndOf =
        isColumnEndAtK ? (i) => i + rowStart < k ? i + 1 : k : (i) => i + 1;

    final array = ListExtension.generate2D<int>(
      rowEnd,
      k,
      (i, j) => j == 0 || j == i + rowStart
          ? 1
          : j == 1 || j == i + rowStart - 1
              ? i + rowStart
              : 0,
    );

    for (int i = 4 - rowStart; i < rowEnd; i++) {
      final bound = columnEndOf(i);
      for (int j = 2; j < bound; j++) {
        array[i][j] = array[i - 1][j - 1] + array[i - 1][j];
      }
    }
    return array;
  }

  ///
  ///
  /// [binomialCoefficient], [_binomialCoefficient]
  ///
  ///

  ///
  /// [binomialCoefficient]

  ///
  /// see the comment above [_binomialCoefficient] for implementation detail
  ///
  static int binomialCoefficient(int n, int k) {
    assert(
      n > 0 && k > 0 && k <= n + 1,
      throw ArgumentError('binomial coefficient for ($n, $k)'),
    );
    return k == 1 || k == n + 1
        ? 1
        : k == 2 || k == n
            ? n
            : _binomialCoefficient(n, k);
  }

  ///
  /// Let "row( [n] )" be list of binomial coefficient, for example:
  ///   row( 2 ) = [1, 2, 1]
  ///   row( 3 ) = [1, 3, 3, 1]
  ///
  /// Let "floor" represents all the essential values in a "row", for example, when ([n] = 10, [k] = 9),
  ///   row( 8 ) = [... 28,    8,    1]
  ///   row( 9 ) = [...  ?,   36,    9]
  ///   row( 10 ) = [...  ?,    ?,   45]
  /// Because '45' comes from '36+9', '36' comes from '18+8', '9' comes from '8+1',
  /// it's redundant to calculate '?', which are unnecessary values. solution for it required the values below:
  ///   floor( 2 ) = [1, 2, 1]
  ///   floor( 3 ) = [3, 3, 1]
  ///   floor( 4 ) = [6,  4,  1]
  ///   floor( 5 ) = [10,  5,  1]
  ///   floor( 6 ) = [15,  6,  1]
  ///   floor( 7 ) = [21,  7,  1]
  ///   floor( 8 ) = [28,  8,  1]
  ///   floor( 9 ) = [36,  9]
  ///   floor( 10 ) = [45]
  ///
  /// the description below are variables used in this function, describes how it works
  /// [fEnd] --- the last floor that corresponding row([fEnd])[k] is 1.
  ///   take the sample above ([n] == 10, [k] == 9) for example,
  ///     floor(10) = [45],
  ///     floor(9) = [36,  9],
  ///     floor(8) = [28,  8,  1]
  ///     floor(8) is the last floor that row(8)[9] == 1,
  ///     [fEnd] == 8 #.
  ///   if takes more example, it turns out that [fEnd] = k - 1 #
  ///
  /// [fBegin] --- the first floor that "floor.length" == floor([fEnd]).length,
  ///   take the sample above ([n] = 10, [k] = 9) for example,
  ///     floor([fEnd]) == floor(8)
  ///     3 == floor(8).length == floor(7).length == floor(6).length == ... == floor(2).length
  ///     floor(2) is the first floor that floor.length == floor(8).length
  ///     [fBegin] = 2 #
  ///   if takes more example, it will turn out that [fBegin] = n - [fEnd] #
  ///
  static int _binomialCoefficient(int n, int k) {
    assert(n > 2 && k > 0 && k <= n + 1, throw ArgumentError('($n, $k)'));

    final currentFloor = <int>[1, 2, 1];
    final fEnd = k - 1;
    final fBegin = n - fEnd;
    List<int> floorOf(int f) {
      final length = currentFloor.length;
      return <int>[
        if (f <= fBegin) 1,
        for (var j = 1; j < length; j++) currentFloor[j - 1] + currentFloor[j],
        if (f <= fEnd) 1,
      ];
    }

    for (var f = 3; f < n; f++) {
      final floor = floorOf(f);
      currentFloor
        ..clear()
        ..addAll(floor);
    }
    return floorOf(n).first;
  }

  ///
  /// Generally, these methods return the possible partition of an integer [m],
  /// [partition]
  /// [partitionOf]
  /// [partitionGroups]
  ///
  /// and these private methods are the implementation of those methods
  /// [_partition]
  /// [_partitionSpace]
  /// [_partitionElementGenerator]
  /// [_partitionSearchOnFloor]
  ///
  /// see the comment under [partitionGroups], above [_partition] to understand the implement logic
  /// see also https://en.wikipedia.org/wiki/Partition_(number_theory) for academic definition
  ///

  ///
  /// [partition] return the possible partition in [n] group for an integer [m],
  /// and each group must not be empty.
  ///
  /// for example, when [m] = 7, [n] = 4, this function returns 3 because there are 3 possible partition:
  /// [4, 1, 1, 1]
  /// [3, 2, 1, 1]
  /// [2, 2, 2, 1]
  ///
  static int partition(int m, int n) {
    assert(
      m.isPositiveOrZero && n <= m,
      'it is impossible to partition $m into $n group',
    );
    return _partition(m, n, space: _partitionSpace<int>(m, n: n));
  }

  ///
  /// [partitionOf] return the possible partitions for an integer [m],
  /// and each group must not be empty.
  ///
  /// for example, when [m] = 5, this function return 7 because there are 7 possible partition for 5:
  /// (5)
  /// (4, 1)
  /// (3, 2)
  /// (3, 1, 1)
  /// (2, 2, 1)
  /// (2, 1, 1, 1)
  /// (1, 1, 1, 1, 1)
  ///
  static int partitionOf(int m) {
    assert(m.isPositiveOrZero, 'it is impossible to partition $m');
    final pSpace = _partitionSpace<int>(m);
    return Iterable.generate(
      m,
      (i) => _partition<int>(m, i + 1, space: pSpace),
    ).reduce((p1, p2) => p1 + p2);
  }

  ///
  /// [partitionGroups] return entire groups of possible partition,
  /// and each group must not be empty.
  ///
  /// for example, when [m] = 8, [n] = 4, this function returns [
  ///   [5, 1, 1, 1],
  ///   [4, 2, 1, 1],
  ///   [3, 3, 1, 1],
  ///   [3, 2, 2, 1],
  ///   [2, 2, 2, 2],
  /// ]
  ///
  static List<List<int>> partitionGroups(int m, int n) {
    assert(
      m.isPositiveOrZero && n <= m,
      'it is impossible to partition $m into $n group',
    );
    final groups = _partition(
      m,
      n,
      space: _partitionSpace<List<List<int>>>(m, n: n),
    );
    assert(groups.every((element) => element.length == n), 'runtime error');
    return groups;
  }

  ///
  /// The "row" concept in here helps to calculate values in more efficient way. definition:
  ///   row( 2 ) = [1, 1, 1]
  ///   row( 3 ) = [1, 1, 1, 1]
  /// because there is only 1 way to partition integer 2 into 0 group, 1 group or 2 group,
  /// and there is also only 1 way to partition integer 3 into 0 group, 1 group, 2 group, 3 group.
  /// based on "row" concept, the return value or the answer is equivalent to row([m])([n]).
  ///
  /// To find out the answer, we have to repeat a step:
  /// calculating row( i )( j ) by summarizing row( i-j )( 1 ) to row( i-j )( min(i-j, j) ),
  /// and in the first step, i = [m], j = [n].
  ///   - Take i = 10, j = 7 for example,
  ///     it means that there are 10 same elements have to be partitioned into 7 group.
  ///     Because each group must have 1 element at least,
  ///     we have to consider how many possible partition in 7 group actually for 3 (i-j) element.
  ///     That is, it's possible that 3 elements partitioned into 1 group, 2 group, 3 group. (1 to i-j),
  ///     so the summarize of row(3)(1) to row(3)(3) is the answer.
  ///
  ///   - Take i = 20, j = 7 for example,
  ///     it means that there are 20 same elements have to be partitioned into 7 group.
  ///     Because we have to consider how many possible partition in 7 group actually for 13 (i-j) element.
  ///     it's possible that 13 elements partitioned into 1 group, 2 group, ... 7 group. (1 to j)
  ///
  /// Let "floor" correspond to "row" and contains all the essential values of corresponding row.
  /// Let "target floor" represents "floor( [m]-[n] )". In convenient of discussion,
  /// all the index blow starts by 1, because [n] = 0 not in the consideration of this function.
  ///
  /// Take ([m] = 10, [n] = 4) for example, the description below shows how to use the "floors",
  ///   row(10)(4) = floor(6)(1) + ... + floor(6)(4)
  ///     floor(6)(1) = 1
  ///     floor(6)(2) = floor(4)(1) + ... + floor(4)(2)
  ///     floor(6)(3) = floor(3)(1) + ... + floor(3)(3)
  ///     floor(6)(4) = floor(2)(1) + ... + floor(2)(2)
  ///       floor(4)(1) + floor(4)(2) = floor(4)(1) + floor(2)(1) + floor(2)(2) = 1 + 1 + 1 = 3
  ///       floor(3)(1) + floor(3)(2) + floor(3)(3) = 1 + 1 + 1 = 3
  ///       floor(2)(1) + floor(2)(2) = 1 + 1 = 2
  ///   row(10)(4) = floor(6)(1) + ... + floor(6)(5) = 1 + 3 + 3 + 2 = 9 #
  /// during the calculation, the required floors are:
  ///   floor( 2 ) = [1, 1]
  ///   floor( 3 ) = [1, 1, 1]
  ///   floor( 4 ) = [1, 2]
  ///   floor( 6 ) = [1, 3, 3, 2] (this floor is target floor)
  /// with those "floor", we can get the answer of ([m] = 10, [n] = 4).
  ///
  /// [_partition] implementation is based on the discussion above
  /// [_partitionSpace] for [space] helps to prevent invoking [elementOf] in [_partition] redundantly.
  /// [_partitionElementGenerator] is the generator to find row element
  /// [_partitionSearchOnFloor] is a way to find out where a row element comes from
  ///
  ///

  ///
  ///
  static P _partition<P>(
    int m,
    int n, {
    required List<List<P>> space,
  }) =>
      switch (space) {
        List<List<int>>() => () {
            final partitionSpace = space as List<List<int>>;
            late final Reducer<int> elementOf;

            int instancesOf(int i, int j) {
              int sum = 1;
              _partitionSearchOnFloor<int>(
                i,
                j,
                space: partitionSpace,
                elementOf: elementOf,
                predicate: (p) => p == 1,
                consume: (p) => sum += p,
                trailing: (_) => sum++,
              );
              return sum;
            }

            elementOf = _partitionElementGenerator(
              atFirst: FGenerator.fill2D(1),
              atLast: FGenerator.fill2D(1),
              atLastPrevious: FGenerator.fill2D(1),
              instancesOf: instancesOf,
            );

            return elementOf(m, n);
          }(),
        List<List<Iterable<List<int>>>>() => () {
            final partitionSpace = space as List<List<Iterable<List<int>>>>;
            late final Generator2D<Iterable<List<int>>> elementOf;

            print('($m, $n)');

            List<int> firstOf(int n) => [n];
            List<int> lastOf(int n) => List.filled(n, 1, growable: true);
            List<int> lastPreviousOf(int n) => [2, ...List.filled(n - 2, 1)];

            Iterable<List<int>> instancesOf(int i, int j) {
              final instances = [firstOf(i)];
              _partitionSearchOnFloor<Iterable<List<int>>>(
                i,
                j,
                space: partitionSpace,
                elementOf: elementOf,
                predicate: (p) => p.isEmpty,
                consume: (p) => instances.addAll(p),
                trailing: (current) => instances.add(
                  (current == i ? lastOf(i) : lastPreviousOf(i)),
                ),
              );
              return instances;
            }

            elementOf = _partitionElementGenerator(
              atFirst: (i, j) => [firstOf(i)],
              atLast: (i, j) => [lastOf(j)],
              atLastPrevious: (i, j) => [lastPreviousOf(j)],
              instancesOf: (i, j) {
                final instances = instancesOf(i, j);
                final result = <List<int>>[];
                for (var instance in instances) {
                  result.add([
                    ...instance.map((element) => element + 1),
                    ...Iterable.generate(j - instance.length, (_) => 1),
                  ]);
                }
                return result;
              },
            );

            return elementOf(m, n);
          }(),
        _ => throw UnimplementedError(),
      } as P;

  ///
  /// [_partitionSpace] specify how much space a [_partition] needs.
  /// with predicator, it can prevent calculation for the same value in [_partitionSearchOnFloor].
  /// the values inside [List]<[List]<[P]>> will update during the loop if:
  ///   [P] == [int] && element is 1
  ///   [P] == [int] && element is empty
  ///
  /// the return space row must start from row(4) to row(i), correspond to list[0] to list[i-4]
  /// the return space column must start from row(i)(2) to row(i)(j), correspond to list[i][0] to list[i][j-2]
  ///
  /// instead of [List.filled], using [List.generate] prevents shared instance for list
  ///
  static List<List<P>> _partitionSpace<P>(int m, {int? n}) {
    final spaceRow = math.max(0, m - 3 - (n ?? 0));
    final Generator<P> generator = P == int
        ? (_) => 1 as P
        : (P == List<List<int>>)
            ? (_) => <List<int>>[] as P
            : throw UnimplementedError(
                'generic type must be int or Iterable<List<int>>, current: $P',
              );
    return List.generate(
      spaceRow,
      n == null
          ? (f) => List.generate(math.min(f + 1, spaceRow - f), generator)
          : (f) => List.generate(math.min(f + 1, n), generator),
    );
  }

  ///
  ///
  static Generator2D<T> _partitionElementGenerator<T>({
    required Generator2D<T> atFirst,
    required Generator2D<T> atLast,
    required Generator2D<T> atLastPrevious,
    required Generator2D<T> instancesOf,
  }) =>
      (i, j) {
        if (j == 1) return atFirst(i, j);
        if (j == i) return atLast(i, j);
        if (j == i - 1) return atLastPrevious(i, j);
        return instancesOf(i - j, j);
      };

  ///
  ///
  static void _partitionSearchOnFloor<P>(
    int i,
    int j, {
    required List<List<P>> space,
    required Generator2D<P> elementOf,
    required Predicator<P> predicate,
    required void Function(P instance) consume,
    required void Function(int current) trailing,
  }) {
    final min = math.min(i, j);
    final bound = min == i
        ? math.max(1, min - 2)
        : min == i - 1
            ? min - 1
            : min;
    for (var k = 2; k <= bound; k++) {
      P p = space[i - 4][k - 2];
      if (predicate(p)) p = space[i - 4][k - 2] = elementOf(i, k);
      consume(p);
    }
    for (var current = bound + 1; current <= min; current++) {
      trailing(current);
    }
  }
}

///
/// duration
///
extension DurationExtension on Duration {
  String toStringDayMinuteSecond({String splitter = ':'}) {
    final dayMinuteSecond = toString().substring(0, 7);
    return splitter == ":"
        ? dayMinuteSecond
        : dayMinuteSecond.splitMapJoin(RegExp(':'), onMatch: (_) => splitter);
  }
}


///
/// datetime
///
extension DateTimeExtension on DateTime {
  static bool isSameDay(DateTime? a, DateTime? b) => a == null || b == null
      ? false
      : a.year == b.year && a.month == b.month && a.day == b.day;

  String get date => toString().split(' ').first; // $y-$m-$d

  String get time => toString().split(' ').last; // $h:$min:$sec.$ms$us

  int get monthDays => switch (month) {
    1 => 31,
    2 => year % 4 == 0
        ? year % 100 == 0
        ? year % 400 == 0
        ? 29
        : 28
        : 29
        : 28,
    3 => 31,
    4 => 30,
    5 => 31,
    6 => 30,
    7 => 31,
    8 => 31,
    9 => 30,
    10 => 31,
    11 => 30,
    12 => 31,
    _ => throw UnimplementedError(),
  };

  static String parseTimestampOf(String string) =>
      DateTime.fromMillisecondsSinceEpoch(int.parse(string)).toIso8601String();
}

///
/// nullable
///
extension NullableExtension<T> on T? {
  S? nullOr<S>(S value) => this == null ? null : value;

  S? nullOrTranslate<S>(Translator<T, S> value) =>
      this == null ? null : value(this as T);

  S translateOr<S>(
      Translator<T, S> translate, {
        required Supplier<S> ifAbsent,
      }) {
    final value = this;
    return value == null ? ifAbsent() : translate(value);
  }
}

///
/// string
///
extension StringExtension on String {
  String get lowercaseFirstChar => replaceFirstMapped(
      RegExp(r'[A-Z]'), (match) => match.group0.toLowerCase());

  MapEntry<String, String> get splitByFirstSpace {
    late final String key;
    final value = replaceFirstMapped(RegExp(r'\w '), (match) {
      key = match.group0.trim();
      return '';
    });
    return MapEntry(key, value);
  }

  ///
  /// camel, underscore usage
  ///

  String get fromUnderscoreToCamelBody => splitMapJoin(RegExp(r'_[a-z]'),
      onMatch: (match) => match.group0[1].toUpperCase());

  String get fromCamelToUnderscore =>
      lowercaseFirstChar.splitMapJoin(RegExp(r'[a-z][A-Z]'), onMatch: (match) {
        final s = match.group0;
        return '${s[0]}_${s[1].toLowerCase()}';
      });
}

/// match
extension MatchExtension on Match {
  String get group0 => group(0)!;
}

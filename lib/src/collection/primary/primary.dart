///
///
/// this file contains:
///
/// [IteratorBool]
/// [IteratorComparable]
/// [IteratorDouble]
/// [IterableMapEntry]
///
/// [IterableComparable]
/// [IterableDouble]
/// [IterableInt]
///
///
/// [ListComparable]
/// [ListDouble]
///
///
/// 'flutter pub add statistics' for advance statistic analyze
///
///
part of damath_collection;

///
/// static methods:
/// [_keep], ...
///
/// instance getters, methods:
/// [isSatisfiable], ...
///
///
extension IteratorBool on Iterator<bool> {
  static bool _keep(bool value) => value;

  static bool _reverse(bool value) => !value;

  ///
  /// [isSatisfiable], [isTautology], [isContradiction], [isContingency]
  ///
  bool get isSatisfiable => any(_keep);

  bool get isTautology => !any(_reverse);

  bool get isContradiction => !any(_keep);

  bool get isContingency => existDifferent;
}

///
/// static methods:
/// [isEqual], ...
/// [comparator], [compare]
/// [_validationFor], ...
/// [_errorIteratorDisorder], ...
///
/// instance methods:
/// [isSorted], ...
///
///
extension IteratorComparable<C extends Comparable> on Iterator<C> {
  ///
  /// [isEqual], [notEqual]
  /// [isIncrease], [isDecrease]
  /// [notIncrease], [notDecrease]
  ///
  // require a == b
  static bool isEqual<C extends Comparable>(C a, C b) => a.compareTo(b) == 0;

  // require a != b
  static bool notEqual<C extends Comparable>(C a, C b) => a.compareTo(b) != 0;

  // require a < b
  static bool isIncrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) == -1;

// require a > b
  static bool isDecrease<C extends Comparable>(C a, C b) => a.compareTo(b) == 1;

  // require a >= b
  static bool notIncrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) != -1;

  // require a <= b
  static bool notDecrease<C extends Comparable>(C a, C b) =>
      a.compareTo(b) != 1;

  ///
  /// [comparator], [compare]
  ///
  static Comparator<C> comparator<C extends Comparable>(bool increase) =>
      increase ? Comparable.compare : compare;

  /// it is the reverse version of [Comparable.compare]
  static int compare<C extends Comparable>(C a, C b) => b.compareTo(a);

  ///
  /// [_validationFor]
  /// in convention, the validation for [PredicatorCombiner] should pass in order of (lower, upper)
  ///
  static PredicatorCombiner<C> _validationFor<C extends Comparable>(
    bool increase,
    bool close,
  ) =>
      close
          ? increase
              ? notDecrease
              : notIncrease
          : increase
              ? isIncrease
              : isDecrease;

  ///
  /// [_errorIteratorDisorder]
  ///
  static StateError _errorIteratorDisorder() => StateError('iterator disorder');

  ///
  /// [isSorted]
  /// [checkSortedForSupply]
  ///
  bool isSorted([bool increase = true]) =>
      !exist(_validationFor(increase, true));

  S checkSortedForSupply<S>(Supplier<S> supply, [bool increase = true]) =>
      isSorted(increase) ? supply() : throw _errorIteratorDisorder();
}

///
///
/// static methods:
/// [maxDistance], ...
///
/// instance methods:
/// [min], ...
/// [sum], ...
/// [distance], ...
///
/// [abs], ...
/// [interDistanceTo], ...
///
///
///
extension IteratorDouble on Iterator<double> {
  ///
  /// iterator
  ///
  static Iterator<double> maxDistance(Iterator<double> a, Iterator<double> b) =>
      a.distance > b.distance ? a : b;

  static Iterator<double> minDoubleDistance(
          Iterator<double> a, Iterator<double> b) =>
      a.distance < b.distance ? a : b;

  ///
  /// [min], [max], [mode]
  /// [range], [boundary]
  ///
  double get min => reduce(FReducer.doubleMin);

  double get max => reduce(FReducer.doubleMax);

  double get mode => toMapCounted.reduce(FReducer.entryValueIntMax).key;

  double get range => moveNextApply((value) {
        var min = value;
        var max = value;
        while (moveNext()) {
          if (current < min) min = current;
          if (current > max) max = current;
        }
        return max - min;
      });

  (double, double) get boundary => moveNextSupply(() {
        var min = current;
        var max = current;
        while (moveNext()) {
          if (current < min) min = current;
          if (current > max) max = current;
        }
        return (min, max);
      });

  ///
  /// [sum], [sumSquared]
  /// [meanArithmetic], [meanGeometric]
  ///
  double get sum => reduce(FReducer.doubleAdd);

  double get sumSquared => reduce(FReducer.doubleAddSquared);

  double get meanArithmetic => moveNextApply((total) {
        var length = 1;
        while (moveNext()) {
          total += current;
          length++;
        }
        return total / length;
      });

  double get meanGeometric => moveNextApply((total) {
        var length = 1;
        while (moveNext()) {
          total *= current;
          length++;
        }
        return math.pow(total, 1 / length).toDouble();
      });

  ///
  /// [distance], [volume]
  ///
  double get distance => math.sqrt(reduce(FReducer.doubleAddSquared));

  double get volume => reduce(FReducer.doubleMultiply);

  ///
  /// [abs], [rounded], [roundUpTo]
  /// [takeAllPlus], [takeAllSubtract], [takeAllMultiply], [takeAllDivide], [takeAllDivideToInt]
  ///
  Iterable<double> get abs => takeAllApply((v) => v.abs());

  Iterable<double> get rounded => takeAllApply((v) => v.roundToDouble());

  Iterable<double> roundUpTo(int d) => takeAllApply((v) => v.roundUpTo(d));

  Iterable<double> takeAllPlus(int v) => takeAllApply((o) => o + v);

  Iterable<double> takeAllSubtract(int v) => takeAllApply((o) => o - v);

  Iterable<double> takeAllMultiply(int v) => takeAllApply((o) => o * v);

  Iterable<double> takeAllDivide(int v) => takeAllApply((o) => o / v);

  Iterable<int> takeAllDivideToInt(int v) => map((o) => o ~/ v);

  ///
  ///
  /// intersection
  ///
  ///

  ///
  /// [interDistanceTo], [interDistanceFrom]
  /// [interDistanceHalfTo], [interDistanceHalfFrom]
  /// [interDistanceCumulate]
  ///
  Iterable<double> interDistanceTo(Iterator<double> destination) =>
      destination.interTake(this, FReducer.doubleSubtract);

  Iterable<double> interDistanceFrom(Iterator<double> source) =>
      interTake(source, FReducer.doubleSubtract);

  Iterable<double> interDistanceHalfTo(Iterator<double> destination) =>
      destination.interTake(this, FReducer.doubleSubtractThenHalf);

  Iterable<double> interDistanceHalfFrom(Iterator<double> source) =>
      interTake(source, FReducer.doubleSubtractThenHalf);

  double interDistanceCumulate(Iterator<double> another) =>
      interTakeCumulate(another, FReducer.doubleSubtract, FReducer.doubleAdd);
}

///
///
///
extension IterableMapEntry<K, V> on Iterable<MapEntry<K, V>> {
  ///
  /// [toMap], [keys], [values]
  ///
  Map<K, V> get toMap => Map.fromEntries(this);

  Iterable<K> get keys => map((e) => e.key);

  Iterable<V> get values => map((e) => e.value);
}

///
///
///
///
/// iterable
///
///
///
///
///

///
///
///
/// [rangeIn], ...
///
///
///
extension IterableComparable<C extends Comparable> on Iterable<C> {
  ///
  /// [rangeIn]
  ///
  bool rangeIn(C lower, C upper, {bool increase = true, bool isClose = true}) =>
      iterator.checkSortedForSupply(() {
        final validate = IteratorComparable._validationFor(increase, isClose);
        assert(validate(lower, upper));
        return validate(lower, first) && validate(last, upper);
      });

// ///
// /// [groupToIterable]
// ///
// // instead of list.add, it's better to insert by binary general comparable
// Iterable<Iterable<C>> groupToIterable([bool increase = true]) =>
//     iterator.checkSortedForSupply(
//       () {
//         final iterator = this.iterator;
//         return iterator.moveNextSupply(() sync* {
//           var previous = iterator.current;
//           while (iterator.moveNext()) {
//             yield takeWhile(
//                 (value) => IteratorComparable.isEqual(previous, value));
//             throw UnimplementedError();
//           }
//         });
//       },
//       increase,
//     );
}

///
///
/// [distanceTo], ...
/// [normalized], ...
/// [statisticAnalyze], ...
///
///
extension IterableDouble on Iterable<double> {
  ///
  /// [dot]
  ///
  double dot(Iterable<double> another) {
    assert(length == another.length);
    return iterator.interTakeCumulate(
      another.iterator,
      FReducer.doubleMultiply,
      FReducer.doubleAdd,
    );
  }

  ///
  /// [distanceTo], [distanceFrom]
  /// [distanceEachTo], [distanceEachFrom]
  ///
  double distanceTo(Iterable<double> destination) {
    assert(destination.length == length);
    return destination.iterator.interDistanceCumulate(iterator);
  }

  double distanceFrom(Iterable<double> source) {
    assert(source.length == length);
    return iterator.interDistanceCumulate(source.iterator);
  }

  Iterable<double> distanceEachTo(Iterable<double> destination) {
    assert(destination.length == length);
    return destination.iterator.interDistanceTo(iterator);
  }

  Iterable<double> distanceEachFrom(Iterable<double> source) {
    assert(source.length == length);
    return iterator.interDistanceFrom(source.iterator);
  }

  ///
  /// [normalized]
  /// [normalizeInto]
  ///
  Iterable<double> get normalized =>
      iterator.takeAllApplyBy(iterator.distance, FReducer.doubleDivide);

  void normalizeInto(List<double> out) {
    assert(out.length == length);
    iterator.accompanyByIndex(
      iterator.distance,
      (value, d, i) => out[i] = value / d,
    );
  }

  ///
  /// [statisticAnalyze]
  ///
  Iterable<double> statisticAnalyze({
    bool requireLength = true,
    bool requireMean = true,
    bool requireStandardDeviation = true,
    bool requireStandardError = true,
    bool? requireTScores, // t scores or z scores
    double? requireConfidenceInterval = 0.95,
  }) sync* {
    /// n, µ
    var n = 0.0;
    var total = 0.0;
    for (var value in this) {
      total += value;
      n++;
    }
    final mean = total / n;
    if (requireLength) yield n;
    if (requireMean) yield mean;

    ///
    /// standard deviation, standard error
    ///
    var sum = 0.0;
    for (var value in this) {
      sum += (value - mean).squared;
    }
    final sd = sum / n;
    final se = sd / math.sqrt(n);
    if (requireStandardDeviation) yield sd;
    if (requireStandardError) yield se;

    ///
    /// scores
    ///
    if (requireTScores != null) {
      yield* requireTScores
          ? iterator.takeAllApply((x) => (x - mean) / sd * 10 + 50)
          : iterator.takeAllApply((x) => (x - mean) / sd);
    }

    ///
    /// confidence interval (µ - z * se ~ µ + z(se))
    ///
    if (requireConfidenceInterval != null) {
      final z = switch (requireConfidenceInterval) {
        0.95 => 1.96,
        0.99 => 2.576,
        _ => throw UnimplementedError(),
      };
      yield mean - z * se;
      yield mean + z * se;
    }
  }
}

///
/// static methods:
/// [sequence], ...
///
/// instance methods:
/// [sum], ...
///
extension IterableInt on Iterable<int> {
  static Iterable<int> sequence(int length, [int start = 1]) =>
      Iterable.generate(length, (i) => start + i);

  static Iterable<int> seq(int begin, int end) =>
      [for (var i = begin; i <= end; i++) i];

  int get sum => reduce(FReducer.intAdd);
}

///
/// instance methods:
/// [median], ...
/// [copySorted], ...
/// [order], ...
/// [sortMerge], ...
///
extension ListComparable<C extends Comparable> on List<C> {
  ///
  /// [median]
  ///
  C median([bool evenPrevious = true]) =>
      length.isEven ? this[length ~/ 2 - 1] : this[length ~/ 2];

  ///
  ///
  /// [copySorted]
  ///
  ///

  ///
  /// [copySorted]
  ///
  List<C> copySorted([bool increase = true]) => List.of(this)..sort();

  ///
  ///
  /// [order], [rank]
  ///
  ///

  ///
  /// [order]
  /// it returns the indexes helping us to figure out the positions where elements go to make it sorted. for example,
  ///   list = [2, 3, 5, 1, 2];         // [2, 3, 5, 1, 2]
  ///   sorted = List.of(list)..sort(); // [1, 2, 2, 3, 5]
  ///   order = list.order();           // [4, 1, 5, 2, 3]
  ///
  List<int> order({bool increase = true, int from = 1}) {
    final length = this.length;
    C? previous;
    var exist = 0;
    var index = -1;
    return copySorted(increase).iterator.mapToList((vSorted) {
      if (vSorted != previous) {
        exist = 0;
        for (var i = 0; i < length; i++) {
          final current = this[i];
          if (vSorted == current) {
            previous = current;
            index = i;
            break;
          }
        }
      } else {
        for (var i = index + 1; i < length; i++) {
          if (vSorted == this[i]) {
            if (exist == 0) {
              exist++;
              index = i;
              break;
            } else {
              exist--;
              continue;
            }
          }
        }
      }

      return from + index;
    });
  }

  ///
  /// [rank]
  /// it returns the rank of elements. for example,
  ///   list = [1, 8, 4, 8, 9];         // [1, 8, 4, 8, 9]
  ///   sorted = List.of(list)..sort(); // [1, 4, 8, 8, 9]
  ///   rank = list.rank();             // [1.0, 3.5, 2.0, 3.5, 5.0]
  ///
  /// [tieToMin] == null (tie to average)
  /// [tieToMin] == true (tie to min)
  /// [tieToMax] == false (tie to max)
  ///
  List<double> rank({bool increase = true, bool? tieToMin}) {
    final length = this.length;
    final sorted = copySorted(increase);

    C? previous;
    var rank = -1.0;
    return iterator.mapToList(
      // tie to average
      tieToMin == null
          ? (v) {
              if (v == previous) return rank;

              var exist = 0;
              for (var i = 0; i < length; i++) {
                final current = sorted[i];

                if (exist == 0) {
                  if (current == v) exist++;

                  // exist != 0
                } else {
                  if (current != v) {
                    rank = i + (1 - exist) / 2;
                    return rank;
                  }
                  exist++;
                }
              }
              rank = length + (1 - exist) / 2;
              return rank;
            }
          : tieToMin
              ? (v) {
                  if (v == previous) return rank;

                  rank = (sorted.indexWhere((s) => s == v) + 1).toDouble();
                  return rank;
                }

              // tie to max
              : (v) {
                  if (v == previous) return rank;

                  var exist = false;
                  for (var i = 0; i < length; i++) {
                    final current = sorted[i];

                    if (current == v) exist = true;
                    if (exist && current != v) {
                      rank = i.toDouble();
                      return rank;
                    }
                  }
                  rank = length.toDouble();
                  return rank;
                },
    );
  }

  ///
  ///
  /// [percentile]
  /// [percentileQuartile]
  /// [percentileCumulative]
  ///
  ///

  ///
  ///
  /// [percentile]
  /// [percentileQuartile]
  ///
  ///
  C percentile(double value) {
    final message = 'invalid percentage: $value';
    assert(value.rangeClose(0, 1), message);
    final length = this.length;
    for (var i = 0; i < length; i++) {
      if ((i + 1) / length > value) return this[i];
    }
    throw UnimplementedError(message);
  }

  Iterable<C> get percentileQuartile sync* {
    var step = 0.25;
    final length = this.length;
    for (var i = 0; i < length; i++) {
      if ((i + 1) / length > step) {
        step += 0.25;
        yield this[i];
      }
    }
  }

  ///
  /// [percentileCumulative]
  ///
  Iterable<MapEntry<C, double>> percentileCumulative([bool increase = true]) =>
      iterator.checkSortedForSupply(() sync* {
        final percent = 1 / length;

        var previous = first;
        var cumulative = 0.0;
        for (var i = 1; i < length; i++) {
          final current = this[i];
          cumulative += percent;

          if (current != previous) {
            yield MapEntry(previous, cumulative);
            cumulative = 0;
            previous = current;
          }
        }
        yield MapEntry(previous, cumulative);
      });

  ///
  ///
  /// [sortMerge], [_sortMerge]
  /// [sortPivot], [_sortPivot]
  ///
  ///

  ///
  /// [sortMerge] aka merge sort:
  ///   1. regarding current list as the mix of 2 elements sublist, sorting for each sublist
  ///   2. regarding current list as the mix of sorted sublists, merging sublists into bigger ones
  ///     (2 elements -> 4 elements -> 8 elements -> ... -> n elements)
  ///
  /// when [increasing] = true,
  /// it's means that when 'list item a' > 'list item b', element a should switch with b.
  /// see [_sortMerge] for full implementation.
  ///
  void sortMerge([bool increasing = true]) {
    final value = increasing ? 1 : -1;
    final length = this.length;

    final max = length.isEven ? length : length - 1;
    for (var begin = 0; begin < max; begin += 2) {
      final a = this[begin];
      final b = this[begin + 1];
      if (a.compareTo(b) == value) {
        this[begin] = b;
        this[begin + 1] = a;
      }
    }
    int sorted = 2;

    while (sorted * 2 <= length) {
      final target = sorted * 2;
      final fixed = length - length % target;
      int begin = 0;

      for (; begin < fixed; begin += target) {
        final i = begin + sorted;
        final end = begin + target;
        replaceRange(
          begin,
          end,
          _sortMerge(sublist(begin, i), sublist(i, end), increasing),
        );
      }
      if (fixed > 0) {
        replaceRange(
          0,
          length,
          _sortMerge(sublist(0, fixed), sublist(fixed, length), increasing),
        );
      }
      sorted *= 2;
    }
  }

  ///
  /// before calling [_sortMerge], [listA] and [listB] must be sorted.
  /// when [increase] = true,
  /// it's means that when 'listA item a' < 'listB item b', result should add a before add b.
  ///
  static List<C> _sortMerge<C extends Comparable>(
    List<C> listA,
    List<C> listB, [
    bool increase = true,
  ]) {
    final value = increase ? -1 : 1;
    final result = <C>[];
    final lengthA = listA.length;
    final lengthB = listB.length;
    int i = 0;
    int j = 0;
    while (i < lengthA && j < lengthB) {
      final a = listA[i];
      final b = listB[j];
      if (a.compareTo(b) == value) {
        result.add(a);
        i++;
      } else {
        result.add(b);
        j++;
      }
    }
    return result..addAll(i < lengthA ? listA.sublist(i) : listB.sublist(j));
  }

  ///
  /// [sortPivot] separate list by the pivot item,
  /// continue updating pivot item, sorting elements by comparing to pivot item.
  /// see [_sortPivot] for full implementation
  ///
  void sortPivot([bool isIncreasing = true]) {
    void sorting(int low, int high) {
      if (low < high) {
        final iPivot = _sortPivot(low, high, isIncreasing);
        sorting(low, iPivot - 1);
        sorting(iPivot + 1, high);
      }
    }

    if (length > 1) sorting(0, length - 1);
  }

  ///
  /// [_sortPivot] partition list by the the pivot item list[high], and return new pivot position.
  ///
  /// when [isIncreasing] = true,
  /// it meas that the pivot point should search for how much item that is less than itself,
  /// ensuring the items that less/large than pivot are in front of list,
  /// preparing to switch the larger after the position of 'how much item' that pivot had found less than itself
  ///
  int _sortPivot(int low, int high, [bool isIncreasing = true]) {
    final increasing = isIncreasing ? 1 : -1;
    final pivot = this[high];
    var i = low;
    var j = low;

    for (; j < high; j++) {
      if (pivot.compareTo(this[j]) == increasing) {
        i++;
      } else {
        break;
      }
    }

    for (; j < high; j++) {
      final current = this[j];
      if (pivot.compareTo(current) == increasing) {
        this[j] = this[i];
        this[i] = current;
        i++;
      }
    }

    this[high] = this[i];
    this[i] = pivot;

    return i;
  }
}

///
/// [interquartileRange]
///
extension ListDouble on List<double> {
  ///
  /// [interquartileRange]
  ///
  double get interquartileRange {
    final interquartile = percentileQuartile;
    return interquartile.last - interquartile.first;
  }
}

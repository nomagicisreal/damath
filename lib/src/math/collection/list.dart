///
///
/// this file contains:
///
/// [ListExtension]
/// [ListComparableExtension]
/// [ListListComparableExtension], [ListSetExtension]
///
///
part of damath_math;

///
///
/// static methods:
/// [generateFrom], ...
/// [fill2D], ...
///
/// instance methods:
/// [isFixed], ...
///
/// [addNext], ...
/// [indexesWhere], ...
///
/// [fillUntil], ...
/// [copy], ...
/// [splitBy], ...
///
/// [intersection], ...
/// [difference], ...
///
/// [mapToList], ...
/// [interReduce], ...
///
extension ListExtension<T> on List<T> {
  ///
  /// [generateFrom]
  /// [generate2D], [generate2DSquare]
  ///
  static List<T> generateFrom<T>(
    int length,
    Generator<T> generator, {
    int begin = 1,
    bool growable = true,
  }) =>
      List.generate(
        length,
        (index) => generator(index + begin),
        growable: growable,
      );

  static List<List<T>> generate2D<T>(
    int rowCount,
    int columnCount,
    Generator2D<T> generator,
  ) =>
      List.generate(
        rowCount,
        (i) => List.generate(columnCount, (j) => generator(i, j)),
      );

  static List<List<T>> generate2DSquare<T>(int d, Generator2D<T> generator) =>
      generate2D(d, d, generator);

  ///
  /// [fill2D]
  /// [fill2DSquare]
  ///
  static List<List<T>> fill2D<T>(int rowCount, int columnCount, T value) =>
      generate2D(rowCount, columnCount, (i, j) => value);

  static List<List<T>> fill2DSquare<T>(int size, T value) =>
      fill2D(size, size, value);

  ///
  /// [_tryRemoveLastAndAdd]
  /// [isFixed], [isGrowable]
  /// [isImmutable], [isMutable] (immutable list can be created by 'const' keyword or [List.unmodifiable])
  ///
  bool _tryRemoveLastAndAdd(Pattern pattern) {
    try {
      add(removeLast());
    } on UnsupportedError catch (e) {
      return e.message?.contains(pattern) ?? false;
    }
    return false;
  }

  bool get isFixed => _tryRemoveLastAndAdd('fixed-length list');

  bool get isGrowable => !isFixed;

  bool get isImmutable => _tryRemoveLastAndAdd('unmodifiable list');

  bool get isMutable => !isImmutable;

  ///
  /// [swap]
  ///
  void swap(int iA, int iB) {
    final temp = this[iA];
    this[iA] = this[iB];
    this[iB] = temp;
  }

  ///
  /// add, update, get, remove
  /// [addNext]
  /// [addWhen], [addWhenNotNull]
  /// [addAllIfEmpty], [addAllIfNotEmpty], [addAllWhen]
  ///
  /// [getOrDefault]
  ///
  /// [update], [updateApply]
  /// [updateAll], [updateAllApply]
  ///
  /// [removeFirst], [removeWhereAndGet]
  ///

  ///
  /// [addNext]
  /// [copyCycle]
  ///
  bool addNext(T value) {
    try {
      add(value);
      return true;
    } catch (_) {}
    return false;
  }

  ///
  /// [addWhen]
  /// [addWhenNotNull]
  ///
  void addWhen(bool shouldAdd, T element) => shouldAdd ? add(element) : null;

  void addWhenNotNull(T? element) => element == null ? null : add(element);

  ///
  /// [addAllIfEmpty]
  /// [addAllIfNotEmpty]
  /// [addAllWhen]
  ///
  void addAllIfEmpty(Supplier<Iterable<T>> supplier) =>
      isEmpty ? addAll(supplier()) : null;

  void addAllIfNotEmpty(Supplier<Iterable<T>> supplier) =>
      isNotEmpty ? addAll(supplier()) : null;

  void addAllWhen(bool shouldAdd, Supplier<Iterable<T>> supplier) =>
      shouldAdd ? addAll(supplier()) : null;

  ///
  /// [getOrDefault]
  ///
  T getOrDefault(int position, Supplier<T> defaultValue) =>
      position < length ? this[position] : defaultValue();

  ///
  /// [update]
  /// [updateApply]
  ///
  void update(int index, T value) => this[index] = value;

  void updateApply(int index, Applier<T> applier) =>
      this[index] = applier(this[index]);

  ///
  /// [updateAll]
  /// [updateAllApply]
  ///
  void updateAll(T value) {
    for (var i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  void updateAllApply(Applier<T> applier) {
    for (var i = 0; i < length; i++) {
      this[i] = applier(this[i]);
    }
  }

  ///
  /// [removeWhereAndGet]
  ///
  Iterable<T> removeWhereAndGet(Predicator<T> test) sync* {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) yield removeAt(i);
    }
  }

  ///
  /// where, when
  /// [indexesWhere]
  ///
  /// [indexWhen], [indexWhenBetween]
  /// [indexesWhen]
  ///
  ///

  ///
  /// [indexesWhere]
  ///
  Iterable<int> indexesWhere(
    Predicator<T> test, [
    int begin = 0,
    int? end,
  ]) sync* {
    final bound = end ?? length;
    assert(begin.rangeIn(0, length) && bound.rangeIn(begin, length));
    for (var i = begin; i < bound; i++) {
      if (test(this[i])) yield i;
    }
  }

  ///
  /// [indexWhen], [indexWhenBetween]
  /// [indexesWhen]
  ///
  int indexWhen(PredicatorGenerator<T> check) {
    for (var i = 0; i < length; i++) {
      if (check(this[i], i)) return i;
    }
    return -1;
  }

  int indexWhenBetween(
    PredicatorGenerator<T> check, [
    int begin = 0,
    int? end,
  ]) {
    final bound = end ?? length;
    assert(length.constraintsFrom(0, begin, bound));
    for (var i = begin; i < bound; i++) {
      if (check(this[i], i)) return i;
    }
    return -1;
  }

  Iterable<int> indexesWhen(
    PredicatorGenerator<T> test, [
    int begin = 0,
    int? end,
  ]) sync* {
    final bound = end ?? length;
    assert(length.constraintsFrom(0, begin, bound));
    for (var i = begin; i < bound; i++) {
      if (test(this[i], i)) yield i;
    }
  }

  ///
  /// fill, copy
  /// [fillUntil]
  ///
  /// [copy],
  /// [copyCycle], [copyAndFill], [copyByOrder]
  ///
  ///

  ///
  /// [fillUntil]
  ///
  void fillUntil(T value, int boundary) {
    for (var i = length; i < boundary; i++) {
      add(value);
    }
  }

  ///
  /// [copy]
  /// [copyCycle]
  /// [copyAndFill]
  /// [copyByOrder]
  ///
  List<T> copy([bool growable = true]) => List.of(this, growable: growable);

  List<T> copyCycle([int count = 1]) =>
      List.of([...sublist(count), ...sublist(0, count)]);

  List<T> copyAndFill(int total, T value, [bool trailing = true]) => [
        if (!trailing) ...List.filled(total - length, value, growable: false),
        ...this,
        if (trailing) ...List.filled(total - length, value, growable: false),
      ];

  List<T> copyByOrder(Iterable<int> order) {
    assert(Iterable.generate(length).isVariantTo(order));
    return [for (var i in order) this[i]];
  }

  ///
  ///
  /// split
  /// [splitBy], [splitAt]
  ///
  ///
  ///

  ///
  /// [splitBy]
  /// [splitAt]
  ///

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.split(2); // [[2, 3], [4, 6], [10, 3], [9]]
  ///
  List<List<T>> splitBy(int count, [int begin = 0, int? end]) {
    final length = end ?? this.length;
    assert(begin.rangeIn(0, length) && count.rangeIn(0, length));

    final list = <List<T>>[];
    for (var i = begin; i < length; i += count) {
      list.add(sublist(i, i + count < length ? i + count : length));
    }
    return list;
  }

  List<List<T>> splitAt(List<int> positions, [int begin = 0, int? end]) {
    final length = end ?? this.length;
    assert(
      begin.rangeIn(0, length) &&
          positions.isSorted() &&
          positions.first >= begin &&
          positions.last <= length,
    );
    return positions.iterator.foldAccompanyAfter(
      [],
      begin,
      (result, interval, i) => result..add(sublist(i, interval)),
      (i, interval) => interval,
    );
  }

  ///
  /// [reversedExcept]
  ///
  List<T> reversedExcept([int count = 1]) =>
      [...sublist(count), ...sublist(count).reversed];

  ///
  /// [mapToList]
  /// [mapToListWithByNew], [mapToListWithByOld]
  /// [mapToListTogether]
  ///
  List<E> mapToList<E>(Mapper<T, E> toVal) =>
      [for (var i = 0; i < length; i++) toVal(this[i])];

  List<E> mapToListWithByNew<E>(
    List<E> other,
    Reducer<E> reducing,
    Mapper<T, E> toVal,
  ) =>
      [for (var i = 0; i < length; i++) reducing(toVal(this[i]), other[i])];

  List<E> mapToListWithByOld<E>(
    List<T> other,
    Reducer<T> reducing,
    Mapper<T, E> toVal,
  ) =>
      [for (var i = 0; i < length; i++) toVal(reducing(this[i], other[i]))];

  List<S> mapToListTogether<S, E>(
    List<E> other,
    Reducer<S> reducing,
    Mapper<T, S> toVal,
    Mapper<E, S> toValOther,
  ) =>
      [
        for (var i = 0; i < length; i++)
          reducing(toVal(this[i]), toValOther(other[i])),
      ];

  ///
  /// [interReduce]
  /// [interCompanion]
  ///
  List<T> interReduce(List<T> other, Reducer<T> reducing) =>
      [for (var i = 0; i < length; i++) reducing(this[i], other[i])];

  List<T> interCompanion<E>(List<E> other, Companion<T, E> companion) =>
      [for (var i = 0; i < length; i++) companion(this[i], other[i])];
}

///
/// static methods:
/// [reverse]
///
/// instance methods:
/// [median], ...
/// [isSorted], ...
/// [order], ...
/// [sortMerge], ...
///
extension ListComparableExtension<C extends Comparable> on List<C> {
  ///
  /// [reverse]
  ///
  /// it's a reverse version from [Comparable.compare]
  ///
  static int reverse<C extends Comparable>(C a, C b) => b.compareTo(a);

  ///
  /// [median]
  ///
  C median([bool evenPrevious = true]) =>
      length.isEven ? this[length ~/ 2 - 1] : this[length ~/ 2];

  ///
  ///
  /// [isSorted], [copySorted]
  ///
  ///

  ///
  /// [isSorted]
  ///
  bool isSorted([bool increase = true]) {
    final invalid = increase ? 1 : -1;
    C a = this[0];
    for (var i = 1; i < length; i++) {
      final b = this[i];
      if (a.compareTo(b) == invalid) return false;
      a = b;
    }
    return true;
  }

  ///
  /// [copySorted]
  ///
  List<C> copySorted([bool increase = true]) =>
      List.of(this)..sort(increase ? Comparable.compare : reverse);

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
    assert(value.rangeIn(0, 1), message);
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
  Iterable<MapEntry<C, double>> percentileCumulative([
    bool increase = true,
  ]) sync* {
    assert(isSorted(increase));
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
  }

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

extension ListDoubleExtension on List<double> {
  ///
  /// [interquartileRange]
  ///
  double get interquartileRange {
    final interquartile = this.percentileQuartile;
    return interquartile.last - interquartile.first;
  }
}

///
/// [sortByFirst]
/// [sortAccordingly]
///
extension ListListComparableExtension<C extends Comparable> on List<List<C>> {
  ///
  /// [accordingly]
  ///
  static int accordingly<C extends Comparable>(
    List<C> a,
    List<C> b,
    Comparator<C> comparing,
  ) {
    final maxIndex = math.max(a.length, b.length);
    int compareBy(int i) {
      final value = comparing(a[i], b[i]);
      return value == 0 && i < maxIndex ? compareBy(i + 1) : value;
    }

    return compareBy(0);
  }

  ///
  /// [sortByFirst]
  ///
  void sortByFirst([bool increasing = true]) => sort(
        increasing
            ? (a, b) => a.first.compareTo(b.first)
            : (a, b) => b.first.compareTo(a.first),
      );

  ///
  /// [sortAccordingly]
  ///
  void sortAccordingly([bool increase = true]) => sort(
        increase
            ? (a, b) => accordingly(a, b, Comparable.compare)
            : (a, b) => accordingly(a, b, ListComparableExtension.reverse),
      );
}

///
/// [mergeToThis], ...
///
extension ListSetExtension<I> on List<Set<I>> {
  ///
  /// [mergeToThis]
  /// [mergeToThat]
  /// [mergeWhereToTrailing]
  ///
  void mergeToThis(int i, int j) {
    this[i].addAll(this[j]);
    removeAt(j);
  }

  void mergeToThat(int i, int j) {
    this[j].addAll(this[i]);
    removeAt(i);
  }

  void mergeWhereToTrailing(Predicator<Set<I>> test) =>
      add(removeWhereAndGet(test).iterator.merged);
}

///
///
/// this file contains:
/// [ListExtension]
/// [ListComparableExtension]
/// [ListListExtension], [ListListComparableExtension], [ListSetExtension]
///
///
part of damath_math;

///
///
/// static methods:
/// [generateFrom], ...
/// [fill2D], ...
/// [linking], ...
///
/// instance methods:
/// [isFixed], ...
///
/// [add2], ...
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
/// [accordinglyReduce], ...
///
extension ListExtension<T> on List<T> {
  ///
  /// [generateFrom]
  ///
  static List<T> generateFrom<T>(
    int length,
    Generator<T> generator, {
    int start = 1,
    bool growable = true,
  }) =>
      List.generate(
        length,
        (index) => generator(index + start),
        growable: growable,
      );

  ///
  /// [generate2D]
  /// [generate2DSquare]
  ///
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
  /// [linking]
  ///
  static List<S> linking<S, T, I>({
    required int totalStep,
    required Generator<T> step,
    required Generator<I> interval,
    required Sequencer<S, T, I> sequencer,
  }) {
    final steps = List.generate(totalStep, step);
    final lengthIntervals = totalStep - 1;
    final intervals = List.generate(lengthIntervals, interval);

    final result = <S>[];

    T previous = steps.first;
    for (var i = 0; i < lengthIntervals; i++) {
      final next = steps[i + 1];
      result.add(sequencer(previous, next, intervals[i])(i));
      previous = next;
    }
    return result;
  }

  ///
  /// [_tryRemoveLastAndAdd]
  /// [isFixed], [isGrowable]
  /// [isImmutable], [isMutable]
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

  ///
  /// immutable list can be created by 'const' keyword or [List.unmodifiable]
  ///
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
  /// [add2], [add3], [add4], [add5]
  /// [addNext]
  /// [addFirstAndRemoveFirst], [addFirstAndRemoveFirstAndGet]
  /// [addWhen], [addWhenNotNull]
  /// [addAllIfEmpty], [addAllIfNotEmpty], [addAllWhen]
  ///
  /// [getOrDefault]
  ///
  /// [update], [updateWithMapper]
  /// [updateAll], [updateAllWithMapper]
  ///
  /// [removeFirst], [removeWhereAndGet]
  ///

  ///
  /// [add2], [add3], [add4], [add5]
  ///
  void add2(T v1, T v2) => this
    ..add(v1)
    ..add(v2);

  void add3(T v1, T v2, T v3) => this
    ..add(v1)
    ..add(v2)
    ..add(v3);

  void add4(T v1, T v2, T v3, T v4) => this
    ..add(v1)
    ..add(v2)
    ..add(v3)
    ..add(v4);

  void add5(T v1, T v2, T v3, T v4, T v5) => this
    ..add(v1)
    ..add(v2)
    ..add(v3)
    ..add(v4)
    ..add(v5);

  ///
  /// [addNext]
  ///
  bool addNext(T value) {
    try {
      add(value);
      return true;
    } catch (_) {}
    return false;
  }

  ///
  /// [addFirstAndRemoveFirst]
  /// [addFirstAndRemoveFirstAndGet]
  ///
  void addFirstAndRemoveFirst() => this
    ..add(first)
    ..removeFirst();

  T addFirstAndRemoveFirstAndGet() => (this
        ..add(first)
        ..removeFirst())
      .last;

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
  /// [updateWithMapper]
  ///
  void update(int index, T value) => this[index] = value;

  void updateWithMapper(int index, Mapper<T> mapper) =>
      this[index] = mapper(this[index]);

  ///
  /// [updateAll]
  /// [updateAllWithMapper]
  ///
  void updateAll(T value) {
    final length = this.length;
    for (var i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  void updateAllWithMapper(Mapper<T> mapper) {
    final length = this.length;
    for (var i = 0; i < length; i++) {
      this[i] = mapper(this[i]);
    }
  }

  ///
  /// [removeFirst]
  /// [removeWhereAndGet]
  ///
  T removeFirst() => removeAt(0);

  Iterable<T> removeWhereAndGet(Predicator<T> predicator) {
    final length = this.length;
    final list = <T>[];
    for (var i = 0; i < length; i++) {
      if (predicator(this[i])) {
        list.add(removeAt(i));
      }
    }
    return list;
  }

  ///
  /// where
  /// [indexesWhere]
  /// [indexWhen], [indexesWhen]
  ///

  ///
  /// [indexesWhere]
  ///
  Iterable<int> indexesWhere(
    Predicator<T> test, [
    int start = 0,
    int? end,
  ]) sync* {
    final bound = end ?? length;
    assert(start.rangeIn(0, length) && bound.rangeIn(start, length));
    for (var i = start; i < bound; i++) {
      if (test(this[i])) yield i;
    }
  }

  ///
  /// [indexWhen]
  /// [indexesWhen]
  ///
  int indexWhen(Checker<T> check, [int start = 0, int? end]) {
    final bound = end ?? length;
    assert(start.rangeIn(0, length) && bound.rangeIn(start, length));
    for (var i = start; i < bound; i++) {
      if (check(i, this[i])) return i;
    }
    return -1;
  }

  Iterable<int> indexesWhen(Checker<T> check, [int start = 0, int? end]) sync* {
    final bound = end ?? length;
    assert(start.rangeIn(0, length) && bound.rangeIn(start, length));
    for (var i = start; i < bound; i++) {
      if (check(i, this[i])) yield i;
    }
  }

  ///
  /// fill, copy
  /// [fillUntil]
  ///
  /// [copy], [copyFillUntil], [copyIntoOrder]
  ///
  ///

  ///
  /// [fillUntil]
  ///
  void fillUntil(int length, T value) {
    for (var i = this.length; i < length; i++) {
      add(value);
    }
  }

  ///
  /// [copy]
  /// [copyFillUntil]
  /// [copyIntoOrder]
  ///
  List<T> copy([bool growable = true]) => List.of(this, growable: growable);

  List<T> copyFillUntil(int length, T value, [bool growable = true]) => [
        ...this,
        ...List.filled(length - this.length, value, growable: growable),
      ];

  ///
  /// list = [2, 3, 4, 6];
  /// list.copyInOrder([2, 1, 0, 3]); // [4, 3, 2, 6]
  ///
  List<T> copyIntoOrder(Iterable<int> order) {
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
  List<List<T>> splitBy(int count, [int start = 0, int? end]) {
    final length = end ?? this.length;
    assert(start.rangeIn(0, length) && count.rangeIn(0, length));

    final list = <List<T>>[];
    for (var i = start; i < length; i += count) {
      list.add(sublist(i, i + count < length ? i + count : length));
    }
    return list;
  }

  List<List<T>> splitAt(List<int> positions, [int start = 0, int? end]) {
    final length = end ?? this.length;
    assert(
      start.rangeIn(0, length) &&
          positions.isSorted() &&
          positions.first >= start &&
          positions.last <= length,
    );
    return positions.iterator.foldAccompany(
      [],
      start,
      (result, interval, i) => result..add(sublist(i, interval)),
      (i, interval, result) => interval,
    );
  }

  ///
  /// [reversedExceptFirst]
  ///
  List<T> get reversedExceptFirst {
    final length = this.length - 1;
    final result = <T>[first];
    for (var i = length; i > 0; i--) {
      result.add(this[i]);
    }
    return result;
  }

  ///
  /// [mapToList]
  /// [mapToListWith], [mapToListWithSame]
  /// [mapToListTogether]
  ///
  List<E> mapToList<E>(Translator<T, E> toVal) =>
      [for (var i = 0; i < length; i++) toVal(this[i])];

  List<E> mapToListWith<E>(
    List<E> other,
    Reducer<E> reducing,
    Translator<T, E> toVal,
  ) =>
      [for (var i = 0; i < length; i++) reducing(toVal(this[i]), other[i])];

  List<E> mapToListWithSame<E>(
    List<T> other,
    Reducer<T> reducing,
    Translator<T, E> toVal,
  ) =>
      [for (var i = 0; i < length; i++) toVal(reducing(this[i], other[i]))];

  List<S> mapToListTogether<S, E>(
    List<E> other,
    Reducer<S> reducing,
    Translator<T, S> toVal,
    Translator<E, S> toValOther,
  ) =>
      [
        for (var i = 0; i < length; i++)
          reducing(toVal(this[i]), toValOther(other[i])),
      ];

  ///
  /// [accordinglyReduce]
  /// [accordinglyCompanion]
  ///
  List<T> accordinglyReduce(List<T> other, Reducer<T> reducing) =>
      [for (var i = 0; i < length; i++) reducing(this[i], other[i])];

  List<T> accordinglyCompanion<E>(List<E> other, Companion<T, E> companion) =>
      [for (var i = 0; i < length; i++) companion(this[i], other[i])];
}

///
/// [isSorted]
/// [sortMerge], [sortPivot]
///
extension ListComparableExtension<C extends Comparable> on List<C> {
  ///
  /// [copySorted]
  ///
  List<C> copySorted([bool increase = true]) => List.of(this)
    ..sort(increase ? Comparable.compare : ComparableData.compareReverse);

  ///
  /// the [order] returns a list;
  /// list index is the index of sorted list
  /// list element is the index of current list. for example,
  ///   list = [2, 3, 5, 1, 2];
  ///   sorted = List.of(list)..sort(); // [1, 2, 2, 3, 5]
  ///   order = list.order();           // [3, 0, 4, 1, 2]
  ///
  /// in the sample above,
  ///   '3' (order[0]) in represent the position of '1' (sorted[0]) in 'list' is 3
  ///   '0' (order[1]) in represent the position of '2' (sorted[1]) in 'list' is 0
  ///   '4' (order[2]) in represent the position of '2' (sorted[2]) in 'list' is 4
  ///   '1' (order[3]) in represent the position of '3' (sorted[3]) in 'list' is 1
  ///   '2' (order[4]) in represent the position of '5' (sorted[4]) in 'list' is 2
  ///
  List<int> order([bool increase = true]) =>
      copySorted(increase).iterator.yieldingToListByList(
        [],
        (vSorted, o) {
          for (var i = 0; i < length; i++) {
            if (vSorted == this[i]
                ? o.iterator.containsThen(i, () => false, () => o.addNext(i))
                : false) return i;
          }
          throw UnimplementedError('unreachable');
        },
      );

  // ///
  // /// [rank]
  // ///
  // /// [tieToMin] == null (average)
  // /// [tieToMin] == true (min)
  // /// [tieToMax] == false (max)
  // ///
  // List<double> rank([bool increase = true, bool? tieToMin]) {
  //   final val = increase ? 1 : -1;
  //   final Combiner<int, double> updater = tieToMin == null
  //       ? (r, times) => (r * 2 + times) / times
  //       : tieToMin
  //           ? (r, times) => r.toDouble()
  //           : (r, times) => r + times.toDouble();
  //   final times = <C, int>{};
  //   iterator.cumulativeWhere(
  //     (v) => current.compareTo(v) == val,
  //   );
  //   // return map[];
  // }

  ///
  /// [isSorted]
  ///
  bool isSorted([bool increase = true]) {
    final length = this.length;
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
    for (var start = 0; start < max; start += 2) {
      final a = this[start];
      final b = this[start + 1];
      if (a.compareTo(b) == value) {
        this[start] = b;
        this[start + 1] = a;
      }
    }
    int sorted = 2;

    while (sorted * 2 <= length) {
      final target = sorted * 2;
      final fixed = length - length % target;
      int start = 0;

      for (; start < fixed; start += target) {
        final i = start + sorted;
        final end = start + target;
        replaceRange(
          start,
          end,
          _sortMerge(sublist(start, i), sublist(i, end), increasing),
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
    int i = low;
    int j = low;

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
/// [lengthFirst]
/// [isMatrix]
///
extension ListListExtension<T> on List<List<T>> {
  int get lengthFirst => first.length;

  bool get isMatrix {
    final columnCount = this.lengthFirst;
    return every((element) => element.length == columnCount);
  }
}

///
/// [sortByElementFirst]
/// [sortAccordingly]
///
extension ListListComparableExtension<C extends Comparable> on List<List<C>> {
  void sortByElementFirst([Comparator<C>? compare]) => sort(
        compare != null
            ? (a, b) => compare(a.first, b.first)
            : (a, b) => b.first.compareTo(a.first), // increasing
      );

  void sortAccordingly([Comparator<C>? comparator]) {
    final length = first.length;
    assert(every((element) => element.length == length));

    final comparing = comparator ?? (C a, C b) => a.compareTo(b); // increase
    final maxIndex = length - 1;
    sort((a, b) {
      int compareFrom(int i) {
        final value = comparing(b[i], a[i]);
        return value == 0 && i < maxIndex ? compareFrom(i + 1) : value;
      }

      return compareFrom(0);
    });
  }
}

///
/// [mergeAndRemoveThat], ...
///
extension ListSetExtension<I> on List<Set<I>> {
  ///
  /// [mergeAndRemoveThat]
  /// [mergeAndRemoveThis]
  /// [mergeWhereAndRemoveAllAndAdd]
  ///
  void mergeAndRemoveThat(int i, int j) {
    this[i].addAll(this[j]);
    removeAt(j);
  }

  void mergeAndRemoveThis(int i, int j) {
    this[j].addAll(this[i]);
    removeAt(i);
  }

  void mergeWhereAndRemoveAllAndAdd(Predicator<Set<I>> predicator) =>
      add(removeWhereAndGet(predicator).merged);
}

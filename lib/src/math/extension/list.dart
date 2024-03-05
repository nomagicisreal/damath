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
/// [swap], ...
/// [add2], ...
/// [getOrDefault], ...
/// [update], ...
/// [removeFirst], ...
///
/// [fillUntil], ...
/// [copy], ...
/// [split], ...
///
/// [intersection], ...
/// [difference], ...
///
/// [mapToList], ...
/// [accordinglyAccompany], ...
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
  static List<R> linking<R, S, I>({
    required int totalStep,
    required Generator<S> step,
    required Generator<I> interval,
    required Sequencer<R, S, I> sequencer,
  }) {
    final steps = List.generate(totalStep, step);
    final lengthIntervals = totalStep - 1;
    final intervals = List.generate(lengthIntervals, interval);

    final result = <R>[];

    S previous = steps.first;
    for (var i = 0; i < lengthIntervals; i++) {
      final next = steps[i + 1];
      result.add(sequencer(previous, next, intervals[i])(i));
      previous = next;
    }
    return result;
  }

  ///
  /// [isFixed]
  /// [isGrowable]
  ///
  bool get isFixed {
    try {
      add(removeLast());
    } on UnsupportedError catch (e) {
      return e.message == 'Cannot remove from a fixed-length list';
    }
    return false;
  }

  bool get isGrowable => !isFixed;

  ///
  /// [swap]
  ///
  void swap(int iA, int iB) {
    final temp = this[iA];
    this[iA] = this[iB];
    this[iB] = temp;
  }

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
    assert(Iterable.generate(length).isCombinationOf(order));
    return [for (var i in order) this[i]];
  }

  ///
  /// [split]
  /// [splitTwo]
  ///

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.split(2); // [[2, 3], [4, 6], [10, 3], [9]]
  ///
  List<List<T>> split(int count, [int? end]) {
    final length = end ?? this.length;
    assert(count <= length);

    final list = <List<T>>[];
    for (var i = 0; i < length; i += count) {
      list.add(sublist(i, i + count < length ? i + count : length));
    }
    return list;
  }

  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.splitTwo(2); // [[2, 3], [4, 6, 10, 3, 9]]
  ///
  (List<T>, List<T>) splitTwo(int position, [int? end]) {
    final length = this.length;
    assert(position <= length);
    return (sublist(0, position), sublist(position, end ?? length));
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
  /// [intersection]
  /// [intersectionIndex]
  /// [intersectionDetail]
  ///
  List<T> intersection(Iterable<T> another) => intersectionFold(
        [],
        another,
        (list, v1, v2) => list..addWhen(v1 == v2, v1),
      );

  List<int> intersectionIndex(Iterable<T> another) => intersectionFoldIndexable(
        [],
        another,
        (list, v1, v2, index) => list..addWhen(v1 == v2, index),
      );

  Map<int, T> intersectionDetail(Iterable<T> another) => intersectionFoldIndexable(
        {},
        another,
        (map, v1, v2, index) => map..putIfAbsentWhen(v1 == v2, index, () => v1),
      );

  ///
  /// [difference]
  /// [differenceIndex]
  /// [differenceDetail]
  ///
  List<T> difference(Iterable<T> another) => differenceFold(
        [],
        another,
        (list, v1, v2) => list..addWhen(v1 != v2, v1),
        (list, another) => list..add(another),
      );

  List<int> differenceIndex(Iterable<T> another) => differenceFoldIndexable(
        [],
        another,
        (value, e1, e2, index) => value..addWhen(e1 != e2, index),
        (value, element, index) => value..add(index),
      );

  ///
  /// [MapEntry.key] is the value in this instance that different with [another]
  /// [MapEntry.value] is the value in [another] that different with this instance
  ///
  Map<int, MapEntry<T, T?>> differenceDetail(Iterable<T> another) =>
      differenceFoldIndexable(
        {},
        another,
        (value, e1, e2, index) =>
            value..putIfAbsentWhen(e1 != e2, index, () => MapEntry(e1, e2)),
        (value, element, index) =>
            value..putIfAbsent(index, () => MapEntry(element, null)),
      );

  ///
  /// [mapToList]
  /// [mapToListWith]
  /// [mapToListAccompany]
  ///
  List<E> mapToList<E>(Translator<T, E> toElement) =>
      mapToListByGenerate((i) => toElement(this[i]));

  List<E> mapToListWith<E>(
    List<E> another,
    Reducer<E> reducer,
    Translator<T, E> toElement,
  ) =>
      mapToListByGenerate((index) => reducer(toElement(this[index]), another[index]));

  List<E> mapToListAccompany<E>(
    List<T> another,
    Reducer<T> reducer,
    Translator<T, E> toElement,
  ) =>
      mapToListByGenerate((index) => toElement(reducer(this[index], another[index])));

  ///
  /// [accordinglyAccompany]
  /// [accordinglyWith]
  ///
  List<T> accordinglyAccompany(List<T> another, Reducer<T> reducer) =>
      mapToListByGenerate((i) => reducer(this[i], another[i]));

  List<T> accordinglyWith<E>(List<E> another, Companion<T, E> companion) =>
      mapToListByGenerate((i) => companion(this[i], another[i]));
}

///
/// [isSorted]
/// [sortMerge], [sortPivot]
///
extension ListComparableExtension<C extends Comparable> on List<C> {
  ///
  /// [isSorted]
  ///
  bool isSorted([bool expectIncrease = true]) {
    final length = this.length;
    final invalid = expectIncrease ? 1 : -1;
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
  /// when [isIncreasing] = true,
  /// it's means that when 'list item a' > 'list item b', element a should switch with b.
  /// see [_sortMerge] for full implementation.
  ///
  void sortMerge([bool isIncreasing = true]) {
    final increasing = isIncreasing ? 1 : -1;
    final length = this.length;

    final max = length.isEven ? length : length - 1;
    for (var start = 0; start < max; start += 2) {
      final a = this[start];
      final b = this[start + 1];
      if (a.compareTo(b) == increasing) {
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
          _sortMerge(sublist(start, i), sublist(i, end), isIncreasing),
        );
      }
      if (fixed > 0) {
        replaceRange(
          0,
          length,
          _sortMerge(sublist(0, fixed), sublist(fixed, length), isIncreasing),
        );
      }
      sorted *= 2;
    }
  }

  ///
  /// before calling [_sortMerge], [listA] and [listB] must be sorted.
  /// when [isIncreasing] = true,
  /// it's means that when 'listA item a' < 'listB item b', result should add a before add b.
  ///
  static List<C> _sortMerge<C extends Comparable>(
    List<C> listA,
    List<C> listB, [
    bool isIncrease = true,
  ]) {
    final increase = isIncrease ? -1 : 1;
    final result = <C>[];
    final lengthA = listA.length;
    final lengthB = listB.length;
    int i = 0;
    int j = 0;
    while (i < lengthA && j < lengthB) {
      final a = listA[i];
      final b = listB[j];
      if (a.compareTo(b) == increase) {
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

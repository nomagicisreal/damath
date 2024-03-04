///
///
/// this file contains:
///
/// [IterableExtension]
/// [IterableIntExtension], [IterableDoubleExtension]
/// [IterableIterableExtension], [IterableSetExtension]
///
///
///
/// [ListExtension]
/// [ListComparableExtension]
/// [ListListExtension], [ListListComparableExtension], [ListSetExtension]
///
///
///
///
/// [MapEntryExtension]
/// [MapEntryIterableExtension]
/// [MapExtension]
/// [MapKeyComparableExtension]
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
part of damath_math;

///
/// static methods:
/// [fill], [generateFrom]
///
/// instance getter and methods
/// [notContains]
/// [firstWhereOrNull]
/// [iteratingAllWith]
///
/// [anyOf], [anyIsEqual], [anyIsDifferent], [anyWithIndex],
/// [anyElementWith], [anyElementIsEqualWith], [anyElementIsDifferentWith]
///
/// [everyIsEqual], [everyIsDifferent], [everyWithIndex],
/// [everyElementsWith], [everyElementsAreEqualWith], [everyElementsAreDifferentWith]
///
/// [foldWithIndex], [foldWith]
/// [reduceWithIndex], [reduceWith], [reduceTo], [reduceToNum], [reduceToString], [reduceTogether]
/// [expandWithIndex], [expandWith], [flat]
/// [mapToList]
///
/// [chunk]
/// [groupBy]
/// [lengthFlatted]
/// [combine]
///
extension IterableExtension<I> on Iterable<I> {
  ///
  /// [generateFrom], [fill]
  ///
  static Iterable<I> generateFrom<I>(
    int count, [
    Generator<I>? generator,
    int start = 1,
  ]) {
    if (generator == null && I != int) throw UnimplementedError();
    return Iterable.generate(
      count,
      generator == null ? (i) => start + i as I : (i) => generator(start + i),
    );
  }

  static Iterable<I> fill<I>(int count, I value) =>
      Iterable.generate(count, FGenerator.fill(value));

  ///
  /// [notContains]
  /// [firstWhereOrNull]
  ///
  bool notContains(I element) => !contains(element);

  void iteratingAllWith<S>(Iterable<S> another, Absorber<I, S> absorber) {
    assert(length == another.length, 'length must be equal');
    final iterator = this.iterator;
    final iteratorAnother = another.iterator;
    while (iterator.moveNext() && iteratorAnother.moveNext()) {
      absorber(iterator.current, iteratorAnother.current);
    }
  }

  ///
  ///
  /// [anyOf]
  /// [anyIsEqual], [anyIsDifferent]
  /// [anyWithIndex]
  /// [anyElementWith], [anyElementIsEqualWith], [anyElementIsDifferentWith]
  ///
  ///
  bool anyOf(Comparator<I> compare, {int expect = 0}) {
    final iterator = this.iterator..moveNext();
    final List<I> list = [iterator.current];
    while (iterator.moveNext()) {
      final current = iterator.current;
      if (list.any((e) => compare(e, current) == expect)) return true;
      list.add(current);
    }
    return false;
  }

  bool get anyIsEqual => anyOf((a, b) => a == b ? 0 : -1, expect: 0);

  bool get anyIsDifferent => anyOf((a, b) => a != b ? 0 : -1, expect: 0);

  bool anyWithIndex(Checker<I> checker, {int start = 0}) {
    int index = start - 1;
    return any((element) => checker(++index, element));
  }

  bool anyElementWith<P>(
    Iterable<P> another,
    Differentiator<I, P> differentiate, {
    int expect = 0,
  }) {
    assert(length == another.length);
    final i1 = iterator;
    final i2 = another.iterator;
    while (i1.moveNext() && i2.moveNext()) {
      if (differentiate(i1.current, i2.current) == expect) return true;
    }
    return false;
  }

  bool anyElementIsEqualWith(Iterable<I> another) => anyElementWith(
        another,
        (v1, v2) => v1 == v2 ? 0 : -1,
        expect: 0,
      );

  bool anyElementIsDifferentWith(Iterable<I> another) => anyElementWith(
        another,
        (v1, v2) => v1 != v2 ? 0 : -1,
        expect: 0,
      );

  ///
  /// [everyIsEqual], [everyIsDifferent]
  /// [everyIsIdenticalOn]
  /// [everyWithIndex]
  /// [everyElementsWith], [everyElementsAreEqualWith], [everyElementsAreDifferentWith]
  ///
  bool get everyIsEqual => !anyIsDifferent;

  bool get everyIsDifferent => !anyIsEqual;

  bool everyIsIdenticalOn<T>(Translator<I, T> toId) => toSet().length == length;

  bool everyWithIndex(Checker<I> checker, {int start = 0}) {
    int index = start - 1;
    return every((element) => checker(++index, element));
  }

  bool everyElementsWith<P>(
    Iterable<P> another,
    Differentiator<I, P> differentiate, {
    int expect = 0,
  }) {
    assert(length == another.length);
    final i1 = iterator;
    final i2 = another.iterator;
    while (i1.moveNext() && i2.moveNext()) {
      if (differentiate(i1.current, i2.current) != expect) {
        return false;
      }
    }
    return true;
  }

  bool everyElementsAreEqualWith(Iterable<I> another) =>
      !anyElementIsDifferentWith(another);

  bool everyElementsAreDifferentWith(Iterable<I> another) =>
      !anyElementIsEqualWith(another);

  ///
  /// first where
  ///
  I? firstWhereOrNull(Predicator<I> test) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  ///
  /// [foldWithIndex], [foldWith]
  ///
  S foldWithIndex<S>(
    S initialValue,
    GeneratorFolder<S, I, S> folder, {
    int start = 0,
  }) {
    int index = start - 1;
    return fold(
      initialValue,
      (value, element) => folder(++index, value, element),
    );
  }

  S foldWith<S, P>(
    Iterable<P> another,
    S initialValue,
    Fusionor<S, I, P, S> fusionor,
  ) {
    var value = initialValue;
    iteratingAllWith(
      another,
      (e, eAnother) => value = fusionor(value, e, eAnother),
    );
    return value;
  }

  ///
  /// [reduceWithIndex], [reduceWith]
  /// [reduceTo], [reduceToNum], [reduceToString]
  /// [reduceTogether]
  ///
  I reduceWithIndex(
    GeneratorReducer<I> reducing, {
    int start = 0,
  }) {
    int index = start - 1;
    return reduce((value, element) => reducing(++index, value, element));
  }

  I reduceWith<S>(
    Iterable<S> another,
    Fusionor<S, I, I, I> fusionor, {
    int start = 0,
  }) {
    assert(isNotEmpty && another.isNotEmpty);
    final iterator = another.iterator;
    return reduce((v1, v2) {
      iterator.moveNext();
      return fusionor(iterator.current, v1, v2);
    });
  }

  S reduceTo<S>(
    Reducer<S> reducer,
    Translator<I, S> translator,
  ) {
    assert(isNotEmpty);
    final iterator = this.iterator..moveNext();
    S val = translator(iterator.current);
    while (iterator.moveNext()) {
      val = reducer(val, translator(iterator.current));
    }
    return val;
  }

  N reduceToNum<N extends num>({
    required Reducer<N> reducer,
    required Translator<I, N> translator,
  }) =>
      reduceTo(reducer, translator);

  String reduceToString([String separator = '\n']) =>
      fold('', (s1, s2) => '$s1$separator$s2');

  S reduceTogether<S>(
    Iterable<S> another,
    Fusionor<S, S, S, S> reducer,
    Translator<I, S> translator,
  ) {
    assert(another.isNotEmpty);
    final iterator = another.iterator;
    return reduceTo(
      (v1, v2) {
        iterator.moveNext();
        return reducer(iterator.current, v1, v2);
      },
      translator,
    );
  }

  ///
  /// [expandWithIndex], [expandWith]
  /// [flat]
  ///
  Iterable<S> expandWithIndex<S>(Mixer<I, int, Iterable<S>> mix) {
    int index = 0;
    return expand((element) => mix(element, index++));
  }

  Iterable<S> expandWith<S, Q>(List<Q> another, Mixer<I, Q, Iterable<S>> mix) {
    int index = 0;
    return expand((element) => mix(element, another[index++]));
  }

  Iterable<S> flat<S>() => fold<List<S>>(
        [],
        (list, element) => switch (element) {
          S() => list..add(element),
          Iterable<S>() => list..addAll(element),
          Iterable<Iterable<dynamic>>() => list..addAll(element.flat()),
          _ => throw UnimplementedError('$element is not iterable or $S'),
        },
      );

  ///
  /// map
  ///
  List<T> mapToList<T>(Translator<I, T> toElement) {
    final iterator = this.iterator;
    final list = <T>[];
    while (iterator.moveNext()) {
      list.add(toElement(iterator.current));
    }
    return list;
  }

  ///
  /// chunk
  ///
  /// list = [2, 3, 4, 6, 10, 3, 9];
  /// list.chunk([2, 1, 3, 1]); // [[2, 3], [4], [6, 10, 3], [9]]
  ///
  List<List<I>> chunk(Iterable<int> lengthOfEachChunk) {
    assert(lengthOfEachChunk.reduce((a, b) => a + b) == length);
    final iterator = this.iterator;
    final result = <List<I>>[];
    for (var l in lengthOfEachChunk) {
      final list = <I>[];
      for (var i = 0; i < l; i++) {
        iterator.moveNext();
        list.add(iterator.current);
      }
      result.add(list);
    }
    return result;
  }

  ///
  /// groupBy
  ///
  Map<S, List<I>> groupBy<S>(Translator<I, S> translator) {
    final map = <S, List<I>>{};
    for (var item in this) {
      map.update(
        translator(item),
        (value) => value..add(item),
        ifAbsent: () => [item],
      );
    }
    return map;
  }

  ///
  /// lengthFlatted
  ///
  int lengthFlatted<S>() => reduceToNum(
        reducer: (v1, v2) => v1 + v2,
        translator: (element) => switch (element) {
          S() => 1,
          Iterable<S>() => element.length,
          Iterable<Iterable<dynamic>>() => element.lengthFlatted(),
          _ => throw UnimplementedError('unknown type: $element for $S'),
        },
      );

  ///
  /// combine
  ///
  Iterable<MapEntry<I, V>> combine<V>(Iterable<V> values) =>
      foldWith<List<MapEntry<I, V>>, V>(
        values,
        [],
        (list, key, value) => list..add(MapEntry(key, value)),
      );
}

extension IterableIntExtension on Iterable<int> {
  int get sum => reduce((value, element) => value + element);
}

extension IterableDoubleExtension on Iterable<double> {
  double get sum => reduce(FReducer.doubleAdd);
  double get sumSquared => reduce(FReducer.doubleAddSquared);
}

///
/// [lengths]
/// [toStringPadLeft], [mapToStringJoin]
/// [everyElementsLengthAreEqualWith]
/// [foldWith2D]
///
extension IterableIterableExtension<I> on Iterable<Iterable<I>> {
  int get lengths => fold(0, (value, element) => value + element.length);

  String toStringPadLeft(int space) => mapToStringJoin(
        (row) => row.map((e) => e.toString().padLeft(space)).toString(),
      );

  String mapToStringJoin([
    Translator<Iterable<I>, String>? mapper,
    String separator = "\n",
  ]) =>
      map(mapper ?? (e) => e.toString()).join(separator);

  bool everyElementsLengthAreEqualWith<P>(Iterable<Iterable<P>> another) =>
      length == another.length &&
      everyElementsWith(
        another,
        (v1, v2) => v1.length == v2.length ? 0 : -1,
        expect: 0,
      );

  S foldWith2D<S, P>(
    Iterable<Iterable<P>> another,
    S initialValue,
    Fusionor<S, I, P, S> fusionor,
  ) {
    assert(everyElementsLengthAreEqualWith(another));
    return foldWith(
      another,
      initialValue,
      (value, e, eAnother) => value = e.foldWith(eAnother, value, fusionor),
    );
  }
}

extension IterableSetExtension<I> on Iterable<Set<I>> {
  Set<I> mergeAll() => reduce((a, b) => a..addAll(b));
}

///
///
/// static methods:
/// [generateFrom]
/// [generate2D], [generate2DSquare]
/// [fill2D], [fill2DSquare]
/// [linking]
///
/// instance methods:
/// [swap]
/// [add2], [addIfNotNull], [addFirstAndRemoveFirst]...
/// [getOrDefault],...
/// [update], [updateWithMapper], ...
/// [removeFirst], [removeWhereAndGet]
/// [fillUntil]
/// [copy], [copyFillUntil], [copyInOrder], ...
///
/// [split], [splitTwo]
/// [reversedExceptFirst]
///
/// [chunk]
///
/// [intersectionWith]
/// [differenceWith], [differenceIndexWith]
///
/// [mapToList]
///
///
extension ListExtension<T> on List<T> {
  ///
  /// static methods
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

  static List<List<T>> fill2D<T>(int rowCount, int columnCount, T value) =>
      generate2D(rowCount, columnCount, (i, j) => value);

  static List<List<T>> fill2DSquare<T>(int size, T value) =>
      fill2D(size, size, value);

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
  ///
  ///
  /// instance methods
  ///
  ///
  ///

  ///
  /// [isFixed], [isGrowable]
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
  /// [add2], [addIfNotNull]
  /// [addFirstAndRemoveFirst], [addFirstAndRemoveFirstAndGet], [addAllIfEmpty]
  ///
  void swap(int indexA, int indexB) {
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }

  void add2(T e1, T e2) => this
    ..add(e1)
    ..add(e2);

  void addIfNotNull(T? element) => element == null ? null : add(element);

  void addFirstAndRemoveFirst() => this
    ..add(first)
    ..removeFirst();

  T addFirstAndRemoveFirstAndGet() => (this
        ..add(first)
        ..removeFirst())
      .last;

  void addAllIfEmpty(Supplier<Iterable<T>> supplier) =>
      isEmpty ? addAll(supplier()) : null;

  ///
  /// [getOrDefault]
  /// [update], [updateWithMapper]
  /// [updateAll], [updateAllWithMapper]
  ///
  T getOrDefault(int position, T defaultValue) =>
      position < length ? this[position] : defaultValue;

  void update(int index, T value) => this[index] = value;

  void updateWithMapper(int index, Mapper<T> mapper) =>
      this[index] = mapper(this[index]);

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
  /// [removeFirst], [removeWhereAndGet]
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
  /// [copyFillUntil], [copyInOrder]
  ///
  List<T> get copy => List.of(this);

  List<T> copyFillUntil(int length, T value) => [
        ...this,
        ...List.filled(length - this.length, value),
      ];

  ///
  /// list = [2, 3, 4, 6];
  /// list.copyInOrder([2, 1, 0, 3]); // [4, 3, 2, 6]
  ///
  List<T> copyInOrder(Iterable<int> order) {
    final length = this.length;
    assert(Iterable.generate(length).everyElementsAreEqualWith(
      order.toList(growable: false)..sort(),
    ));

    final list = <T>[];
    for (var i in order) {
      list.add(this[i]);
    }
    return list;
  }

  ///
  ///
  /// overall operations
  /// [split], [splitTwo]
  /// [reversedExceptFirst]
  ///
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

  List<T> get reversedExceptFirst {
    final length = this.length - 1;
    final result = <T>[first];
    for (var i = length; i > 0; i--) {
      result.add(this[i]);
    }
    return result;
  }

  ///
  ///
  /// set operations, see also [Set.intersection], [Set.difference],
  ///
  /// [intersectionWith]
  /// [differenceWith], [differenceIndexWith]
  ///
  Map<int, T> intersectionWith(List<T> others) {
    final maxLength = math.min(length, others.length);
    final intersection = <int, T>{};

    for (var index = 0; index < maxLength; index++) {
      final current = this[index];
      if (current == others[index]) {
        intersection.putIfAbsent(index, () => current);
      }
    }

    return intersection;
  }

  Map<int, T> differenceWith(List<T> others) =>
      differenceIndexWith(others).fold(
        <int, T>{},
        (difference, i) => difference..putIfAbsent(i, () => this[i]),
      );

  List<int> differenceIndexWith(List<T> others) {
    final difference = <int>[];
    void put(int index) => difference.add(index);

    final differentiationLength = math.min(length, others.length);
    for (var index = 0; index < differentiationLength; index++) {
      final current = this[index];
      if (current != others[index]) put(index);
    }

    if (length > others.length) {
      for (var index = others.length; index < length; index++) {
        put(index);
      }
    }

    return difference;
  }

  ///
  /// [mapByGenerate]
  /// [mapToList], [mapToListWith], [mapToListAccompany]
  ///
  List<E> mapByGenerate<E>(Generator<E> generator, {bool growable = true}) {
    final length = this.length;
    return List.of(
      [for (var i = 0; i < length; i++) generator(i)],
      growable: growable,
    );
  }

  List<E> mapToList<E>(Translator<T, E> toElement, {bool growable = true}) =>
      mapByGenerate((i) => toElement(this[i]));

  List<E> mapToListWith<E>(
    List<E> another,
    Reducer<E> reducer,
    Translator<T, E> toElement, {
    bool growable = true,
  }) =>
      mapByGenerate((index) => reducer(toElement(this[index]), another[index]));

  List<E> mapToListAccompany<E>(
    List<T> another,
    Reducer<T> reducer,
    Translator<T, E> toElement, {
    bool growable = true,
  }) =>
      mapByGenerate((index) => toElement(reducer(this[index], another[index])));

  ///
  /// [accordinglyAccompany]
  /// [accordinglyWith]
  ///
  List<T> accordinglyAccompany(
    List<T> another,
    Reducer<T> reducer, {
    bool growable = true,
  }) =>
      mapByGenerate(
        (index) => reducer(this[index], another[index]),
        growable: growable,
      );

  List<T> accordinglyWith<E>(
    List<E> another,
    Companion<T, E> companion, {
    bool growable = true,
  }) =>
      mapByGenerate(
        (index) => companion(this[index], another[index]),
        growable: growable,
      );
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

extension ListListExtension<T> on List<List<T>> {
  int get lengthFirst => first.length;

  bool get isArray2D {
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

extension ListSetExtension<I> on List<Set<I>> {
  void forEachAddAll(List<Set<I>>? another) {
    if (another != null) {
      for (var i = 0; i < length; i++) {
        this[i].addAll(another[i]);
      }
    }
  }

  void mergeAndRemoveThat(int i, int j) {
    this[i].addAll(this[j]);
    removeAt(j);
  }

  void mergeAndRemoveThis(int i, int j) {
    this[j].addAll(this[i]);
    removeAt(i);
  }

  void mergeWhereAndRemoveAllAndAdd(Predicator<Set<I>> predicator) =>
      add(removeWhereAndGet(predicator).mergeAll());
}

extension SetExtension<K> on Set<K> {
  Map<K, V> valuingToMap<V>(Translator<K, V> valuing) =>
      Map.fromIterables(this, map(valuing));
}

///
///
///
///
///
/// map entry, map
///
///
///
///
///
///

extension MapEntryExtension<K, V> on MapEntry<K, V> {
  MapEntry<V, K> get reversed => MapEntry(value, key);

  String join([String separator = '']) => '$key$separator$value';
}

extension MapEntryIterableExtension<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> get toMap => Map.fromEntries(this);
}

///
/// [notContainsKey]
/// [containsKeys]
/// [updateIfNotNull]
///
/// [keysIntersectionWith], [keysDifferenceWith]
/// [addAllDifference],
/// [removeFrom], [removeDifference], [removeIntersection]
/// [updateFrom], [updateDifference], [updateIntersection]
///
/// [mergeAs]
///
/// [join], [joinKeys], [joinValues]
/// [everyKeys], [everyValues]
/// [anyKeys], [anyValues]
/// [fold], [foldWithIndex], [foldKeys], [foldValues]
/// [reduceKeys], [reduceValues], [reduceTo], [reduceToNum]
///
/// [mapKeys], [mapValues]
///
extension MapExtension<K, V> on Map<K, V> {
  bool notContainsKey(K key) => !containsKey(key);

  bool containsKeys(Iterable<K> keys) {
    for (var key in keys) {
      if (notContainsKey(key)) return false;
    }
    return true;
  }

  V? updateIfNotNull(K? key, Mapper<V> mapper, {Supplier<V>? ifAbsent}) =>
      key == null ? null : update(key, mapper, ifAbsent: ifAbsent);

  ///
  /// [keysSet]
  /// [keysIntersectionWith], [keysDifferenceWith]
  ///
  Set<K> get keysSet => keys.toSet();

  Iterable<K> keysIntersectionWith(Set<K> another) =>
      keysSet.intersection(another);

  Iterable<K> keysDifferenceWith(Set<K> another) => keysSet.difference(another);

  ///
  /// add
  ///
  void addAllDifference(Set<K> keys, V Function(K key) valuing) =>
      addAll(keys.difference(keysSet).valuingToMap(valuing));

  ///
  /// remove
  ///
  Iterable<V> removeFrom(Iterable<K> keys) sync* {
    for (var key in keys) {
      final value = remove(key);
      if (value != null) yield value;
    }
  }

  Iterable<V> removeIntersection(Set<K> keys) =>
      removeFrom(keysIntersectionWith(keys));

  Iterable<V> removeDifference(Set<K> keys) =>
      removeFrom(keysDifferenceWith(keys));

  ///
  /// update
  ///
  Iterable<V> updateFrom(Iterable<K> keys, Companion<V, K> updating) sync* {
    for (var key in keys) {
      yield update(key, (value) => updating(value, key));
    }
  }

  Iterable<V> updateIntersection(Set<K> keys, Companion<V, K> updating) =>
      updateFrom(keysIntersectionWith(keys), updating);

  Iterable<V> updateDifference(Set<K> keys, Companion<V, K> updating) =>
      updateFrom(keysDifferenceWith(keys), updating);

  ///
  /// [mergeAs]
  ///
  Iterable<V> mergeAs(
    Set<K> keys,
    V Function(K key) valuing, {
    Companion<V, K>? update,
  }) sync* {
    yield* removeFrom(keysDifferenceWith(keys));
    yield* updateFrom(keysIntersectionWith(keys), update ?? FCompanion.keep);
    addAllDifference(keys, valuing);
  }

  ///
  /// join
  ///
  String join([String entrySeparator = '', String separator = '']) =>
      entries.map((entry) => entry.join(entrySeparator)).join(separator);

  String joinKeys([String separator = ', ']) => keys.join(separator);

  String joinValues([String separator = ', ']) => values.join(separator);

  ///
  /// every, any
  ///
  bool everyKeys(Predicator<K> test) => keys.every(test);

  bool everyValues(Predicator<V> test) => values.every(test);

  bool anyKeys(Predicator<K> test) => keys.any(test);

  bool anyValues(Predicator<V> test) => values.any(test);

  ///
  /// [fold]
  /// [foldWithIndex]
  /// [foldKeys], [foldValues]
  ///
  T fold<T>(
    T initialValue,
    Companion<T, MapEntry<K, V>> foldMap,
  ) =>
      entries.fold<T>(
        initialValue,
        (previousValue, element) => foldMap(previousValue, element),
      );

  T foldWithIndex<T>(
    T initialValue,
    Fusionor<T, MapEntry<K, V>, int, T> fusionor,
  ) {
    int index = -1;
    return entries.fold<T>(
      initialValue,
      (previousValue, element) => fusionor(previousValue, element, ++index),
    );
  }

  S foldKeys<S>(S initialValue, Companion<S, K> companion) =>
      keys.fold(initialValue, companion);

  S foldValues<S>(S initialValue, Companion<S, V> companion) =>
      values.fold(initialValue, companion);

  ///
  /// reduce
  ///
  K reduceKeys(Reducer<K> reducing) => keys.reduce(reducing);

  V reduceValues(Reducer<V> reducing) => values.reduce(reducing);

  S reduceTo<S>(Translator<MapEntry<K, V>, S> translator, Reducer<S> reducer) =>
      entries.reduceTo(reducer, translator);

  N reduceToNum<N extends num>({
    required Reducer<N> reducer,
    required Translator<MapEntry<K, V>, N> translator,
  }) =>
      entries.reduceToNum(reducer: reducer, translator: translator);

  ///
  /// map
  ///
  Map<K, V> mapKeys(Mapper<K> toElement) =>
      map((key, value) => MapEntry(toElement(key), value));

  Map<K, V> mapValues(Mapper<V> toElement) =>
      map((key, value) => MapEntry(key, toElement(value)));
}

extension MapKeyComparableExtension<K extends Comparable, V> on Map<K, V> {
  List<K> sortedKeys([Comparator<K>? compare]) => keys.toList()..sort(compare);

  Iterable<V> sortedValuesByKey([Comparator<K>? compare]) =>
      sortedKeys(compare).map((key) => this[key]!);

  Iterable<MapEntry<K, V>> sortedEntries([Comparator<K>? compare]) =>
      sortedKeys(compare).map((key) => MapEntry(key, this[key] as V));
}

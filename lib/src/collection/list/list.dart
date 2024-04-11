part of damath_collection;

///
///
/// static methods:
/// [applyAdd], ...
/// [generateFrom], ...
/// [fill2D], ...
///
/// instance methods:
/// [isFixed], ...
///
/// [addNext], ...
///
/// [fillUntil], ...
/// [clone], ...
/// [copyInto], ...
/// [splitBy], ...
/// [reversed]
/// [mapToList], ...
///
/// [interReduce], ...
/// [filled], ...
/// [apply], ...
///
///
extension ListExtension<T> on List<T> {
  ///
  /// [applyAdd]
  ///
  static Applier<List<T>> applyAdd<T>(T value) => (list) => list..add(value);

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
  /// [cloneSwitch]
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
  /// fill, copy
  /// [fillUntil]
  ///
  /// [clone],
  /// [cloneSwitch], [cloneWithFilling], [cloneByOrder]
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
  /// [clone]
  /// [cloneSwitch]
  /// [cloneWithFilling]
  /// [cloneByOrder]
  ///
  List<T> clone([bool growable = false]) => List.of(this, growable: growable);

  List<T> cloneSwitch([int interval = 1]) =>
      [...sublist(interval), ...sublist(0, interval)];

  List<T> cloneWithFilling(int total, T value, [bool trailing = true]) => [
        if (!trailing) ...List.filled(total - length, value, growable: false),
        ...this,
        if (trailing) ...List.filled(total - length, value, growable: false),
      ];

  List<T> cloneByOrder(Iterable<int> order) {
    assert(Iterable.generate(length).isVariationTo(order));
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
    assert(begin.rangeClose(0, length) && count < length - begin);

    final list = <List<T>>[];
    for (var i = begin; i < length; i += count) {
      list.add(sublist(i, i + count < length ? i + count : length));
    }
    return list;
  }

  List<List<T>> splitAt(List<int> positions, [int begin = 0, int? end]) {
    assert(positions.rangeIn(begin, end ?? length));
    return positions.iterator.foldAccompanyAfter(
      [],
      begin,
      (result, interval, i) => result..add(sublist(i, interval)),
      (i, interval) => interval,
    );
  }

  ///
  /// [reversed]
  /// [reversedExcept]
  ///
  List<T> reversed([bool growable = false]) => List.of(
        [for (var i = length - 1; i > -1; i--) this[i]],
        growable: growable,
      );

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
  /// [mapSublist]
  /// [mapSublistByIndex]
  ///
  List<S> mapSublist<S>(int begin, Mapper<T, S> mapper, [int? end]) {
    final length = end ?? this.length;
    assert(this.length.constraintsOpen(begin, length));
    final result = <S>[];
    for (var i = begin; i < length; i++) {
      result.add(mapper(this[i]));
    }
    return result;
  }

  List<S> mapSublistByIndex<S>(
    int begin,
    MapperGenerator<T, S> mapper, [
    int? end,
  ]) {
    final length = end ?? this.length;
    assert(this.length.constraintsOpen(begin, length));
    final result = <S>[];
    for (var i = begin; i < length; i++) {
      result.add(mapper(this[i], i));
    }
    return result;
  }

  ///
  /// [interReduce]
  /// [interCompanion]
  ///
  List<T> interReduce(List<T> other, Reducer<T> reducing) =>
      [for (var i = 0; i < length; i++) reducing(this[i], other[i])];

  List<T> interCompanion<E>(List<E> other, Companion<T, E> companion) =>
      [for (var i = 0; i < length; i++) companion(this[i], other[i])];

  ///
  /// [filled]
  /// [setFrom]
  ///
  void filled(T value) {
    for (var i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  void setFrom(List<T> another) {
    assert(length == another.length);
    for (var i = 0; i < length; i++) {
      this[i] = another[i];
    }
  }

  ///
  /// [apply]
  /// [applyByIndex]
  ///
  void apply(Applier<T> toVal) {
    for (var i = 0; i < length; i++) {
      this[i] = toVal(this[i]);
    }
  }

  void applyByIndex(ApplierGenerator<T> toVal) {
    for (var i = 0; i < length; i++) {
      this[i] = toVal(this[i], i);
    }
  }
}

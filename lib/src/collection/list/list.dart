part of damath_collection;
// ignore_for_file: curly_braces_in_flow_control_structures

///
///
/// static methods:
/// [applyAdd], ...
/// [generateFrom], ...
/// [fill2D], ...
///
/// instance methods:
/// [addIf], ...
/// [update], ...
/// [swap], ...
/// [filled], ...
///
/// [isFixed], ...
/// [addNext], ...
/// [fillFor], ...
///
/// [getOrDefault], ...
///
/// [removeAtWhere], ...
///
/// [clone], ...
/// [mapToList], ...
/// [reduceWith], ...
///
/// [splitBy], ...
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

  ///
  /// [fill2D]
  /// [fill2DSquare]
  ///
  static List<List<T>> fill2D<T>(int rowCount, int columnCount, T value) =>
      generate2D(rowCount, columnCount, (i, j) => value);

  static List<List<T>> fill2DSquare<T>(int size, T value) =>
      fill2D(size, size, value);

  ///
  ///
  ///
  ///
  /// consume
  /// [addIf], [addWhen], [addWhenNotNull]
  /// [addAllSupplyIfEmpty], [addAllSupplyIfNotEmpty], [addAllSupplyWhen]
  ///
  /// [update], [updateApply]
  /// [updateAll], [updateAllApply], [updateAllApplyByIndex]
  ///
  /// [swap], [swapIf]
  /// [filled], [fillGenerate], [fillUntil]
  /// [setAllFromIterable], [setAllFromList]
  ///
  ///
  ///
  ///

  ///
  /// [addIf]
  /// [addWhen]
  /// [addWhenNotNull]
  ///
  void addIf(Predicator<T> test, T element, [Consumer<T>? onNotAdd]) =>
      test(element) ? add(element) : onNotAdd?.call(element);

  void addWhen(bool shouldAdd, T element, [Consumer<T>? onNotAdd]) =>
      shouldAdd ? add(element) : onNotAdd?.call(element);

  void addWhenNotNull(T? element, [Listener? onNull]) =>
      element != null ? add(element) : onNull?.call();

  ///
  /// [addAllSupplyIfEmpty]
  /// [addAllSupplyIfNotEmpty]
  /// [addAllSupplyWhen]
  ///
  void addAllSupplyIfEmpty(
    Supplier<Iterable<T>> supply, [
    Listener? onNotEmpty,
  ]) =>
      isEmpty ? addAll(supply()) : onNotEmpty?.call();

  void addAllSupplyIfNotEmpty(
    Supplier<Iterable<T>> supply, [
    Listener? onEmpty,
  ]) =>
      isNotEmpty ? addAll(supply()) : onEmpty?.call();

  void addAllSupplyWhen(
    bool shouldAdd,
    Supplier<Iterable<T>> supply, [
    Listener? onNotSupply,
  ]) =>
      shouldAdd ? addAll(supply()) : onNotSupply?.call();

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
  /// [updateAllApplyByIndex]
  ///
  void updateAll(T value) {
    for (var i = 0; i < length; i++) this[i] = value;
  }

  void updateAllApply(Applier<T> applier) {
    for (var i = 0; i < length; i++) this[i] = applier(this[i]);
  }

  void updateAllApplyByIndex(ApplierGenerator<T> applier) {
    for (var i = 0; i < length; i++) this[i] = applier(this[i], i);
  }

  ///
  /// [swap]
  /// [swapIf]
  ///
  void swap(int iA, int iB) {
    final temp = this[iA];
    this[iA] = this[iB];
    this[iB] = temp;
  }

  void swapIf(int iA, int iB, PredicatorFusionor<T> test) {
    final a = this[iA];
    final b = this[iB];
    if (test(a, b)) {
      this[iA] = b;
      this[iB] = a;
    }
  }

  ///
  /// [filled]
  /// [fillGenerate]
  /// [fillUntil]
  ///
  void filled(T value) {
    for (var i = 0; i < length; i++) this[i] = value;
  }

  void fillGenerate(Generator<T> generate) {
    for (var i = 0; i < length; i++) this[i] = generate(i);
  }

  void fillUntil(int limit, T value) {
    for (var i = length; i < limit; i++) add(value);
  }

  ///
  /// [setAllFromIterable]
  /// [setAllFromList]
  ///
  void setAllFromIterable(Iterable<T> iterable) => length == iterable.length
      ? iterable.iterator.consumeAllByIndex((value, i) => this[i] = value)
      : throw StateError(FErrorMessage.iterableSizeInvalid);

  void setAllFromList(List<T> another) {
    if (length == another.length) {
      throw StateError(FErrorMessage.iterableSizeInvalid);
    }
    for (var i = 0; i < length; i++) this[i] = another[i];
  }

  ///
  ///
  /// predication
  /// [_tryModify]
  /// [isFixed], [isGrowable]
  /// [isImmutable], [isMutable]
  ///
  /// [addNext]
  ///
  /// [fillFor]
  ///
  ///
  ///

  ///
  /// [_tryModify]
  /// [isFixed], [isGrowable]
  /// [isImmutable], [isMutable]
  ///
  bool _tryModify(Mapper<String, bool> catcher) {
    try {
      add(removeLast());
    } on UnsupportedError catch (e) {
      return e.message.mapNotNullOr(catcher, () => false);
    }
    return false;
  }

  bool get isFixed => _tryModify((m) => m.contains('fixed-length list'));

  bool get isGrowable => !isFixed;

  bool get isImmutable => _tryModify((m) => m.contains('unmodifiable list'));

  bool get isMutable => !isImmutable;

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
  /// [fillFor]
  ///
  bool? fillFor(T value, int limit) {
    if (length >= limit) return null;
    if (isFixed || isImmutable) return false;
    for (var i = length; i < limit; i++) add(value);
    return true;
  }

  ///
  ///
  ///
  ///
  /// [getOrDefault]
  ///
  ///
  ///

  ///
  /// [getOrDefault]
  ///
  T getOrDefault(int position, Supplier<T> onOutOfBound) =>
      position < length ? this[position] : onOutOfBound();

  ///
  ///
  /// [removeAtWhere]
  /// [removeOn]
  ///
  ///

  ///
  /// [removeAtWhere]
  /// [removeOn]
  ///
  Iterable<T> removeAtWhere(Predicator<T> test) => [
        for (var i = 0; i < length; i++)
          if (test(this[i])) removeAt(i)
      ];

  Iterable<T> removeOn(
    Iterable<bool> positions, [
    Supplier<Iterable<T>>? onLess,
    Supplier<Iterable<T>>? onMore,
  ]) =>
      (positions.length - length).switchNatural(
        () => positions.iterator.takeFor(iterator),
        onLess,
        onMore,
      );

  ///
  /// fill, copy
  /// [clone],
  /// [cloneSwitch], [cloneWithFilling], [cloneByOrder]
  ///
  ///

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
  /// [reverseToList]
  /// [reverseToListExcept]
  ///
  List<T> get reverseToList => [for (var i = length - 1; i > -1; i--) this[i]];

  List<T> reverseToListExcept([int count = 1]) =>
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
  List<S> mapSublist<S>(int begin, Mapper<T, S> mapping, [int? end]) {
    if (length.isBoundClose(begin, end)) {
      throw StateError(FErrorMessage.iterableBoundaryInvalid);
    }
    final bound = end ?? length;
    return [for (var i = begin; i < bound; i++) mapping(this[i])];
  }

  List<S> mapSublistByIndex<S>(
    int begin,
    MapperGenerator<T, S> mapping, [
    int? end,
  ]) {
    if (length.isBoundClose(begin, end)) {
      throw StateError(FErrorMessage.iterableBoundaryInvalid);
    }
    final bound = end ?? length;
    return [for (var i = begin; i < bound; i++) mapping(this[i], i)];
  }

  ///
  /// [reduceWith]
  /// [companionWith]
  ///
  List<T> reduceWith(List<T> other, Reducer<T> reducing) =>
      [for (var i = 0; i < length; i++) reducing(this[i], other[i])];

  List<T> companionWith<E>(List<E> other, Companion<T, E> companion) =>
      [for (var i = 0; i < length; i++) companion(this[i], other[i])];

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
  List<List<T>> splitBy(
    int count, {
    int start = 0,
    int? end,
    bool includeTrailing = true,
  }) {
    final result = <List<T>>[];
    final bound = end ?? length;
    assert(length.isBoundClose(start, end) && count < bound - start);

    var i = start;
    final max = count * (bound ~/ count);
    for (; i < max; i += count) result.add(sublist(i, i + count));
    if (includeTrailing) result.add(sublist(i, bound));
    return result;
  }

  List<List<T>> splitAt(List<int> positions, [int begin = 0, int? end]) =>
      positions.boundIn(begin, end)
          ? positions.iterator.foldByAfter(
              [],
              begin,
              (result, interval, i) => result..add(sublist(i, interval)),
              (i, interval) => interval,
            )
          : throw StateError(FErrorMessage.iterableBoundaryInvalid);
}

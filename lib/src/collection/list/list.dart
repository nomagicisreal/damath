part of '../collection.dart';

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
/// [getOrDefault], ...
///
/// [mapToList], ...
/// [reduceWith], ...
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
  }) => List.generate(
    length,
    (index) => generator(index + start),
    growable: growable,
  );

  static List<List<T>> generate2D<T>(
    int rowCount,
    int columnCount,
    Generator2D<T> generator, {
    bool growable = false,
  }) => List.generate(
    rowCount,
    (i) =>
        List.generate(columnCount, (j) => generator(i, j), growable: growable),
    growable: growable,
  );

  static List<List<T>> generate2DSquare<T>(int d, Generator2D<T> generator) =>
      generate2D(d, d, generator, growable: false);

  ///
  /// [fill2D]
  /// [fill2DSquare]
  ///
  static List<List<T>> fill2D<T>(
    int rowCount,
    int columnCount,
    T value, {
    bool growable = false,
  }) => generate2D(rowCount, columnCount, (i, j) => value, growable: growable);

  static List<List<T>> fill2DSquare<T>(int size, T value) =>
      fill2D(size, size, value, growable: false);

  ///
  ///
  ///
  ///
  /// consume
  /// [addIf], [addWhen], [addIfNotNull]
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
  /// [addIfNotNull]
  ///
  void addIf(Predicator<T> test, T element, [Consumer<T>? onNotAdd]) =>
      test(element) ? add(element) : onNotAdd?.call(element);

  void addIfNotNull(T? element, [Callback? onNull]) =>
      element != null ? add(element) : onNull?.call();

  void addWhen(bool shouldAdd, Supplier<T> supply, [Consumer<T>? onNotAdd]) =>
      shouldAdd ? add(supply()) : onNotAdd?.call(supply());

  ///
  /// [addAllSupplyIfEmpty]
  /// [addAllSupplyIfNotEmpty]
  /// [addAllSupplyWhen]
  ///
  void addAllSupplyIfEmpty(
    Supplier<Iterable<T>> supply, [
    Callback? onNotEmpty,
  ]) => isEmpty ? addAll(supply()) : onNotEmpty?.call();

  void addAllSupplyIfNotEmpty(
    Supplier<Iterable<T>> supply, [
    Callback? onEmpty,
  ]) => isNotEmpty ? addAll(supply()) : onEmpty?.call();

  void addAllSupplyWhen(
    bool shouldAdd,
    Supplier<Iterable<T>> supply, [
    Callback? onNotSupply,
  ]) => shouldAdd ? addAll(supply()) : onNotSupply?.call();

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
  /// [updateReduce]
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

  void updateAllApplyByIndex(ApplierGenerator<T> applier) {
    for (var i = 0; i < length; i++) {
      this[i] = applier(this[i], i);
    }
  }

  void updateReduce(Reducer<T> reducing, List<T> another) {
    for (var i = 0; i < another.length; i++) {
      this[i] = reducing(this[i], another[i]);
    }
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

  void swapIf(int iA, int iB, PredicatorReducer<T> test) {
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
    for (var i = 0; i < length; i++) {
      this[i] = value;
    }
  }

  void fillGenerate(Generator<T> generate) {
    for (var i = 0; i < length; i++) {
      this[i] = generate(i);
    }
  }

  void fillUntil(int limit, T value) {
    for (var i = length; i < limit; i++) {
      add(value);
    }
  }

  ///
  /// [setAllFromIterable]
  /// [setAllFromList]
  ///
  void setAllFromIterable(Iterable<T> iterable) =>
      length == iterable.length
          ? iterable.iterator.consumeAllByIndex((value, i) => this[i] = value)
          : throw StateError(ErrorMessage.iterableSizeInvalid);

  void setAllFromList(List<T> another) {
    if (length == another.length) {
      throw StateError(ErrorMessage.iterableSizeInvalid);
    }
    for (var i = 0; i < length; i++) {
      this[i] = another[i];
    }
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
      final message = e.message;
      if (message == null) return false;
      return catcher(message);
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
    for (var i = length; i < limit; i++) {
      add(value);
    }
    return true;
  }

  ///
  /// [getOrDefault]
  /// [removalWhere]
  ///
  T getOrDefault(int position, Supplier<T> onInvalidPosition) =>
      position > -1 && position < length ? this[position] : onInvalidPosition();

  Iterable<T> removalWhere(Predicator<T> test) sync* {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) yield removeAt(i);
    }
  }

  ///
  /// fill, copy
  /// [clone],
  /// [cloneHeadTailSwitch], [cloneWithFilling], [cloneByOrder]
  ///
  ///

  ///
  /// [cloneHeadTailSwitch]
  /// [cloneWithFilling]
  /// [cloneByOrder]
  ///
  List<T> cloneHeadTailSwitch([int interval = 1]) => [
    ...sublist(interval),
    ...sublist(0, interval),
  ];

  List<T> cloneWithFilling(int total, T value, [bool fillOnTail = true]) => [
    if (!fillOnTail) ...List.filled(total - length, value, growable: false),
    ...this,
    if (fillOnTail) ...List.filled(total - length, value, growable: false),
  ];

  List<T> cloneByOrder(Iterable<int> order) {
    assert(Iterable.generate(length).isVariantTo(order));
    return [for (var i in order) this[i]];
  }

  ///
  /// [reverseToList]
  /// [reverseToListExcept]
  ///
  List<T> get reverseToList => [for (var i = length - 1; i > -1; i--) this[i]];

  List<T> reverseToListExcept([int count = 1]) => [
    ...sublist(count),
    ...sublist(count).reversed,
  ];

  ///
  /// [mapToList], ...
  /// [mapSublist], ...
  ///
  List<E> mapToList<E>(Mapper<T, E> toVal) => [
    for (var i = 0; i < length; i++) toVal(this[i]),
  ];

  List<E> mapToListWithByNew<E>(
    List<E> other,
    Reducer<E> reducing,
    Mapper<T, E> toVal,
  ) => [for (var i = 0; i < length; i++) reducing(toVal(this[i]), other[i])];

  List<E> mapToListWithByOld<E>(
    List<T> other,
    Reducer<T> reducing,
    Mapper<T, E> toVal,
  ) => [for (var i = 0; i < length; i++) toVal(reducing(this[i], other[i]))];

  List<S> mapToListTogether<S, E>(
    List<E> other,
    Reducer<S> reducing,
    Mapper<T, S> toVal,
    Mapper<E, S> toValOther,
  ) => [
    for (var i = 0; i < length; i++)
      reducing(toVal(this[i]), toValOther(other[i])),
  ];

  ///
  ///
  ///
  List<S> mapSublist<S>(int begin, Mapper<T, S> mapping, [int? end]) {
    if (length.isUpperClose(begin, end)) {
      throw StateError(ErrorMessage.iterableBoundaryInvalid);
    }
    final bound = end ?? length;
    return [for (var i = begin; i < bound; i++) mapping(this[i])];
  }

  List<S> mapSublistByIndex<S>(
    int begin,
    MapperGenerator<T, S> mapping, [
    int? end,
  ]) {
    if (length.isUpperClose(begin, end)) {
      throw StateError(ErrorMessage.iterableBoundaryInvalid);
    }
    final bound = end ?? length;
    return [for (var i = begin; i < bound; i++) mapping(this[i], i)];
  }

  ///
  ///
  ///
  List<T> reduceWith(List<T> other, Reducer<T> reducing) => [
    for (var i = 0; i < length; i++) reducing(this[i], other[i]),
  ];

  List<T> companionWith<E>(List<E> other, Companion<T, E> companion) => [
    for (var i = 0; i < length; i++) companion(this[i], other[i]),
  ];

  List<T> sandwich(List<T> meat) {
    if (length != meat.length + 1) throw Exception('invalid sandwich');
    // return iterator.sandwich(meat.iterator); // bad performance
    final result = <T>[];
    var i = 0;
    for (; i < meat.length; i++) {
      result.add(this[i]);
      result.add(meat[i]);
    }
    return result..add(this[i]);
  }

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
    assert(length.isUpperClose(start, end) && count < bound - start);

    var i = start;
    final max = count * (bound ~/ count);
    for (; i < max; i += count) {
      result.add(sublist(i, i + count));
    }
    if (includeTrailing) result.add(sublist(i, bound));
    return result;
  }

  List<List<T>> splitAt(List<int> positions, [int begin = 0, int? end]) =>
      positions.iterator.foldByAfter(
        [],
        begin,
        (result, interval, i) => result..add(sublist(i, interval)),
        (i, interval) => interval,
      );
}

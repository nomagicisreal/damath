///
///
///
part of '../collection.dart';
// ignore_for_file: curly_braces_in_flow_control_structures

///
///
/// [preempt1By1], ...
/// [preemptAByB], ...
/// [preemptFinal2By1], ...
/// [forEverySublist2], ...
/// [mergeSortArrange], ...
///
///
abstract class _Sort {
  const _Sort();

  ///
  ///
  /// [preempt1By1], [preempt1By3]
  /// [preempt2By1], [preempt2By3]
  /// [preempt3By1], [preempt3By3]
  /// [preempt4By1], [preempt4By3]
  ///
  ///

  ///
  /// [preempt1By1]
  /// [preempt1By3]
  ///
  ///

  //
  static void preempt1By1<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C b1,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      list[i] = a1;
      return;
    }
    list[i++] = b1;
    list[i] = a1;
  }

  //
  static void preempt1By3<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C b1,
    C b2,
    C b3,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      list[i] = a1;
      return;
    }
    list[i++] = b1;
    if (keepFirst(a1, b2)) {
      list[i] = a1;
      return;
    }
    preempt1By1(list, i, keepFirst, b2, a1, b3);
  }

  ///
  ///
  /// [preempt2By1]
  /// [preempt2By3]
  ///
  ///

  //
  static void preempt2By1<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C b1,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      preempt1By1(list, i, keepFirst, a1, a2, b1);
      return;
    }
    list[i++] = b1;
    list[i++] = a1;
    list[i] = a2;
  }

  //
  static void preempt2By3<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C b1,
    C b2,
    C b3,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      preempt1By3(list, i, keepFirst, a1, a2, b1, b2, b3);
      return;
    }
    list[i++] = b1;
    if (keepFirst(a1, b2)) {
      list[i++] = a1;
      if (keepFirst(a2, b2)) {
        list[i] = a2;
        return;
      }
      preempt1By1(list, i, keepFirst, b2, a2, b3);
      return;
    }
    preempt2By1(list, i, keepFirst, b2, a1, a2, b3);
  }

  ///
  ///
  /// [preempt3By1]
  /// [preempt3By3]
  ///
  ///

  //
  static void preempt3By1<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C a3,
    C b1,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      preempt2By1(list, i, keepFirst, a1, a2, a3, b1);
      return;
    }
    list[i++] = b1;
    list[i++] = a1;
    list[i++] = a2;
    list[i] = a3;
  }

  //
  static void preempt3By3<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C a3,
    C b1,
    C b2,
    C b3,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      preempt2By3(list, i, keepFirst, a1, a2, a3, b1, b2, b3);
      return;
    }
    list[i++] = b1;
    if (keepFirst(a1, b2)) {
      list[i++] = a1;
      if (keepFirst(a2, b2)) {
        list[i++] = a2;
        if (keepFirst(a3, b2)) {
          list[i] = a3;
          return;
        }
        preempt1By1(list, i, keepFirst, b2, a3, b3);
        return;
      }
      preempt2By1(list, i, keepFirst, b2, a2, a3, b3);
      return;
    }
    preempt3By1(list, i, keepFirst, b2, a1, a2, a3, b3);
  }

  ///
  ///
  /// [preempt4By1]
  /// [preempt4By3]
  /// [preempt4By7]
  ///
  ///

  //
  static void preempt4By1<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C a3,
    C a4,
    C b1,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      preempt3By1(list, i, keepFirst, a1, a2, a3, a4, b1);
      return;
    }
    list[i++] = b1;
    list[i++] = a1;
    list[i++] = a2;
    list[i++] = a3;
    list[i] = a4;
  }

  //
  static void preempt4By3<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C a3,
    C a4,
    C b1,
    C b2,
    C b3,
  ) {
    list[i++] = start;
    if (keepFirst(a1, b1)) {
      preempt3By3(list, i, keepFirst, a1, a2, a3, a4, b1, b2, b3);
      return;
    }
    list[i++] = b1;
    if (keepFirst(a1, b2)) {
      list[i++] = a1;
      if (keepFirst(a2, b2)) {
        list[i++] = a2;
        if (keepFirst(a3, b2)) {
          list[i++] = a3;
          if (keepFirst(a4, b2)) {
            list[i] = a4;
            return;
          }
          preempt1By1(list, i, keepFirst, b2, a4, b3);
          return;
        }
        preempt2By1(list, i, keepFirst, b2, a3, a4, b3);
        return;
      }
      preempt3By1(list, i, keepFirst, b2, a2, a3, a4, b3);
      return;
    }
    preempt4By1(list, i, keepFirst, b2, a1, a2, a3, a4, b3);
  }

  ///
  ///
  /// [preemptAByB]
  ///
  ///
  //
  static void preemptAByB<C>(
    List<C> list,
    List<C> aSpace,
    PredicatorFusionor<C> keepFirst,
    C start,
    int k,
    int aStart,
    int aMax,
    int bStart,
    int bMax,
  ) {
    list[k++] = start;
    var m = aStart;
    var n = bStart;
    var a = aSpace[m++];

    void trailing() {
      while (true) {
        list[k++] = a;
        if (m < aMax) {
          a = aSpace[m++];
          continue;
        }
        return;
      }
    }

    try {
      var b = list[n++];
      while (true) {
        if (keepFirst(a, b)) {
          list[k++] = a;
          if (m < aMax) {
            a = aSpace[m++];
            continue;
          }
          return;
        }
        list[k++] = b;
        if (n < bMax) {
          b = list[n++];
          continue;
        }
        trailing();
        return;
      }
    } on RangeError catch (_) {
      trailing();
      return;
    }
  }

  ///
  ///
  ///
  /// [preemptFinal2By1]
  /// [preemptFinal4By1], [preemptFinal4By2], [preemptFinal4By3]
  ///
  ///
  ///

  //
  static void preemptFinal2By1<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C a1,
    C a2,
    C b1,
  ) {
    if (keepFirst(a1, b1)) {
      i++;
      if (keepFirst(a2, b1)) return;
      list[i++] = b1;
      list[i] = a2;
      return;
    }
    list[i++] = b1;
    list[i++] = a1;
    list[i] = a2;
  }

  ///
  ///
  /// [preemptFinal4By1], [preemptFinal4By2], [preemptFinal4By3]
  ///
  ///

  //
  static void preemptFinal4By1<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C a1,
    C a2,
    C a3,
    C a4,
    C b1,
  ) {
    if (keepFirst(a1, b1)) {
      i++;
      if (keepFirst(a2, b1)) {
        preemptFinal2By1(list, i + 1, keepFirst, a3, a4, b1);
        return;
      }
      list[i++] = b1;
      list[i++] = a1;
      list[i++] = a2;
      list[i] = a3;
      return;
    }
    list[i++] = b1;
    list[i++] = a1;
    list[i++] = a2;
    list[i++] = a3;
    list[i] = a4;
  }

  //
  static void preemptFinal4By2<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C a1,
    C a2,
    C a3,
    C a4,
    C b1,
    C b2,
  ) {
    if (keepFirst(a1, b1)) {
      if (keepFirst(a2, b1)) {
        if (keepFirst(a3, b1)) {
          if (keepFirst(a4, b1)) return;
          preempt1By1(list, i, keepFirst, b1, a4, b2);
          return;
        }
        list[i++] = b1;
        if (keepFirst(a2, b2)) {
          preempt1By1(list, i, keepFirst, a3, a4, b2);
          return;
        }
        list[i++] = b2;
        list[i++] = a3;
        list[i] = a4;
        return;
      }
      preempt3By1(list, i, keepFirst, b1, a2, a3, a4, b2);
      return;
    }
    preempt4By1(list, i, keepFirst, b1, a1, a2, a3, a4, b2);
  }

  //
  static void preemptFinal4By3<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C a1,
    C a2,
    C a3,
    C a4,
    C b1,
    C b2,
    C b3,
  ) {
    if (keepFirst(a1, b1)) {
      if (keepFirst(a2, b1)) {
        if (keepFirst(a3, b1)) {
          if (keepFirst(a4, b1)) return;
          list[i++] = b1;
          if (keepFirst(a4, b2)) {
            list[i] = a4;
            return;
          }
          preempt1By1(list, i, keepFirst, b2, a4, b3);
          return;
        }
        list[i++] = b1;
        if (keepFirst(a3, b2)) {
          list[i++] = a3;
          if (keepFirst(a4, b2)) {
            list[i] = a4;
            return;
          }
          preempt1By1(list, i, keepFirst, b2, a4, b3);
          return;
        }
        preempt2By1(list, i, keepFirst, b2, a3, a4, b3);
        return;
      }
      list[i++] = b1;
      if (keepFirst(a2, b2)) {
        list[i++] = a2;
        if (keepFirst(a3, b2)) {
          list[i++] = a3;
          if (keepFirst(a4, b2)) {
            list[i] = a4;
            return;
          }
          preempt1By1(list, i, keepFirst, b2, a4, b3);
          return;
        }
        preempt2By1(list, i, keepFirst, b2, a3, a4, b3);
        return;
      }
      preempt3By1(list, i, keepFirst, b2, a2, a3, a4, b3);
      return;
    }
    list[i++] = b1;
    if (keepFirst(a1, b2)) {
      list[i++] = a1;
      if (keepFirst(a2, b2)) {
        list[i++] = a2;
        if (keepFirst(a3, b2)) {
          list[i++] = a3;
          if (keepFirst(a4, b2)) {
            list[i] = a4;
            return;
          }
          preempt1By1(list, i, keepFirst, b2, a4, b3);
          return;
        }
        preempt2By1(list, i, keepFirst, b2, a3, a4, b3);
        return;
      }
      preempt3By1(list, i, keepFirst, b2, a2, a3, a4, b3);
      return;
    }
    preempt4By1(list, i, keepFirst, b2, a1, a2, a3, a4, b3);
  }

  ///
  ///
  /// [forEverySublist2]
  /// [forEverySublist4]
  /// [forEverySublist8]
  /// [forEverySublist16]
  /// [forEverySublist32]
  ///
  ///

  //
  static void forEverySublist2<C>(
    List<C> list,
    PredicatorFusionor<C> keepFirst,
    int n,
  ) {
    final boundary = n.isEven ? n : n - 1;
    for (var l = 0; l < boundary; l += 2) {
      final a = list[l];
      final b = list[l + 1];
      if (keepFirst(a, b)) continue;
      list[l] = b;
      list[l + 1] = a;
    }
  }

  //
  static void forEverySublist4<C>(
    List<C> list,
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
  ) {
    final boundary = n - remainder;
    for (var l = 0; l < boundary; l += 4) {
      final a1 = list[l];
      final a2 = list[l + 1];
      final b1 = list[l + 2];
      final b2 = list[l + 3];

      if (keepFirst(a1, b1)) {
        if (keepFirst(a2, b1)) continue;
        _Sort.preempt1By1(list, l + 1, keepFirst, b1, a2, b2);
        continue;
      }
      _Sort.preempt2By1(list, l, keepFirst, b1, a1, a2, b2);
    }
    if (remainder < 3) return;
    preemptFinal2By1(
      list,
      boundary,
      keepFirst,
      list[boundary],
      list[boundary + 1],
      list[boundary + 2],
    );
  }

  //
  static void forEverySublist8<C>(
    List<C> list,
    List<C> space,
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
  ) {
    final boundary = n - remainder;
    for (var l = 0; l < boundary; l += 8) {
      final a1 = list[l];
      final a2 = list[l + 1];
      final a3 = list[l + 2];
      final a4 = list[l + 3];
      final b1 = list[l + 4];
      final b2 = list[l + 5];
      final b3 = list[l + 6];
      final b4 = list[l + 7];

      if (keepFirst(a1, b1)) {
        if (keepFirst(a2, b1)) {
          if (keepFirst(a3, b1)) {
            if (keepFirst(a4, b1)) continue;
            _Sort.preempt1By3(list, l + 3, keepFirst, b1, a4, b2, b3, b4);
            continue;
          }
          _Sort.preempt2By3(list, l + 2, keepFirst, b1, a3, a4, b2, b3, b4);
          continue;
        }
        _Sort.preempt3By3(list, l + 1, keepFirst, b1, a2, a3, a4, b2, b3, b4);
        continue;
      }
      _Sort.preempt4By3(list, l, keepFirst, b1, a1, a2, a3, a4, b2, b3, b4);
    }
    if (remainder < 5) return;

    final a1 = list[boundary];
    final a2 = list[boundary + 1];
    final a3 = list[boundary + 2];
    final a4 = list[boundary + 3];
    final b1 = list[boundary + 4];
    if (remainder > 5) {
      final b2 = list[boundary + 5];
      if (remainder > 6) {
        preemptFinal4By3(list, boundary, keepFirst, a1, a2, a3, a4, b1, b2,
            list[boundary + 6]);
        return;
      }
      preemptFinal4By2(list, boundary, keepFirst, a1, a2, a3, a4, b1, b2);
      return;
    }
    preemptFinal4By1(list, boundary, keepFirst, a1, a2, a3, a4, b1);
  }

  //
  static void forEverySublist16<C extends Comparable>(
    List<C> list,
    List<C> space,
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
  ) {
    final boundary = n - remainder;
    for (var l = 0; l < boundary; l += 16) {
      for (var k = 0; k < 8; k++) space[k] = list[l + k];
      final b1 = list[l + 8];

      for (var i = 0; i < 8; i++) {
        if (keepFirst(space[i], b1)) continue;
        preemptAByB(
          list,
          space,
          keepFirst,
          b1,
          l + i,
          i,
          8,
          l + 9,
          l + 16,
        );
        break;
      }
    }
    if (remainder < 9) return;
    mergeSortPreemptRemain(list, space, keepFirst, boundary, boundary + 8, n);
  }

  //
  static void forEverySublist32<C extends Comparable>(
    List<C> list,
    List<C> space,
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
  ) {
    final boundary = n - remainder;
    for (var l = 0; l < boundary; l += 32) {
      for (var k = 0; k < 16; k++) space[k] = list[l + k];
      final b1 = list[l + 16];

      //
      for (var i = 0; i < 16; i++) {
        if (keepFirst(space[i], b1)) continue;
        preemptAByB(
          list,
          space,
          keepFirst,
          b1,
          l + i,
          i,
          16,
          l + 17,
          l + 32,
        );
        break;
      }
    }
    if (remainder < 17) return;
    mergeSortPreemptRemain(list, space, keepFirst, boundary, boundary + 16, n);
  }

  ///
  ///
  /// [mergeSortArrange]
  /// [mergeSortPreempt]
  /// [mergeSortPreemptRemain]
  ///
  ///

  ///
  /// [mergeSortArrange] is a function that retrieves the current list values range from [start] to [end],
  /// and assert that both of the sublist from [start] to [mid] and [mid] to [end] are sorted.
  ///
  /// [space] is used for caching sorted values during the function call. its position is according to current list.
  /// below is the variables inside the function:
  ///   - [m] is the index representing the first sorted part, its value range between from [start] to [mid].
  ///   - [n] is the index representing the second sorted part, its value range between from [mid] to [end].
  ///   - [k] is the index representing the sorted order, its value range between [start] to [end].
  ///
  /// it's a general way but not efficient enough,
  ///
  static void mergeSortArrange<C>(
    List<C> list,
    List<C> space,
    PredicatorFusionor<C> keepFirst,
    int start,
    int mid,
    int end,
  ) {
    var m = start;
    var n = mid;
    var k = start;

    var iElement = list[m++];
    var jElement = list[n++];

    void assignReverse() {
      m--;
      n = mid;
      k = end;
      while (n > m) list[--k] = list[--n];
    }

    late final int kStart;
    for (; true; iElement = list[m++]) {
      if (keepFirst(jElement, iElement)) {
        if (n == end) {
          assignReverse();
          list[m] = jElement;
          return;
        }
        kStart = k = m - 1;
        space[kStart] = jElement;
        jElement = list[n++];
        break;
      }
      if (m == mid) return;
    }

    while (true) {
      if (keepFirst(iElement, jElement)) {
        space[++k] = iElement;
        if (m == mid) {
          n--;

          for (k = kStart; k < n; k++) list[k] = space[k];
          return;
        }
        iElement = list[m++];
      } else {
        space[++k] = jElement;
        if (n == end) {
          assignReverse();
          while (k > kStart) list[--k] = space[k];
          return;
        }
        jElement = list[n++];
      }
    }
  }

  //
  static void mergeSortPreempt<C>(
    List<C> list,
    List<C> space,
    PredicatorFusionor<C> keepFirst,
    int sorted,
    int chunk,
    int boundary,
  ) {
    var k = 0;
    for (var l = 0; l < boundary; l += chunk, k = 0) {
      for (; k < sorted; k++) space[k] = list[l + k];
      final b1 = list[l + sorted];

      // final bStart = l + sorted;
      // final bEnd = l + (sorted << 1);
      // final b1 = list[bStart];

      // if (keepFirst(list[bEnd - 1], space[0])) {
      //   for (k = 0; k < sorted; k++) list[l + k] = list[bStart + k];
      //   for (k = 0; k < sorted; k++) list[bStart + k] = space[k];
      //   continue;
      // }

      for (var i = 0; i < sorted; i++) {
        if (keepFirst(space[i], b1)) continue;
        _Sort.preemptAByB(
          list,
          space,
          keepFirst,
          b1,
          l + i,
          i,
          sorted,
          l + sorted + 1,
          l + (sorted << 1),
        );
        break;
      }
    }
  }

  //
  static void mergeSortPreemptRemain<C>(
    List<C> list,
    List<C> space,
    PredicatorFusionor<C> keepFirst,
    int sorted,
    int boundary,
    int n,
  ) {
    for (var l = 0; l < sorted; l++) space[l] = list[boundary + l];
    final b1 = list[boundary + sorted];

    for (var i = 0; i < sorted; i++) {
      if (keepFirst(space[i], b1)) continue;
      _Sort.preemptAByB(
        list,
        space,
        keepFirst,
        b1,
        boundary + i,
        i,
        sorted,
        math.min(n, boundary + sorted + 1),
        n,
      );
      break;
    }
  }
}

///
///
///
part of damath_collection;

///
///
/// [preempt1By1], ...
/// [preemptFinal2By1], ...
/// [forEverySublist2], ...
///
///
abstract class _Sort {
  const _Sort();

  ///
  ///
  /// [preempt1By1], [preempt1By3], [preempt1By7]
  /// [preempt2By1], [preempt2By3], [preempt2By7]
  /// [preempt3By1], [preempt3By3], [preempt3By7]
  /// [preempt4By1], [preempt4By3], [preempt4By7]
  /// [preempt5By1], [preempt5By3], [preempt5By7]
  /// [preempt6By1], [preempt6By3], [preempt6By7]
  /// [preempt7By1], [preempt7By3], [preempt7By7]
  ///
  ///

  ///
  /// [preempt1By1]
  /// [preempt1By3]
  ///
  ///

  //
  static void preempt1By1<C extends Comparable>(
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
  static void preempt1By3<C extends Comparable>(
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
  static void preempt2By1<C extends Comparable>(
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
  static void preempt2By3<C extends Comparable>(
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
  static void preempt3By1<C extends Comparable>(
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
  static void preempt3By3<C extends Comparable>(
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
  ///
  ///

  //
  static void preempt4By1<C extends Comparable>(
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
  static void preempt4By3<C extends Comparable>(
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
  ///
  /// [preempt1By7]
  /// [preempt2By7]
  /// [preempt3By7]
  /// [preempt4By7]
  /// [preempt5By7]
  /// [preempt6By7]
  /// [preempt7By7]
  ///
  ///
  ///
  static void preempt7By7<C>(
    List<C> list,
    int i,
    PredicatorFusionor<C> keepFirst,
    C start,
    C a1,
    C a2,
    C a3,
    C a4,
    C a5,
    C a6,
    C a7,
    C b1,
    C b2,
    C b3,
    C b4,
    C b5,
    C b6,
    C b7,
  ) {
    // list[i++] = start;
    // if (keepFirst(a1, b1)) {
    //   list[i++] = a1;
    //   if (keepFirst(a2, b1)) {
    //     list[i++] = a2;
    //     if (keepFirst(a3, b1)) {
    //       list[i++] = a3;
    //       if (keepFirst(a4, b1)) {
    //         preempt4By1(list, i, (v1, v2) => false, start, a1, a2, a3, a4, b1)
    //       }
    //     }
    //   }
    // }
  }

  ///
  ///
  ///
  /// [preemptFinal2By1]
  /// [preemptFinal4By1], [preemptFinal4By2], [preemptFinal4By3]
  ///
  ///
  ///

  ///
  ///
  ///
  /// [preemptFinal2By1]
  ///
  ///
  ///

  //
  static void preemptFinal2By1<C extends Comparable>(
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
  /// [preemptFinal4By1]
  /// [preemptFinal4By2]
  /// [preemptFinal4By3]
  ///
  ///

  //
  static void preemptFinal4By1<C extends Comparable>(
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
  static void preemptFinal4By2<C extends Comparable>(
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
  static void preemptFinal4By3<C extends Comparable>(
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
  ///
  ///

  //
  static void forEverySublist2<C extends Comparable>(
    List<C> list,
    PredicatorFusionor<C> keepFirst,
    int n,
  ) {
    final boundary = n.isEven ? n : n - 1;
    for (var i = 0; i < boundary; i += 2) {
      final a = list[i];
      final b = list[i + 1];
      if (keepFirst(a, b)) continue;
      list[i] = b;
      list[i + 1] = a;
    }
  }

  //
  static void forEverySublist4<C extends Comparable>(
    List<C> list,
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
  ) {
    final boundary = n - remainder;
    for (var i = 0; i < boundary; i += 4) {
      final a1 = list[i];
      final a2 = list[i + 1];
      final b1 = list[i + 2];
      final b2 = list[i + 3];

      if (keepFirst(a1, b1)) {
        if (keepFirst(a2, b1)) continue;
        _Sort.preempt1By1(list, i + 1, keepFirst, b1, a2, b2);
        continue;
      }
      _Sort.preempt2By1(list, i, keepFirst, b1, a1, a2, b2);
    }
    if (remainder > 2) {
      preemptFinal2By1(
        list,
        boundary,
        keepFirst,
        list[boundary],
        list[boundary + 1],
        list[boundary + 2],
      );
    }
  }

  //
  static void forEverySublist8<C extends Comparable>(
    List<C> list,
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
  ) {
    final boundary = n - remainder;
    for (var i = 0; i < boundary; i += 8) {
      final a1 = list[i];
      final a2 = list[i + 1];
      final a3 = list[i + 2];
      final a4 = list[i + 3];
      final b1 = list[i + 4];
      final b2 = list[i + 5];
      final b3 = list[i + 6];
      final b4 = list[i + 7];

      if (keepFirst(a1, b1)) {
        if (keepFirst(a2, b1)) {
          if (keepFirst(a3, b1)) {
            if (keepFirst(a4, b1)) continue;
            _Sort.preempt1By3(list, i + 3, keepFirst, b1, a4, b2, b3, b4);
            continue;
          }
          _Sort.preempt2By3(list, i + 2, keepFirst, b1, a3, a4, b2, b3, b4);
          continue;
        }
        _Sort.preempt3By3(
            list, i + 1, keepFirst, b1, a2, a3, a4, b2, b3, b4);
        continue;
      }
      _Sort.preempt4By3(
          list, i, keepFirst, b1, a1, a2, a3, a4, b2, b3, b4);
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
    PredicatorFusionor<C> keepFirst,
    int remainder,
    int n,
    List<C> space,
  ) {
    final boundary = n - remainder;

    sort:
    for (var i = 0; i < boundary; i += 16) {
      final a1 = list[i];
      final a2 = list[i + 1];
      final a3 = list[i + 2];
      final a4 = list[i + 3];
      final a5 = list[i + 4];
      final a6 = list[i + 5];
      final a7 = list[i + 6];
      final a8 = list[i + 7];
      final b1 = list[i + 8];
      final b2 = list[i + 9];
      final b3 = list[i + 10];
      final b4 = list[i + 11];
      final b5 = list[i + 12];
      final b6 = list[i + 13];
      final b7 = list[i + 14];
      final b8 = list[i + 15];
      C getB(int j) => switch (j) {
            0 => b2,
            1 => b3,
            2 => b4,
            3 => b5,
            4 => b6,
            5 => b7,
            6 => b8,
            _ => throw UnimplementedError(),
          };

      if (keepFirst(a1, b1)) {
        if (keepFirst(a2, b1)) {
          if (keepFirst(a3, b1)) {
            if (keepFirst(a4, b1)) {
              if (keepFirst(a5, b1)) {
                if (keepFirst(a6, b1)) {
                  if (keepFirst(a7, b1)) {
                    if (keepFirst(a8, b1)) continue;
                    // preempt1ByRecord(list, i + 7, keepFirst, b1, a8,
                    //     recordBuild7(b2, b3, b4, b5, b6, b7, b8));
                    list[i + 7] = b1;
                    final base = i + 8;
                    for (var j = 0; j < 7; j++) {
                      final b = getB(j);
                      if (keepFirst(a8, b)) {
                        list[base + j] = a8;
                        continue sort;
                      }
                      list[base + j] = b;
                    }
                    continue;
                  }
                  list[i + 6] = b1;
                  final base = i + 7;

                  continue; // 6
                }
                continue; // 5
              }
              continue; // + 4
            }
            continue; // 3
          }
          continue; // 2
        }
        continue;
      }
    }
    // print('$list  :  after');
    if (remainder > 8) {
      list._sortMerge(space, boundary, boundary + 8, n, keepFirst);
    }
  }
}

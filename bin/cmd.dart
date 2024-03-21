import 'package:damath/src/math/api.dart';

void main(List<String> arguments) {
  // const d1 = 'the computer is complex';
  // const d2 = 'the computer is easy';
  // final pT = Proposition(d1, true);
  // final pF = Proposition(d1, false);
  // final qT = Proposition(d2, true);
  // final qF = Proposition(d2, false);
  //
  // print(((pT | -qT) > (pT & qT)).value);
  // print(((pT | -qF) > (pT & qF)).value);
  // print(((pF | -qT) > (pF & qT)).value);
  // print(((pF | -qF) > (pF & qF)).value);

  // final result = (pF | -qF) > (pF & qF);
  // print(result);

  // final list = [1, 3, 1, 2, 6, 10, -1, 8];
  // print((1, 2) == (1, 2));
  // print(list.iterator.cumulativeWhere((value) => value.isOdd));

  // final sets = <String, Set<int>>{
  //   'A': {1, 2},
  //   'B': {3, 4},
  //   'C': {1, 4},
  // };
  // print(sets.updateSet('A', 5));
  // print(sets.updateSet('B', 4));
  // print(sets);

  final node = ListExtension.generateFrom(10, (index) => index * 10);
  final interval = ListExtension.generateFrom(9, (index) => index);
  print(node.interval
    (
    interval,
    (v1, v2, other) => (v1 + v2) / 2 + other,
  ));
}

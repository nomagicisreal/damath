import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final list = List.generate(10, (i) => i)..shuffle();
  print(list);
  print(list.everyRangeIn(-1, 10, inclusiveMin: false, inclusiveMax: false));
  // print(list.rangeIn(0, 10, inclusiveMin: true, inclusiveMax: true));
}

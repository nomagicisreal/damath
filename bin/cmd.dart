import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final list = List.of([1, 2, 1, 6, 2], growable: false);
  print(list..sort());
  print(list.isGrowable);
}

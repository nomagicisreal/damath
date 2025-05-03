// ignore_for_file: unused_import, unused_local_variable, prefer_typing_uninitialized_variables
import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final list = List.generate(10, FKeep.applier);
  final node =
      NodeBinaryAvl<int>.fromSorted(list)
        ..pushThenBalance(3113)
        ..pushThenBalance(313)
        ..pushThenBalance(99913)
        ..pushThenBalance(43113)
        // ..pushThenBalance(53113)
  ;
  print(node);
}

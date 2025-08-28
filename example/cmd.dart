// ignore_for_file: unused_import, unused_local_variable, prefer_typing_uninitialized_variables
import 'dart:math' as math;
import 'dart:collection';
import 'dart:developer';
import 'dart:typed_data';

import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final buffer = StringBuffer();
  // final list = List.generate(10, FKeep.applier);
  // final node =
  //     NodeBinaryAvl<int>.fromSorted(list)
  //       ..push(3113)
  //       ..push(313)
  //       ..push(99913)
  //       ..push(43113)
  //       // ..push(53113)
  // ;
  // print(node);

  // final flags = Slot2D<String>(10, 5);
  final flags = Field3D(10, 5, 2);

  flags[(1, 1, 1)] = true;
  print(flags.toString());
}
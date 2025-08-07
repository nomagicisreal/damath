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

  final list = Uint8List(3);
  list[0] = 1 << 5;
  list[1] = 1 << 3;
  list[2] = 1 << 0;
  print(
    list.iterator
        .reduce((byte0, byte) => (byte0 << 8) | byte)
        .toRadixString(2)
        .padLeft(24, '0')
        .insertEvery(8),
    // (1 << 63).toRadixString(2),
    // list.iterator.joinMapped(
    //   ' ',
    //   (byte) => byte.toRadixString(2).padLeft(8, '0'),
    // ),
  );
}

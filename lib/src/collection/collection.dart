///
/// this library is appendix of 'collection:collection.dart'
///
library;

import 'dart:collection' show SplayTreeMap;
import 'dart:math' as math;
import 'package:collection/collection.dart' as collection;
import 'package:damath/src/custom/custom.dart';
import 'package:damath/src/primary/primary.dart';

part 'primary.dart';
part 'comparable/comparable.dart';
part 'comparable/iterator.dart';
part 'comparable/iterable.dart';
part 'comparable/list.dart';
part 'comparable/map.dart';
part 'iterable/iterator.dart';
part 'iterable/iteratorto.dart';
part 'iterable/itertogether.dart';
part 'iterable/iterable.dart';
part 'iterable/nest.dart';
part 'list/list.dart';
part 'list/nest.dart';
part 'map/map.dart';
part 'map/nest.dart';
part 'map/set.dart';

///
///
/// Notice that iterator is consistent despite of difference reference
/// ```
///   final it = [2, 9, 3, 7, 1, 1, 4, 5];
///   final itA = iterator.take(4);
///   print(itA); // (2, 9, 3, 7)
///   print(itA); // (1, 1, 4, 5)
/// ```
///
/// Notice that iterable comes from iterator only yield once,
/// ```
///   final another = [2, 5, 2, 4, 3].iterator.sub(2, 10);
///   print(another); // (2, 4, 3)
///   print(another); // ()
/// ```
///
/// Notice that instance methods is faster than static
/// ```dart
/// extension IntExt on int {
///   int testing(int appendix) => bitLength + appendix;
///   static int test(int value, int appendix) => value.bitLength + appendix;
/// }
///
/// String way1() {
///   dynamic result = 'finished';
///   for (var i = 1; i < 1e10; i++) {
///     result = 100.testing(100);
///   }
///   return result.toString();
/// }
/// String way2() {
///   dynamic result = 'finished';
///   for (var i = 1; i < 1e10; i++) {
///     result = IntExt.test(100, 100);
///   }
///   return result.toString();
/// }
/// ```
/// 1st test----way 1: 107 in 0:00:05.914239, way 2: 107 in 0:00:05.960277
/// 2nd test----way 1: 107 in 0:00:05.802016, way 2: 107 in 0:00:05.830010
/// 3rd test----way 1: 107 in 0:00:05.839465, way 2: 107 in 0:00:05.903668
///
///
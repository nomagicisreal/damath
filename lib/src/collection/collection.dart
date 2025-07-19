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
/// iterator is consistent despite of difference reference
/// ```
///   final it = [2, 9, 3, 7, 1, 1, 4, 5];
///   final itA = iterator.take(4);
///   print(itA); // (2, 9, 3, 7)
///   print(itA); // (1, 1, 4, 5)
/// ```
///
/// iterable comes from iterator only yield once,
/// ```
///   final another = [2, 5, 2, 4, 3].iterator.sub(2, 10);
///   print(another); // (2, 4, 3)
///   print(another); // ()
/// ```
///
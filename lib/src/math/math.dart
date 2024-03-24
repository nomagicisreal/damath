library damath_math;

import 'dart:math' as math;

part 'iterable/iterable.dart';
part 'iterable/iterator.dart';
part 'iterable/iternum.dart';
part 'iterable/iterwith.dart';
part 'collection/list.dart';
part 'collection/map.dart';
part 'collection/set.dart';
part 'general/core.dart';
part 'general/direction.dart';
part 'general/primary.dart';
part 'general/record.dart';



class DamathException implements Exception {
  final String message;
  DamathException(this.message);

  static const String pass = 'pass';

  @override
  String toString() => 'DamathException: $message';
}

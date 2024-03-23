library damath_experiment;

import 'dart:math' as math hide Point;
import 'package:damath/src/math/math.dart';


part 'definition/_additions.dart';
part 'definition/graph.dart';
part 'definition/proposition.dart';
part 'definition/statistic.dart';
part 'space/tensor.dart';
part 'space/space.dart';
part 'space/direction.dart';
part 'general/core.dart';
part 'general/value.dart';


class DamathException implements Exception {
  final String message;
  DamathException(this.message);

  @override
  String toString() => 'DamathException: $message';
}
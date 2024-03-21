library damath_experiment;

import 'dart:math' as math;
import 'package:damath/damath.dart';
import 'package:damath/src/math/api.dart';


part 'definition/_additions.dart';
part 'definition/graph.dart';
part 'definition/proposition.dart';
part 'definition/statistic.dart';
part 'definition/tensor.dart';
part 'definition/others.dart';
part 'general/core.dart';
part 'general/value.dart';


class DamathException implements Exception {
  final String message;
  DamathException(this.message);

  @override
  String toString() => 'DamathException: $message';
}
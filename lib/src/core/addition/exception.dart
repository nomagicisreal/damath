///
///
/// this file contains:
///
/// [DamathException]
///
///
part of damath_core;

///
/// exceptions
///
class DamathException implements Exception {
  final String message;
  DamathException(this.message);

  static const String pass = 'pass';

  @override
  String toString() => 'DamathException: $message';
}


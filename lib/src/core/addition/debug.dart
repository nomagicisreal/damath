///
///
/// this file contains:
///
///
///
part of damath_core;

///
///
///
extension StateErrorExtension on StateError {
  bool not(String message) => this.message != message;
}
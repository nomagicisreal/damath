// ignore_for_file: unused_import, unused_local_variable, prefer_typing_uninitialized_variables
import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final node =
      NodeBinarySorted.mutable('data')
        ..push('apple')
        ..push('programming')
        ..push('banana')
        ..push('cat')
        ..push('weak')
        ..push('zibra')
        ..push('cool');
  print(node);
}

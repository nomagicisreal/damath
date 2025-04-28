// ignore_for_file: unused_import
import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final node =
      NodeAppendable.mutable('data')
        ..append('hello')
        ..append('tedious')
        ..append('world');
  print(node);
}

abstract class Parent1 {}

abstract class Parent2 extends Parent1 {
  num sayHi() => 2;
}

mixin Hello on Parent1, Parent2 {}

class Child extends Parent2 with Hello {
  Child();

  @override
  int sayHi() => 2;
}

// ignore_for_file: unused_import
import 'package:damath/damath.dart';

void main(List<String> arguments) {
  Child().sayHi();
}

abstract class Parent1 {}

abstract class Parent2 extends Parent1 {}

mixin Hello on Parent1, Parent2 {

}

class Child extends Parent2 with Hello {
  Child();
  void sayHi() => print('object');
}
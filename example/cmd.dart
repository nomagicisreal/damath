// ignore_for_file: unused_import, unused_local_variable
import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final node =
      Qterator.of('data')
        ..enqueueAll([
          'veve',
          'beack',
          'backandAndforce',
        ])
        ..enqueue('world');
  print(node);
  while (node.moveNext()) {
    print(node.toString());
  }
}

abstract final class Parent {}

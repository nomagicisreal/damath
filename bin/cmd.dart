// import 'package:damath/src/core/core.dart';
// import 'package:damath/src/experiment/experiment.dart';
// import 'package:damath/src/math/math.dart';

void main(List<String> arguments) async {
  // watching();

}

void watching() async {
  final watch = Stopwatch();
  print('start');

  watch.start();
  print('way 1: ${way1()} in ${watch.elapsed}');
  watch.reset();

  watch.start();
  print('way 2: ${way2()} in ${watch.elapsed}');
  watch.reset();

  print('end');
}

String way1() {
  for (var i = 1e9; i > 1; i--) {}
  throw UnimplementedError();
  // return hello.toString();
}

String way2() {
  for (var i = 1e9; i > 1; i--) {}
  throw UnimplementedError();
  // return world.toString();
}

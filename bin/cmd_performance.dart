import 'dart:typed_data';

void main() async {
  final watch = Stopwatch();
  print('start');

  // watch.start();
  // print('way 1: ${way1()} in ${watch.elapsed}');
  // watch.reset();


  watch.start();
  print('way 2: ${way2()} in ${watch.elapsed}');
  watch.reset();

  watch.start();
  print('way 3: ${way3()} in ${watch.elapsed}');
  watch.reset();


  print('end');
}

String way1() {
  // var vector = Point3(x, y, dz);
  for (var i = 1e9; i > 1; i--) {
    // vector = (i, i);
  }
  throw UnimplementedError();
  // return vector.toString();
}

String way2() {
  var record = Float32List(2);
  for (var i = 1e9; i > 1; i--) {
    record[0] = i;
    record[1] = i;
  }
  return record.toString();
}

String way3() {
  var record = Float64List(2);
  for (var i = 1e9; i > 1; i--) {
    record[0] = i;
    record[1] = i;
  }
  // throw UnimplementedError();
  return record.toString();
}

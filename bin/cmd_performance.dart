
void main() async {
  final watch = Stopwatch();
  print('start');

  watch.start();
  print('way 1: ${way1()} in ${watch.elapsed}');
  watch.reset();

  watch.start();
  print('way 2: ${way2()} in ${watch.elapsed}');
  watch.reset();

  // watch.start();
  // print('way 3: ${way3()} in ${watch.elapsed}');
  // watch.reset();

  print('end');
}

String way1() {
  Iterable value = [];
  for (var i = 1e8; i > 1; i--) {
    // value = requireIterable();
  }
  // throw UnimplementedError();
  return value.toString();
}

String way2() {
  Iterable value = [];
  for (var i = 1e8; i > 1; i--) {
    // value = requireList();
  }
  return value.toString();
}

String way3() {
  // var record = Float64List(2);
  for (var i = 1e8; i > 1; i--) {
    // record[0] = i;
    // record[1] = i;
  }
  throw UnimplementedError();
  // return record.toString();
}

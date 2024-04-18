import 'package:damath/src/collection/collection.dart';
import 'package:damath/src/typed_data/typed_data.dart';

void main(List<String> arguments) async {
  // var list = RandomExtension.sample(17);
  // print(list);
  // var list = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 100.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0];
  // final result = List.of(list)..sortMerge();
  // print(result);
  // print(list.isVariationTo(result));
  // print(result.iterator.isSorted(true));

  final result = <bool>[];
  for (var i = 0; i < 10; i++) {
    var list = RandomExtension.sample(1e4.toInt());
    list.sortMerge();
    result.add(list.iterator.isSorted(true));
  }
  print(result.iterator.isTautology);

  // var list = [2, 3, 4, 5, 6, 10, 11, 0, 9, 12, 100, 8, 3, 99, 1]..shuffle();
  // print(list);
  // final a0 = list[0];
  // final a1 = list[1];
  // final a2 = list[2];
  // final a3 = list[3];
  // final a4 = list[4];
  // final a5 = list[5];
  // final a6 = list[6];
  // final a7 = list[7];
  // final b8 = list[8];
  // final b9 = list[9];
  // final b10 = list[10];
  // final b11 = list[11];
  // final b12 = list[12];
  // final b13 = list[13];
  // final b14 = list[14];
  // Sort.preemptSorted1ByRecord<int>(
  //   list,
  //   1,
  //   (v1, v2) => v1 < v2,
  //   a2, // insert a4 on a3's position
  //   a1,
  //   Sort.recordBuild7(
  //     a2,
  //     a3,
  //     a4,
  //     a5,
  //     a6,
  //     a7,
  //     b8,
  //   ),
  // );
  // print(list);
}

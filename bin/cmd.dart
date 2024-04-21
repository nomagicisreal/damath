import 'package:damath/src/collection/collection.dart';
import 'package:damath/src/typed_data/typed_data.dart';

void main(List<String> arguments) async {
  final result = <bool>[];

  // var list = RandomExtension.sample(11);
  // print(list);
  // final result = List.of(list)..sortMerge();
  // print(result);
  // print(list.isVariationTo(result));
  // print(result.iterator.isSorted(true));

  for (var i = 0; i < 10; i++) {
    var list = RandomExtension.sample(1e4.toInt());
    final sorted = List.of(list)..sortMerge();
    result.add(sorted.iterator.isSorted(true));
    result.add(list.isVariationTo(sorted));
  }
  print(result.iterator.isTautology);

  // print(IntExtension.partitionSet(5));
}

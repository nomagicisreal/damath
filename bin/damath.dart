// import 'package:damath/damath.dart' as damath;

import 'package:damath/damath.dart';

void main(List<String> arguments) {
  final node = NodeBinary(
    1,
    left: NodeBinary(
      1.1,
      left: NodeBinary(
        1.11,
      ),
      right: NodeBinary(
        1.12,
        left: NodeBinary(
          1.121,
        ),
        right: NodeBinary(
          1.122,
          left: NodeBinary(
            1.1221,
          ),
          right: NodeBinary(
            1.1222,
            right: NodeBinary(
              1.12222,
            ),
          ),
        ),
      ),
    ),
    right: NodeBinary(
      1.2,
    ),
  );
  print(node);
}

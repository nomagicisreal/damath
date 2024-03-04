library damath_flutter;

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'damath.dart';
export 'util.dart' hide DamathException;

part 'src_flutter/function.dart';
part 'src_flutter/definition.dart';
part 'src_flutter/extension.dart';
part 'src_flutter/value.dart';

///
///
///
///
/// [Extruding2D]
/// [TextFormFieldValidator]
///
/// [SizingPath], [SizingOffset], ...
/// [PaintFrom], [PaintingPath], [Painter]
/// [RectBuilder]
///
///
///
///
///

typedef Extruding2D = Rect Function(double width, double height);

typedef TextFormFieldValidator = FormFieldValidator<String> Function(
  String failedMessage,
);



///
///
/// sizing
///
///
typedef Sizing = Size Function(Size size);
typedef SizingDouble = double Function(Size size);
typedef SizingOffset = Offset Function(Size size);
typedef SizingRect = Rect Function(Size size);
typedef SizingPath = Path Function(Size size);
typedef SizingPathFrom<T> = SizingPath Function(T value);
typedef SizingOffsetIterable = Iterable<Offset> Function(Size size);
typedef SizingOffsetList = List<Offset> Function(Size size);
typedef SizingCubicOffsetIterable = Iterable<CubicOffset> Function(Size size);

///
/// painting
///
typedef PaintFrom = Paint Function(Canvas canvas, Size size);
typedef PaintingPath = void Function(Canvas canvas, Paint paint, Path path);
typedef Painter = Painting Function(SizingPath sizingPath);

///
/// rect
///
typedef RectBuilder = Rect Function(BuildContext context);

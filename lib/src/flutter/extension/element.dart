///
/// this file contains:
///
/// [ColorExtension]
///
/// [FBoxShadow]
/// [FBorderSide], [FBorderBox], [FBorderOutlined], [FBorderInput]
/// [FDecorationBox], [FDecorationShape], [FDecorationInput]
///
///
///
///
///
part of damath_flutter;

///
///
/// color
///
/// [plusARGB], [minusARGB], [multiplyARGB], [divideARGB],
/// [plusAllRGB], [minusAllRGB], [multiplyAllRGB], [divideAllRGB],
///
extension ColorExtension on Color {
  Color plusARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha + alpha,
    this.red + red,
    this.green + green,
    this.blue + blue,
  );

  Color minusARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha - alpha,
    this.red - red,
    this.green - green,
    this.blue - blue,
  );

  Color multiplyARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha * alpha,
    this.red * red,
    this.green * green,
    this.blue * blue,
  );

  Color divideARGB(int alpha, int red, int green, int blue) => Color.fromARGB(
    this.alpha ~/ alpha,
    this.red ~/ red,
    this.green ~/ green,
    this.blue ~/ blue,
  );

  Color plusAllRGB(int value) =>
      Color.fromARGB(alpha, red + value, green + value, blue + value);

  Color minusAllRGB(int value) =>
      Color.fromARGB(alpha, red - value, green - value, blue - value);

  Color multiplyAllRGB(int value) =>
      Color.fromARGB(alpha, red * value, green * value, blue * value);

  Color divideAllRGB(int value) =>
      Color.fromARGB(alpha, red ~/ value, green ~/ value, blue ~/ value);
}


///
///
/// [FBoxShadow]
///   [FBoxShadow.blurNormal]
///   [FBoxShadow.blurSolid]
///   [FBoxShadow.blurOuter]
///   [FBoxShadow.blurInner]
///
///
extension FBoxShadow on BoxShadow {
  static BoxShadow blurNormal({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.normal,
      );

  static BoxShadow blurSolid({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.solid,
      );

  static BoxShadow blurOuter({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.outer,
      );

  static BoxShadow blurInner({
    Color color = Colors.white,
    Offset offset = Offset.zero,
    double spreadRadius = 0.0,
    double blurRadius = 0.0,
  }) =>
      BoxShadow(
        color: color,
        offset: offset,
        spreadRadius: spreadRadius,
        blurRadius: blurRadius,
        blurStyle: BlurStyle.inner,
      );
}

///
///
///
///
///
/// [FBorderSide]
///   [FBorderSide.solidInside]
///   [FBorderSide.solidCenter]
///   [FBorderSide.solidOutside]
///
///
/// [FBorderBox]
///   [FBorderBox.sideSolidCenter]
///   [FBorderBox.directionalSideSolidCenter]
///
/// [FBorderOutlined]
///   [FBorderOutlined.star]
///   [FBorderOutlined.linear]
///   [FBorderOutlined.stadium]
///   [FBorderOutlined.beveledRectangle]
///   [FBorderOutlined.roundedRectangle]
///   [FBorderOutlined.continuousRectangle]
///   [FBorderOutlined.circle]
///   [FBorderOutlined.oval]
///
/// [FBorderInput]
///   [FBorderInput.outline]
///   [FBorderInput.outlineSolidInside]
///   [FBorderInput.underline]
///
/// see https://api.flutter.dev/flutter/painting/ShapeBorder-class.html for more detail about [ShapeBorder]
/// [FBorderOutlined.linear] usually used with [ButtonStyle.shape] by invoking [TextButton.styleFrom]
///
///
///
///
///

// border side
extension FBorderSide on BorderSide {
  static BorderSide solidInside({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignInside,
      );

  static BorderSide solidCenter({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignCenter,
      );

  static BorderSide solidOutside({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      BorderSide(
        color: color,
        width: width,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignOutside,
      );
}

// box border
extension FBorderBox on BoxBorder {
  static Border sideSolidCenter({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) =>
      Border.fromBorderSide(
        FBorderSide.solidCenter(color: color, width: width),
      );

  static BorderDirectional directionalSideSolidCenter({
    Color color = Colors.blueGrey,
    double width = 1.5,
  }) {
    final side = FBorderSide.solidCenter(color: color, width: width);
    return BorderDirectional(top: side, start: side, end: side, bottom: side);
  }
}

// outlined border
extension FBorderOutlined on OutlinedBorder {
  static StarBorder star({
    BorderSide side = BorderSide.none,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) =>
      StarBorder(
        side: side,
        points: points,
        innerRadiusRatio: innerRadiusRatio,
        pointRounding: pointRounding,
        valleyRounding: valleyRounding,
        rotation: rotation,
        squash: squash,
      );

  static LinearBorder linear({
    BorderSide side = BorderSide.none,
    LinearBorderEdge? start,
    LinearBorderEdge? end,
    LinearBorderEdge? top,
    LinearBorderEdge? bottom,
  }) =>
      LinearBorder(
        side: side,
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      );

  static StadiumBorder stadium([BorderSide side = BorderSide.none]) =>
      StadiumBorder(side: side);

  static BeveledRectangleBorder beveledRectangle({
    BorderSide side = BorderSide.none,
    required BorderRadius borderRadius,
  }) =>
      BeveledRectangleBorder(
        side: side,
        borderRadius: borderRadius,
      );

  static RoundedRectangleBorder roundedRectangle({
    BorderSide side = BorderSide.none,
    required BorderRadius borderRadius,
  }) =>
      RoundedRectangleBorder(
        side: side,
        borderRadius: borderRadius,
      );

  static ContinuousRectangleBorder continuousRectangle({
    BorderSide side = BorderSide.none,
    required BorderRadius borderRadius,
  }) =>
      ContinuousRectangleBorder(side: side, borderRadius: borderRadius);

  static CircleBorder circle({
    BorderSide side = BorderSide.none,
    double eccentricity = 0.0,
  }) =>
      CircleBorder(side: side, eccentricity: eccentricity);

  static CircleBorder oval({
    BorderSide side = BorderSide.none,
    double eccentricity = 1.0,
  }) =>
      OvalBorder(side: side, eccentricity: eccentricity);
}

// input border
extension FBorderInput on InputBorder {
  static OutlineInputBorder outline({
    BorderSide borderSide = const BorderSide(),
    double gapPadding = 4.0,
    required BorderRadius borderRadius,
  }) =>
      OutlineInputBorder(
        borderSide: borderSide,
        borderRadius: borderRadius,
        gapPadding: gapPadding,
      );

  static OutlineInputBorder outlineSolidInside({
    Color color = Colors.blueGrey,
    double width = 1.5,
    double gapPadding = 4.0,
    required BorderRadius borderRadius,
  }) =>
      OutlineInputBorder(
        borderSide: FBorderSide.solidInside(
          color: color,
          width: width,
        ),
        borderRadius: borderRadius,
        gapPadding: gapPadding,
      );

  static UnderlineInputBorder underline({
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = KBorderRadius.top_4,
  }) =>
      UnderlineInputBorder(
        borderSide: borderSide,
        borderRadius: borderRadius,
      );
}

///
///
///
///
///
///
///
///
///
/// [FDecorationBox]
///   [FDecorationBox.rectangle]
///   [FDecorationBox.circle]
///
/// [FDecorationShape]
///   [FDecorationShape.stadiumBorder]
///   [FDecorationShape.outlineInputBorder]
///
/// [FDecorationInput]
///   [FDecorationInput.rowLabelIconText]
///   [FDecorationInput.style1]
///
///
///
///
///
///
///
///

// box decoration
extension FDecorationBox on BoxDecoration {
  static BoxDecoration rectangle(
      {Color? color,
        DecorationImage? image,
        Border? border,
        BorderRadiusGeometry? borderRadius,
        List<BoxShadow>? boxShadow,
        BlendMode? backgroundBlendMode}) =>
      BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        backgroundBlendMode: backgroundBlendMode,
        shape: BoxShape.rectangle,
      );

  static BoxDecoration circle({
    Color? color,
    DecorationImage? image,
    Border? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    BlendMode? backgroundBlendMode,
  }) =>
      BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        backgroundBlendMode: backgroundBlendMode,
        shape: BoxShape.circle,
      );
}

// shape decoration
extension FDecorationShape on ShapeDecoration {
  static ShapeDecoration stadiumBorder({
    required BorderSide side,
    Color? color,
    DecorationImage? image,
    List<BoxShadow>? shadows,
    Gradient? gradient,
  }) =>
      ShapeDecoration(
        shape: StadiumBorder(side: side),
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      );

  static ShapeDecoration outlineInputBorder({
    required BorderSide side,
    Color? color,
    DecorationImage? image,
    List<BoxShadow>? shadows,
    Gradient? gradient,
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = KBorderRadius.allCircular_4,
    double gapPadding = 4.0,
  }) =>
      ShapeDecoration(
        shape: OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: borderRadius,
          gapPadding: gapPadding,
        ),
        color: color,
        image: image,
        gradient: gradient,
        shadows: shadows,
      );
}

// input decoration
extension FDecorationInput on InputDecoration {
  static InputDecoration rowLabelIconText({
    InputBorder? border,
    required Icon icon,
    required Text text,
  }) =>
      InputDecoration(
        alignLabelWithHint: true,
        border: border,
        contentPadding: switch (border) {
          null => EdgeInsets.zero,
          _ => throw UnimplementedError(),
        },
        label: Row(children: [icon, text]),
      );

  static InputDecoration style1({
    required InputBorder enabledBorder,
  }) =>
      InputDecoration(
        labelStyle: TextStyle(color: Colors.blueGrey),
        enabledBorder: enabledBorder,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          borderRadius: KBorderRadius.allCircular_10,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: KBorderRadius.allCircular_10,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: KBorderRadius.allCircular_10,
        ),
      );
}

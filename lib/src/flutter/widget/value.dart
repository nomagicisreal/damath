///
///
/// this file contains:
///
/// stateful widget:
/// [WProgressIndicator]
/// [WImage]
///
/// stateless widget:
/// [WDrawer]
/// [WListView]
/// [WIcon], [WIconMaterial], [WIconMaterialWhite]
/// [WGridPaper]
/// [WSpacer], [WDivider]
///
/// render object widget:
/// [WSizedBox]
/// [WColoredBox]
/// [WTransform]
/// [WCustomPaint], [WClipPath]
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
part of damath_flutter;

///
///
///
///
///
/// stateful widget
///
///
///
///
///

///
///
///
extension WProgressIndicator on ProgressIndicator {
  static const circular = CircularProgressIndicator();
  static const circularBlueGrey = CircularProgressIndicator(
    color: Colors.blueGrey,
  );
  static const linear = LinearProgressIndicator();
  static const refresh = RefreshProgressIndicator();
}

extension WImage on Image {
  static assetsInDimension(
    String path,
    double dimension, {
    Alignment alignment = Alignment.center,
    FilterQuality filterQuality = FilterQuality.medium,
  }) =>
      Image.asset(
        path,
        height: dimension,
        width: dimension,
        alignment: alignment,
        filterQuality: filterQuality,
      );
}

///
///
///
///
///
/// stateless widget
///
///
///
///
///
///

///
///
///
extension WDrawer on Drawer {
  static const none = Drawer();
}

///
///
///
extension WListView on ListView {
  static ListView get fakeBigSmall_25 => ListView.builder(
        padding: KEdgeInsets.vertical * 8,
        itemCount: 25,
        itemBuilder: (context, index) => Container(
          margin: KEdgeInsets.horizontal * 24 + KEdgeInsets.vertical * 8,
          height: index.isOdd ? 128 : 36,
          decoration: BoxDecoration(
            borderRadius: KBorderRadius.circularAll * 8,
            color: Colors.grey.shade600,
          ),
        ),
      );
}

///
///
///
// extension WIcon on Icon {
//   static IconData iconDataOf(Latex operator) => switch (operator) {
//     Latex.plus => Icons.add,
//     Latex.minus => Icons.remove,
//     Latex.multiply => CupertinoIcons.multiply,
//     Latex.divided => CupertinoIcons.divided,
//     Latex.modulus => CupertinoIcons.percent,
//   };
// }

///
///
///
extension WIconMaterial on Icon {
  static const check = Icon(Icons.check);
  static const close = Icon(Icons.close);

  static const add = Icon(Icons.add);
  static const minus = Icon(Icons.remove);
  static const plus = add;
  static const cross = close;
  static const multiple = cross;
  static const questionMark = Icon(Icons.question_mark);

  static const play = Icon(Icons.play_arrow);
  static const pause = Icon(Icons.pause);
  static const stop = Icon(Icons.stop);
  static const create = Icon(Icons.create);
  static const edit = Icon(Icons.edit);
  static const delete = Icon(Icons.delete);
  static const cancel_24 = Icon(Icons.cancel, size: 24);
  static const cancelSharp = Icon(Icons.cancel_sharp);
  static const send = Icon(Icons.send);

  static const arrowRight = Icon(Icons.arrow_forward_ios);
  static const arrowLeft = Icon(Icons.arrow_back_ios);
  static const arrowRightward = Icon(Icons.arrow_forward);
  static const arrowLeftward = Icon(Icons.arrow_back);
  static const chevronLeft = Icon(Icons.chevron_left);
  static const chevronRight = Icon(Icons.chevron_right);

  static const accountBox = Icon(Icons.account_box);
  static const accountCircle = Icon(Icons.account_circle);
  static const backspace = Icon(Icons.backspace);
  static const email = Icon(Icons.email);
  static const mailOutline = Icon(Icons.mail_outline);
  static const password = Icon(Icons.password);
  static const phone = Icon(Icons.phone);
  static const photo = Icon(Icons.photo);
  static const photo_28 = Icon(Icons.photo, size: 28);
  static const readMore = Icon(Icons.read_more);
  static const calendarToday = Icon(Icons.calendar_today);

  static const accountCircleStyle1 = Icon(
    Icons.account_circle,
    size: 90,
    color: Colors.grey,
  );
  static const accountCircleStyle2 = Icon(
    Icons.account_circle,
    size: 35,
    color: Colors.grey,
  );
}

extension WIconMaterialWhite on Icon {
  static const add = Icon(Icons.add, color: Colors.white);
}

extension WGridPaper on GridPaper {
  static const none = GridPaper();
  static const simple =
      GridPaper(color: Colors.white, interval: 100, subdivisions: 1);

  static const simpleList = <GridPaper>[simple, simple, simple];

  static const simpleListList = <List<GridPaper>>[
    <GridPaper>[simple, simple, simple],
    <GridPaper>[simple, simple, simple]
  ];
}

extension WSpacer on Spacer {
  static const Spacer none = Spacer();
}

extension WDivider on Divider {
  static const white = Divider(color: Colors.white);
  static const black_3 = Divider(thickness: 3);
}

///
///
///
///
/// render object widgets
///
///
///
///

extension WSizedBox on SizedBox {
  static const none = SizedBox();
  static const shrink = SizedBox.shrink();
  static const expand = SizedBox.expand();

  ///
  ///
  /// height, width, square
  ///
  ///
  static SizedBox height(double dimension, {Widget? child}) =>
      SizedBox(height: dimension, child: child);

  static SizedBox width(double dimension, {Widget? child}) =>
      SizedBox(width: dimension, child: child);

  static SizedBox squareColored({
    required double dimension,
    Color? color,
    Widget? child,
  }) =>
      SizedBox.square(
        dimension: dimension,
        child: ColoredBox(
          color: color ?? VRandomMaterial.colorPrimary,
          child: child,
        ),
      );

  ///
  /// expand
  ///
  static SizedBox expandWidth(double height, {Widget? child}) =>
      SizedBox(height: height, width: double.infinity);

  static SizedBox expandHeight(double width, {Widget? child}) =>
      SizedBox(height: double.infinity, width: width);

  static SizedBox expandColored(Color color) =>
      SizedBox.expand(child: ColoredBox(color: color));

  static SizedBox expandCenter({required Widget child}) =>
      SizedBox.expand(child: Center(child: child));

  static SizedBox expandCenterColored({
    required Color color,
    Widget? child,
  }) =>
      SizedBox.expand(
        child: Center(child: ColoredBox(color: color, child: child)),
      );
}

extension WColoredBox on ColoredBox {
  static const ColoredBox white = ColoredBox(color: Colors.white);
  static const ColoredBox red = ColoredBox(color: Colors.red);
  static const ColoredBox orange = ColoredBox(color: Colors.orange);
  static const ColoredBox yellow = ColoredBox(color: Colors.yellow);
  static const ColoredBox green = ColoredBox(color: Colors.green);
  static const ColoredBox blue = ColoredBox(color: Colors.blue);
  static const ColoredBox blueAccent = ColoredBox(color: Colors.blueAccent);
  static const ColoredBox purple = ColoredBox(color: Colors.purple);
}

extension WTransform on Transform {
  static Transform transformFromDirection(
    Direction3DIn6 direction, {
    Point3 initialRadian = Point3.zero,
    double zDeep = 100,
    required Widget child,
  }) {
    Matrix4 instance() => Matrix4.identity();
    return initialRadian == Point3.zero
        ? switch (direction) {
            Direction3DIn6.front => Transform(
                transform: instance(),
                alignment: Alignment.center,
                child: child,
              ),
            Direction3DIn6.back => Transform(
                alignment: Alignment.center,
                transform: instance()..translateOf(Point3.ofZ(-zDeep)),
                child: child,
              ),
            Direction3DIn6.left => Transform(
                alignment: Alignment.centerLeft,
                transform: instance()..rotateY(Radian.angle_90),
                child: child,
              ),
            Direction3DIn6.right => Transform(
                alignment: Alignment.centerRight,
                transform: instance()..rotateY(-Radian.angle_90),
                child: child,
              ),
            Direction3DIn6.top => Transform(
                alignment: Alignment.topCenter,
                transform: instance()..rotateX(-Radian.angle_90),
                child: child,
              ),
            Direction3DIn6.bottom => Transform(
                alignment: Alignment.bottomCenter,
                transform: instance()..rotateX(Radian.angle_90),
                child: child,
              ),
          }
        : throw UnimplementedError();
  }
}

///
///
///
/// painting
///
///
///
extension WCustomPaint on CustomPaint {
  static CustomPaint repaintNever({
    PaintingPath paintingPath = FPaintingPath.draw,
    required PaintFrom paintFrom,
    required SizingPath sizingPath,
  }) =>
      CustomPaint(
        painter: Painting.rePaintNever(
          paintingPath: paintingPath,
          paintFrom: paintFrom,
          sizingPath: sizingPath,
        ),
      );

  static CustomPaint repaintWhenUpdate({
    PaintingPath paintingPath = FPaintingPath.draw,
    required PaintFrom paintFrom,
    required SizingPath sizingPath,
  }) =>
      CustomPaint(
        painter: Painting.rePaintWhenUpdate(
          paintingPath: paintingPath,
          paintFrom: paintFrom,
          sizingPath: sizingPath,
        ),
      );

  ///
  ///
  ///
  static CustomPaint drawRRegularPolygon(
    RRegularPolygonCubicOnEdge polygon, {
    required PaintFrom pathFrom,
    Widget? child,
  }) =>
      CustomPaint(
        painter: Painting.rRegularPolygon(pathFrom, polygon),
        child: child,
      );
}

///
///
/// [WClipPath._shape]
///   [WClipPath.shapeCircle]
///   [WClipPath.shapeOval]
///   [WClipPath.shapeStar]
///   [WClipPath.shapeStadium]
///   [WClipPath.shapeBeveledRectangle]
///   [WClipPath.shapeRoundedRectangle]
///   [WClipPath.shapeContinuousRectangle]
///
/// [WClipPath.rRectColored]
///
/// [WClipPath.reClipNever]
/// [WClipPath.rectFromZeroToSize]
/// [WClipPath.polygonRRegular]
/// [WClipPath.pathPolygonRRegularDecoratedBox]
///
///
/// there is no [BorderSide] when using [ShapeBorderClipper], See Also the comment above [FBorderSide]
///
///
extension WClipPath on ClipPath {
  static Widget shapeCircle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    double eccentricity = 0.0,
  }) =>
      ClipPath.shape(
        key: key,
        shape: CircleBorder(side: BorderSide.none, eccentricity: eccentricity),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeOval({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    double eccentricity = 1.0,
  }) =>
      ClipPath.shape(
        key: key,
        shape: OvalBorder(side: BorderSide.none, eccentricity: eccentricity),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeStar({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    double points = 5,
    double innerRadiusRatio = 0.4,
    double pointRounding = 0,
    double valleyRounding = 0,
    double rotation = 0,
    double squash = 0,
  }) =>
      ClipPath.shape(
        key: key,
        shape: StarBorder(
          side: BorderSide.none,
          points: points,
          innerRadiusRatio: innerRadiusRatio,
          pointRounding: pointRounding,
          valleyRounding: valleyRounding,
          rotation: rotation,
          squash: squash,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeStadium({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
  }) =>
      ClipPath.shape(
        key: key,
        shape: const StadiumBorder(side: BorderSide.none),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeBeveledRectangle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    required BorderRadius borderRadius,
  }) =>
      ClipPath.shape(
        key: key,
        shape: BeveledRectangleBorder(
          side: BorderSide.none,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeRoundedRectangle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    required BorderRadius borderRadius,
  }) =>
      ClipPath.shape(
        key: key,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  static Widget shapeContinuousRectangle({
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    required BorderRadius borderRadius,
  }) =>
      ClipPath.shape(
        key: key,
        shape: ContinuousRectangleBorder(
          side: BorderSide.none,
          borderRadius: borderRadius,
        ),
        clipBehavior: clipBehavior,
        child: child,
      );

  ///
  ///
  /// with build-in clipper
  ///
  ///
  ///
  static ClipRRect rRectColored({
    required BorderRadius borderRadius,
    required Color color,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
  }) =>
      ClipRRect(
        clipper: clipper,
        clipBehavior: clipBehavior,
        borderRadius: borderRadius,
        child: ColoredBox(color: color, child: child),
      );

  ///
  ///
  ///
  /// with [Clipping]
  ///
  ///
  ///
  static ClipPath reClipNever({
    Clip clipBehavior = Clip.antiAlias,
    required SizingPath sizingPath,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(sizingPath),
        child: child,
      );

  static ClipPath rectFromZeroToSize({
    Clip clipBehavior = Clip.antiAlias,
    required Size size,
    required Widget child,
  }) =>
      ClipPath(
        clipBehavior: clipBehavior,
        clipper: Clipping.rectOf(Offset.zero & size),
        child: child,
      );

  static ClipPath polygonRRegular(
    RRegularPolygonCubicOnEdge polygon, {
    Key? key,
    Clip clipBehavior = Clip.antiAlias,
    Widget? child,
    Companion<CubicOffset, Size> adjust = CubicOffset.companionSizeAdjustCenter,
  }) =>
      ClipPath(
        key: key,
        clipBehavior: clipBehavior,
        clipper: Clipping.reclipNever(
          FSizingPath.polygonCubic(polygon.cubicPoints, adjust: adjust),
        ),
        child: child,
      );

  static ClipPath pathPolygonRRegularDecoratedBox(
    Decoration decoration,
    RRegularPolygonCubicOnEdge polygon, {
    DecorationPosition position = DecorationPosition.background,
    Widget? child,
  }) =>
      ClipPath(
        clipper: Clipping.rRegularPolygon(polygon),
        child: DecoratedBox(
          decoration: decoration,
          position: position,
          child: child,
        ),
      );
}

///
///
/// this file contains:
/// [KColor]
///
/// [KSize]
/// [KSize2Ratio3]
/// [KSize3Ratio4]
/// [KSize9Ratio16]
///
/// [KOffset],
/// [KOffsetPermutation4], [KMapperCubicPointsPermutation]
///
/// [KRadius], [KBorderRadius]
/// [KEdgeInsets]
/// [KInterval]
///
/// [KMaskFilter]
///
///
/// [VPaintFill], [VPaintStroke]
/// [VThemeData]
/// [VRandomMaterial]
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
// ignore_for_file: non_constant_identifier_names, constant_identifier_names

///
///
///
extension KColor on Color {
  ///
  ///
  ///
  /// 20 distinct colors, https://sashamaps.net/docs/resources/20-colors/
  ///
  ///
  ///

  //
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFa9a9a9);
  static const Color white = Color(0xFFffffff);

  //
  static const Color purple = Color(0xFF9111b4);
  static const Color lavender = Color(0xFFdcbeff);
  static const Color magenta = Color(0xFFf032e6);

  //
  static const Color navy = Color(0xFF000075);
  static const Color blue = Color(0xFF4363d8);

  //
  static const Color teal = Color(0xFF469990);
  static const Color cyan = Color(0xFF42d4f4);

  //
  static const Color lime = Color(0xFFbfef45);
  static const Color green = Color(0xFF3cb44b);
  static const Color mint = Color(0xFFaaffc3);

  //
  static const Color olive = Color(0xFF808000);
  static const Color yellow = Color(0xFFffe119);
  static const Color beige = Color(0xFFfffac8);

  //
  static const Color brown = Color(0xFF9a6324);
  static const Color orange = Color(0xFFf58231);
  static const Color apricot = Color(0xFFffd8b1);

  //
  static const Color maroon = Color(0xFF800000);
  static const Color red = Color(0xFFe6194b);
  static const Color pink = Color(0xFFfabed4);
}

///
///
///
///
/// geometry
///
///
///
///
///

extension KSize on Size {
  static const square_1 = Size.square(1);
  static const square_10 = Size.square(10);
  static const square_20 = Size.square(20);
  static const square_30 = Size.square(30);
  static const square_40 = Size.square(40);
  static const square_50 = Size.square(50);
  static const square_56 = Size.square(56);
  static const square_60 = Size.square(60);
  static const square_70 = Size.square(70);
  static const square_80 = Size.square(80);
  static const square_90 = Size.square(90);
  static const square_100 = Size.square(100);
  static const square_110 = Size.square(110);
  static const square_120 = Size.square(120);
  static const square_130 = Size.square(130);
  static const square_140 = Size.square(140);
  static const square_150 = Size.square(150);
  static const square_160 = Size.square(160);
  static const square_170 = Size.square(170);
  static const square_180 = Size.square(180);
  static const square_190 = Size.square(190);
  static const square_200 = Size.square(200);
  static const square_210 = Size.square(210);
  static const square_220 = Size.square(220);
  static const square_230 = Size.square(230);
  static const square_240 = Size.square(240);
  static const square_250 = Size.square(250);
  static const square_260 = Size.square(260);
  static const square_270 = Size.square(270);
  static const square_280 = Size.square(280);
  static const square_290 = Size.square(290);
  static const square_300 = Size.square(300);

  // in cm
  static const a4 = Size(21.0, 29.7);
  static const a3 = Size(29.7, 42.0);
  static const a2 = Size(42.0, 59.4);
  static const a1 = Size(59.4, 84.1);
}

extension KSize2Ratio3 on Size {
  static const w360_h540 = Size(360, 540);
  static const w420_h630 = Size(420, 630);
  static const w480_h720 = Size(480, 720);
}

extension KSize3Ratio4 on Size {
  static Size get w360_h480 => Size(360, 480);

  static Size get w420_h560 => Size(420, 560);

  static Size get w480_h640 => Size(480, 640);
}

extension KSize9Ratio16 on Size {
  static Size get w270_h480 => Size(270, 480);

  static Size get w405_h720 => Size(405, 720);

  static Size get w450_h800 => Size(450, 800);
}

///
///
///
/// offset, point3, vector
///
///
///

///
/// [top], ..., [bottomRight]
/// [square_1], [square_10], [square_100]
/// [x_1], [x_10], [x_100]
/// [y_1], [y_10], [y_100]
///
extension KOffset on Offset {
  static const top = Offset(0, -1);
  static const left = Offset(-1, 0);
  static const right = Offset(1, 0);
  static const bottom = Offset(0, 1);
  static const center = Offset.zero;
  static const topLeft = Offset(-math.sqrt1_2, -math.sqrt1_2);
  static const topRight = Offset(math.sqrt1_2, -math.sqrt1_2);
  static const bottomLeft = Offset(-math.sqrt1_2, math.sqrt1_2);
  static const bottomRight = Offset(math.sqrt1_2, math.sqrt1_2);

  static const square_1 = Offset(1, 1);
  static const square_10 = Offset(10, 10);
  static const square_100 = Offset(100, 100);
  static const x_1 = Offset(1, 0);
  static const x_10 = Offset(10, 0);
  static const x_100 = Offset(100, 0);
  static const y_1 = Offset(0, 1);
  static const y_10 = Offset(0, 10);
  static const y_100 = Offset(0, 100);
}

extension KOffsetPermutation4 on List<Offset> {
  // 0, 1, 2, 3
  // 1, 2, 3, a (add a, remove a)
  // 2, 3, a, b
  // 3, a, 1, c
  static List<Offset> p0123(List<Offset> list) => list;

  static List<Offset> p1230(List<Offset> list) => list..cloneSwitch();

  static List<Offset> p2301(List<Offset> list) => p1230(list)..cloneSwitch();

  static List<Offset> p3012(List<Offset> list) => p2301(list)..cloneSwitch();

  // a, 2, 3, b (add 1, remove b)
  // 2, 3, 1, a
  // 3, 1, a, c
  // 1, a, 2, d
  static List<Offset> p0231(List<Offset> list) => list
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p2310(List<Offset> list) => p0231(list)..cloneSwitch();

  static List<Offset> p3102(List<Offset> list) => p2310(list)..cloneSwitch();

  static List<Offset> p1023(List<Offset> list) => p3102(list)..cloneSwitch();

  // 0, 1, 3, 2 (add 2, remove 2)
  // 1, 3, 2, 0
  // 3, 2, 0, 1
  // 2, 0, 1, 3
  static List<Offset> p0132(List<Offset> list) => list
    ..add(list[2])
    ..removeAt(2);

  static List<Offset> p1320(List<Offset> list) => p0132(list)..cloneSwitch();

  static List<Offset> p3201(List<Offset> list) => p1320(list)..cloneSwitch();

  static List<Offset> p2013(List<Offset> list) => p3201(list)..cloneSwitch();

  // 1, 3, 0, 2 (add 02, remove 02)
  // 3, 0, 2, 1
  // 0, 2, 1, 3
  // 2, 1, 3, 0
  static List<Offset> p1302(List<Offset> list) => p1230(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3021(List<Offset> list) => p1302(list)..cloneSwitch();

  static List<Offset> p0213(List<Offset> list) => p3021(list)..cloneSwitch();

  static List<Offset> p2130(List<Offset> list) => p0213(list)..cloneSwitch();

  // 0, 3, 1, 2 (add 12, remove 12)
  // 3, 1, 2, 0
  // 1, 2, 0, 3
  // 2, 0, 3, 1
  static List<Offset> p0312(List<Offset> list) => p0231(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3120(List<Offset> list) => p0312(list)..cloneSwitch();

  static List<Offset> p1203(List<Offset> list) => p3120(list)..cloneSwitch();

  static List<Offset> p2031(List<Offset> list) => p1203(list)..cloneSwitch();

  // 0, 3, 2, 1 (add 21, remove 21)
  // 3, 2, 1, 0
  // 2, 1, 0, 3
  // 1, 0, 3, 2
  static List<Offset> p0321(List<Offset> list) => p0132(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3210(List<Offset> list) => p0321(list)..cloneSwitch();

  static List<Offset> p2103(List<Offset> list) => p3210(list)..cloneSwitch();

  static List<Offset> p1032(List<Offset> list) => p2103(list)..cloneSwitch();
}

extension KMapperCubicPointsPermutation on Applier<Map<Offset, List<Offset>>> {
  static const Applier<Map<Offset, List<Offset>>> p0231 = _0231;
  static const Applier<Map<Offset, List<Offset>>> p1230 = _1230;

  static Map<Offset, List<Offset>> _0231(Map<Offset, List<Offset>> points) =>
      points.map(
        (points, cubicPoints) => MapEntry(
          points,
          KOffsetPermutation4.p0231(cubicPoints),
        ),
      );

  static Map<Offset, List<Offset>> _1230(Map<Offset, List<Offset>> points) =>
      points.map(
        (points, cubicPoints) => MapEntry(
          points,
          KOffsetPermutation4.p1230(cubicPoints),
        ),
      );

  static Applier<Map<Offset, List<Offset>>> of(Applier<List<Offset>> mapping) =>
      (points) => points
          .map((points, cubicPoints) => MapEntry(points, mapping(cubicPoints)));
}

///
///
///
///
///
///
/// radius, border radius
///
///
///
///
///
///

extension KRadius on Radius {
  static const circular = Radius.circular(1);
}

extension KBorderRadius on BorderRadius {
  static const zero = BorderRadius.all(Radius.zero);
  static const circularAll = BorderRadius.all(KRadius.circular);
  static const circularTopLeft = BorderRadius.only(topLeft: KRadius.circular);
  static const circularTopRight = BorderRadius.only(topRight: KRadius.circular);
  static const circularBottomLeft =
      BorderRadius.only(bottomLeft: KRadius.circular);
  static const circularBottomRight =
      BorderRadius.only(bottomRight: KRadius.circular);
  static const circularLeft = BorderRadius.horizontal(left: KRadius.circular);
  static const circularTop = BorderRadius.vertical(top: KRadius.circular);
  static const circularRight = BorderRadius.horizontal(right: KRadius.circular);
  static const circularBottom = BorderRadius.vertical(bottom: KRadius.circular);
}

extension KEdgeInsets on EdgeInsets {
  static const leftBottom = EdgeInsets.only(left: 1, bottom: 1);
  static const left = EdgeInsets.only(left: 1);
  static const leftTop = EdgeInsets.only(left: 1, top: 1);
  static const top = EdgeInsets.only(top: 1);
  static const rightTop = EdgeInsets.only(right: 1, top: 1);
  static const right = EdgeInsets.only(right: 1);
  static const rightBottom = EdgeInsets.only(right: 1, bottom: 1);
  static const bottom = EdgeInsets.only(bottom: 1);
  static const horizontal = EdgeInsets.symmetric(horizontal: 1);
  static const vertical = EdgeInsets.symmetric(vertical: 1);
  static const all = EdgeInsets.all(1);
}

///
///
///
/// curve, interval
///
///
///

extension KInterval on Interval {
  static const easeInOut_00_04 = Interval(0, 0.4, curve: Curves.easeInOut);
  static const easeInOut_00_05 = Interval(0, 0.5, curve: Curves.easeInOut);
  static const easeOut_00_06 = Interval(0, 0.6, curve: Curves.easeOut);
  static const easeInOut_02_08 = Interval(0.2, 0.8, curve: Curves.easeInOut);
  static const easeInOut_04_10 = Interval(0.4, 1, curve: Curves.easeInOut);
  static const fastOutSlowIn_00_05 =
      Interval(0, 0.5, curve: Curves.fastOutSlowIn);
}

///
///
///
/// mask filter
///
///
///

extension KMaskFilter on Paint {
  /// normal
  static const MaskFilter normal_05 = MaskFilter.blur(BlurStyle.normal, 0.5);
  static const MaskFilter normal_1 = MaskFilter.blur(BlurStyle.normal, 1);
  static const MaskFilter normal_2 = MaskFilter.blur(BlurStyle.normal, 2);
  static const MaskFilter normal_3 = MaskFilter.blur(BlurStyle.normal, 3);
  static const MaskFilter normal_4 = MaskFilter.blur(BlurStyle.normal, 4);
  static const MaskFilter normal_5 = MaskFilter.blur(BlurStyle.normal, 5);
  static const MaskFilter normal_6 = MaskFilter.blur(BlurStyle.normal, 6);
  static const MaskFilter normal_7 = MaskFilter.blur(BlurStyle.normal, 7);
  static const MaskFilter normal_8 = MaskFilter.blur(BlurStyle.normal, 8);
  static const MaskFilter normal_9 = MaskFilter.blur(BlurStyle.normal, 9);
  static const MaskFilter normal_10 = MaskFilter.blur(BlurStyle.normal, 10);

  /// solid
  static const MaskFilter solid_05 = MaskFilter.blur(BlurStyle.solid, 0.5);
}

///
///
///
///
/// value
///
///
///
///

//
extension VPaintFill on Paint {
  static Paint get _fill => Paint()..style = PaintingStyle.fill;

  ///
  /// blur
  ///
  static Paint get blurNormal_05 => _fill..maskFilter = KMaskFilter.normal_05;

  static Paint get blurNormal_1 => _fill..maskFilter = KMaskFilter.normal_1;

  static Paint get blurNormal_2 => _fill..maskFilter = KMaskFilter.normal_2;

  static Paint get blurNormal_3 => _fill..maskFilter = KMaskFilter.normal_3;

  static Paint get blurNormal_4 => _fill..maskFilter = KMaskFilter.normal_4;

  static Paint get blurNormal_5 => _fill..maskFilter = KMaskFilter.normal_5;
}

//
extension VPaintStroke on Paint {
  static Paint get _stroke => Paint()..style = PaintingStyle.stroke;

  static Paint get capRound => _stroke..strokeCap = StrokeCap.round;

  static Paint get capSquare => _stroke..strokeCap = StrokeCap.square;

  static Paint get capButt => _stroke..strokeCap = StrokeCap.butt;
}

///
///
///
/// theme
///
///
///

extension VThemeData on ThemeData {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      );

  static ThemeData get style1 {
    const primaryBrown = Color.fromARGB(255, 189, 166, 158);
    const secondaryBrown = Color.fromARGB(255, 109, 92, 90);
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryBrown,
      primarySwatch: Colors.brown,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBrown,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primaryBrown,
        selectedItemColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryBrown,
        elevation: 10,
      ),
      textTheme: const TextTheme(
          // headlineSmall, Medium, Large, 1-6:
          // bodySmall, Medium, Large, 1-3:
          ),
    );
  }
}

///
/// [colorPrimary], ...
/// [fabLocation]
///
extension VRandomMaterial on Material {
  ///
  /// material
  ///
  static Color get colorPrimary => Colors.primaries[RandomExtension.intTo(18)];

  static final List<FloatingActionButtonLocation> _fabLocations = [
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endTop,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endContained,
  ];

  static FloatingActionButtonLocation get fabLocation =>
      _fabLocations[RandomExtension.intTo(10)];
}

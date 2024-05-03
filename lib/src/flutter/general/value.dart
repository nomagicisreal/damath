///
///
/// this file contains:
/// [KColor]
/// [KTextStyle]
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


extension KColor on Color {
  /// R
  static const redB1 = Color(0xFFffdddd);
  static const redB2 = Color(0xFFeecccc);
  static const redB3 = Color(0xFFdd9999);
  static const redPrimary = Color(0xFFdd7777);
  static const redD3 = Color(0xFFbb4444);
  static const redD2 = Color(0xFFaa1111);
  static const redD1 = Color(0xFF880000);

  /// G
  static const greenB1 = Color(0xFFddffdd);
  static const greenB2 = Color(0xFFcceecc);
  static const greenB3 = Color(0xFFaaddaa);
  static const greenPrimary = Color(0xFF88aa88);
  static const greenD3 = Color(0xFF559955);
  static const greenD2 = Color(0xFF227722);
  static const greenD1 = Color(0xFF005500);

  /// B
  static const blueB1 = Color(0xFFddddff);
  static const blueB2 = Color(0xFFbbbbee);
  static const blueB3 = Color(0xFF8888dd);
  static const bluePrimary = Color(0xFF6666cc);
  static const blueD3 = Color(0xFF4444bb);
  static const blueD2 = Color(0xFF222288);
  static const blueD1 = Color(0xFF111155);

  /// oranges that G over B oranges
  static const orangeB1 = Color(0xFFffeecc);
  static const orangeB2 = Color(0xFFffccaa);
  static const orangeB3 = Color(0xFFeeaa88);
  static const orangePrimary = Color(0xFFcc8866);
  static const orangeD3 = Color(0xFFaa5533);
  static const orangeD2 = Color(0xFF773322);
  static const orangeD1 = Color(0xFF551100);

  /// yellows that R over G
  static const yellowB1 = Color(0xFFffffbb);
  static const yellowB1_1 = Color(0xFFeeeeaa);
  static const yellowB2 = Color(0xFFeedd99);
  static const yellowB3 = Color(0xFFddcc66);
  static const yellowPrimary = Color(0xffccbb22);
  static const yellowD3 = Color(0xFFccbb33);
  static const yellowD2 = Color(0xFFbbaa22);
  static const yellowD1 = Color(0xFF998811);

  /// purples that B over R
  static const purpleB1 = Color(0xFFeeccff);
  static const purpleB2 = Color(0xFFddbbee);
  static const purpleB3 = Color(0xFFaa88dd);
  static const purpleB4 = Color(0xFF9977cc);
  static const purplePrimary = Color(0xff8866cc);
  static const purpleD3 = Color(0xFF8844bb);
  static const purpleD2 = Color(0xFF6622aa);
  static const purpleD1 = Color(0xFF440099);

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
/// [KTextStyle]
///
///
///

extension KTextStyle on TextStyle {
  static const size_10 = TextStyle(fontSize: 10);
  static const size_20 = TextStyle(fontSize: 20);
  static const size_30 = TextStyle(fontSize: 30);
  static const size_40 = TextStyle(fontSize: 40);
  static const size_50 = TextStyle(fontSize: 50);
  static const white = TextStyle(color: Colors.white);
  static const black = TextStyle(color: Colors.black);
  static const black12 = TextStyle(color: Colors.black12);
  static const black26 = TextStyle(color: Colors.black26);
  static const black38 = TextStyle(color: Colors.black38);
  static const black45 = TextStyle(color: Colors.black45);
  static const black54 = TextStyle(color: Colors.black54);
  static const black87 = TextStyle(color: Colors.black87);

  static const white_24 = TextStyle(color: Colors.white, fontSize: 24);
  static const white_28 = TextStyle(color: Colors.white, fontSize: 28);
  static const boldWhite = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const boldBlack = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const boldBlack_30 = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontSize: 30,
  );

  static const italicGrey_12 = TextStyle(
    fontStyle: FontStyle.italic,
    color: Colors.grey,
    fontSize: 12,
  );
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
/// offset, space3, vector
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

  static List<Offset> p1230(List<Offset> list) =>
      list..cloneSwitch();

  static List<Offset> p2301(List<Offset> list) =>
      p1230(list)..cloneSwitch();

  static List<Offset> p3012(List<Offset> list) =>
      p2301(list)..cloneSwitch();

  // a, 2, 3, b (add 1, remove b)
  // 2, 3, 1, a
  // 3, 1, a, c
  // 1, a, 2, d
  static List<Offset> p0231(List<Offset> list) => list
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p2310(List<Offset> list) =>
      p0231(list)..cloneSwitch();

  static List<Offset> p3102(List<Offset> list) =>
      p2310(list)..cloneSwitch();

  static List<Offset> p1023(List<Offset> list) =>
      p3102(list)..cloneSwitch();

  // 0, 1, 3, 2 (add 2, remove 2)
  // 1, 3, 2, 0
  // 3, 2, 0, 1
  // 2, 0, 1, 3
  static List<Offset> p0132(List<Offset> list) => list
    ..add(list[2])
    ..removeAt(2);

  static List<Offset> p1320(List<Offset> list) =>
      p0132(list)..cloneSwitch();

  static List<Offset> p3201(List<Offset> list) =>
      p1320(list)..cloneSwitch();

  static List<Offset> p2013(List<Offset> list) =>
      p3201(list)..cloneSwitch();

  // 1, 3, 0, 2 (add 02, remove 02)
  // 3, 0, 2, 1
  // 0, 2, 1, 3
  // 2, 1, 3, 0
  static List<Offset> p1302(List<Offset> list) => p1230(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3021(List<Offset> list) =>
      p1302(list)..cloneSwitch();

  static List<Offset> p0213(List<Offset> list) =>
      p3021(list)..cloneSwitch();

  static List<Offset> p2130(List<Offset> list) =>
      p0213(list)..cloneSwitch();

  // 0, 3, 1, 2 (add 12, remove 12)
  // 3, 1, 2, 0
  // 1, 2, 0, 3
  // 2, 0, 3, 1
  static List<Offset> p0312(List<Offset> list) => p0231(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3120(List<Offset> list) =>
      p0312(list)..cloneSwitch();

  static List<Offset> p1203(List<Offset> list) =>
      p3120(list)..cloneSwitch();

  static List<Offset> p2031(List<Offset> list) =>
      p1203(list)..cloneSwitch();

  // 0, 3, 2, 1 (add 21, remove 21)
  // 3, 2, 1, 0
  // 2, 1, 0, 3
  // 1, 0, 3, 2
  static List<Offset> p0321(List<Offset> list) => p0132(list)
    ..add(list[1])
    ..removeAt(1);

  static List<Offset> p3210(List<Offset> list) =>
      p0321(list)..cloneSwitch();

  static List<Offset> p2103(List<Offset> list) =>
      p3210(list)..cloneSwitch();

  static List<Offset> p1032(List<Offset> list) =>
      p2103(list)..cloneSwitch();
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
  static const circular1 = Radius.circular(1);
  static const circular2 = Radius.circular(2);
  static const circular3 = Radius.circular(3);
  static const circular4 = Radius.circular(4);
  static const circular5 = Radius.circular(5);
  static const circular6 = Radius.circular(6);
  static const circular7 = Radius.circular(7);
  static const circular8 = Radius.circular(8);
  static const circular9 = Radius.circular(9);
  static const circular10 = Radius.circular(10);
  static const circular100 = Radius.circular(100);
}

extension KBorderRadius on BorderRadius {
  static const zero = BorderRadius.all(Radius.zero);
  static const allCircular_1 = BorderRadius.all(KRadius.circular1);
  static const allCircular_2 = BorderRadius.all(KRadius.circular2);
  static const allCircular_3 = BorderRadius.all(KRadius.circular3);
  static const allCircular_4 = BorderRadius.all(KRadius.circular4);
  static const allCircular_5 = BorderRadius.all(KRadius.circular5);
  static const allCircular_6 = BorderRadius.all(KRadius.circular6);
  static const allCircular_7 = BorderRadius.all(KRadius.circular7);
  static const allCircular_8 = BorderRadius.all(KRadius.circular8);
  static const allCircular_9 = BorderRadius.all(KRadius.circular9);
  static const allCircular_10 = BorderRadius.all(KRadius.circular10);
  static const allCircular_100 = BorderRadius.all(KRadius.circular100);
  static const bottom_10 = BorderRadius.vertical(bottom: KRadius.circular10);
  static const top_4 = BorderRadius.vertical(top: Radius.circular(4.0));
}

extension KEdgeInsets on EdgeInsets {
  static const onlyLeft_4 = EdgeInsets.only(left: 4);
  static const onlyLeft_8 = EdgeInsets.only(left: 8);
  static const onlyLeft_10 = EdgeInsets.only(left: 10);
  static const onlyLeft_24 = EdgeInsets.only(left: 24);
  static const onlyLeftTop_10 = EdgeInsets.only(left: 10, top: 10);
  static const onlyTop_4 = EdgeInsets.only(top: 4);
  static const onlyTop_8 = EdgeInsets.only(top: 8);
  static const onlyTop_12 = EdgeInsets.only(top: 12);
  static const onlyTop_16 = EdgeInsets.only(top: 16);
  static const onlyTop_32 = EdgeInsets.only(top: 32);
  static const onlyTop_10 = EdgeInsets.only(top: 10);
  static const onlyTop_20 = EdgeInsets.only(top: 20);
  static const onlyTop_30 = EdgeInsets.only(top: 30);
  static const onlyTop_40 = EdgeInsets.only(top: 40);
  static const onlyTop_50 = EdgeInsets.only(top: 50);
  static const onlyBottom_8 = EdgeInsets.only(bottom: 8);
  static const onlyBottom_16 = EdgeInsets.only(bottom: 16);
  static const onlyBottom_32 = EdgeInsets.only(bottom: 32);
  static const onlyBottom_64 = EdgeInsets.only(bottom: 64);
  static const onlyRight_4 = EdgeInsets.only(right: 4);
  static const onlyRight_8 = EdgeInsets.only(right: 8);
  static const onlyRight_10 = EdgeInsets.only(right: 10);
  static const onlyRightTop_10 = EdgeInsets.only(right: 10, top: 10);

  static const symH_8 = EdgeInsets.symmetric(horizontal: 8);
  static const symH_10 = EdgeInsets.symmetric(horizontal: 10);
  static const symH_12 = EdgeInsets.symmetric(horizontal: 12);
  static const symH_16 = EdgeInsets.symmetric(horizontal: 16);
  static const symH_18 = EdgeInsets.symmetric(horizontal: 18);
  static const symH_20 = EdgeInsets.symmetric(horizontal: 20);
  static const symH_32 = EdgeInsets.symmetric(horizontal: 32);
  static const symH_64 = EdgeInsets.symmetric(horizontal: 64);
  static const symV_8 = EdgeInsets.symmetric(vertical: 8);
  static const symV_16 = EdgeInsets.symmetric(vertical: 16);
  static const symV_32 = EdgeInsets.symmetric(vertical: 32);
  static const symV_10 = EdgeInsets.symmetric(vertical: 10);
  static const symV_20 = EdgeInsets.symmetric(vertical: 20);
  static const symV_30 = EdgeInsets.symmetric(vertical: 30);

  static const symHV_64_32 = EdgeInsets.symmetric(horizontal: 64, vertical: 32);
  static const symHV_32_4 = EdgeInsets.symmetric(horizontal: 32, vertical: 4);
  static const symHV_24_8 = EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  static const all_1 = EdgeInsets.all(1);
  static const all_2 = EdgeInsets.all(2);
  static const all_3 = EdgeInsets.all(3);
  static const all_4 = EdgeInsets.all(4);
  static const all_5 = EdgeInsets.all(5);
  static const all_6 = EdgeInsets.all(6);
  static const all_7 = EdgeInsets.all(7);
  static const all_8 = EdgeInsets.all(8);
  static const all_9 = EdgeInsets.all(9);
  static const all_10 = EdgeInsets.all(10);
  static const all_100 = EdgeInsets.all(100);

  static const ltrb_2_16_2_0 = EdgeInsets.fromLTRB(2, 16, 2, 0);
  static const ltrb_2_0_2_8 = EdgeInsets.fromLTRB(2, 0, 2, 8);
  static const ltrb_4_16_4_0 = EdgeInsets.fromLTRB(4, 16, 4, 0);
  static const ltrb_8_0_8_8 = EdgeInsets.fromLTRB(8, 0, 8, 8);
  static const ltrb_8_0_8_20 = EdgeInsets.fromLTRB(8, 0, 8, 20);
  static const ltrb_8_16_8_0 = EdgeInsets.fromLTRB(8, 16, 8, 0);
  static const ltrb_16_20_16_16 = EdgeInsets.fromLTRB(64, 20, 64, 8);
  static const ltrb_32_20_32_8 = EdgeInsets.fromLTRB(32, 20, 32, 8);
  static const ltrb_64_20_64_8 = EdgeInsets.fromLTRB(64, 20, 64, 8);
  static const ltrb_50_6_0_8 = EdgeInsets.fromLTRB(50, 6, 0, 8);
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


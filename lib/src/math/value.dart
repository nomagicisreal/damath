///
///
/// this file contains:
///
/// [KDuration]
///
/// [KLaTexString], [KLatexStringEquation], [KLatexStringMatrix1N], [KLatexStringMatrix2N], [FLaTexString]
/// [VRandom]
///
///
///
///
///
part of damath_math;

///
/// duration
///
extension KDuration on Duration {
  static const milli5 = Duration(milliseconds: 5);
  static const milli10 = Duration(milliseconds: 10);
  static const milli20 = Duration(milliseconds: 20);
  static const milli30 = Duration(milliseconds: 30);
  static const milli40 = Duration(milliseconds: 40);
  static const milli50 = Duration(milliseconds: 50);
  static const milli60 = Duration(milliseconds: 60);
  static const milli70 = Duration(milliseconds: 70);
  static const milli80 = Duration(milliseconds: 80);
  static const milli90 = Duration(milliseconds: 90);
  static const milli100 = Duration(milliseconds: 100);
  static const milli110 = Duration(milliseconds: 110);
  static const milli120 = Duration(milliseconds: 120);
  static const milli130 = Duration(milliseconds: 130);
  static const milli140 = Duration(milliseconds: 140);
  static const milli150 = Duration(milliseconds: 150);
  static const milli160 = Duration(milliseconds: 160);
  static const milli170 = Duration(milliseconds: 170);
  static const milli180 = Duration(milliseconds: 180);
  static const milli190 = Duration(milliseconds: 190);
  static const milli200 = Duration(milliseconds: 200);
  static const milli210 = Duration(milliseconds: 210);
  static const milli220 = Duration(milliseconds: 220);
  static const milli230 = Duration(milliseconds: 230);
  static const milli240 = Duration(milliseconds: 240);
  static const milli250 = Duration(milliseconds: 250);
  static const milli260 = Duration(milliseconds: 260);
  static const milli270 = Duration(milliseconds: 270);
  static const milli280 = Duration(milliseconds: 280);
  static const milli290 = Duration(milliseconds: 290);
  static const milli295 = Duration(milliseconds: 295);
  static const milli300 = Duration(milliseconds: 300);
  static const milli306 = Duration(milliseconds: 306);
  static const milli307 = Duration(milliseconds: 307);
  static const milli308 = Duration(milliseconds: 308);
  static const milli310 = Duration(milliseconds: 310);
  static const milli320 = Duration(milliseconds: 320);
  static const milli330 = Duration(milliseconds: 330);
  static const milli335 = Duration(milliseconds: 335);
  static const milli340 = Duration(milliseconds: 340);
  static const milli350 = Duration(milliseconds: 350);
  static const milli360 = Duration(milliseconds: 360);
  static const milli370 = Duration(milliseconds: 370);
  static const milli380 = Duration(milliseconds: 380);
  static const milli390 = Duration(milliseconds: 390);
  static const milli400 = Duration(milliseconds: 400);
  static const milli410 = Duration(milliseconds: 410);
  static const milli420 = Duration(milliseconds: 420);
  static const milli430 = Duration(milliseconds: 430);
  static const milli440 = Duration(milliseconds: 440);
  static const milli450 = Duration(milliseconds: 450);
  static const milli460 = Duration(milliseconds: 460);
  static const milli466 = Duration(milliseconds: 466);
  static const milli467 = Duration(milliseconds: 467);
  static const milli468 = Duration(milliseconds: 468);
  static const milli470 = Duration(milliseconds: 470);
  static const milli480 = Duration(milliseconds: 480);
  static const milli490 = Duration(milliseconds: 490);
  static const milli500 = Duration(milliseconds: 500);
  static const milli600 = Duration(milliseconds: 600);
  static const milli700 = Duration(milliseconds: 700);
  static const milli800 = Duration(milliseconds: 800);
  static const milli810 = Duration(milliseconds: 810);
  static const milli820 = Duration(milliseconds: 820);
  static const milli830 = Duration(milliseconds: 830);
  static const milli840 = Duration(milliseconds: 840);
  static const milli850 = Duration(milliseconds: 850);
  static const milli860 = Duration(milliseconds: 860);
  static const milli870 = Duration(milliseconds: 870);
  static const milli880 = Duration(milliseconds: 880);
  static const milli890 = Duration(milliseconds: 890);
  static const milli900 = Duration(milliseconds: 900);
  static const milli910 = Duration(milliseconds: 910);
  static const milli920 = Duration(milliseconds: 920);
  static const milli930 = Duration(milliseconds: 930);
  static const milli940 = Duration(milliseconds: 940);
  static const milli950 = Duration(milliseconds: 950);
  static const milli960 = Duration(milliseconds: 960);
  static const milli970 = Duration(milliseconds: 970);
  static const milli980 = Duration(milliseconds: 980);
  static const milli990 = Duration(milliseconds: 990);
  static const milli1100 = Duration(milliseconds: 1100);
  static const milli1200 = Duration(milliseconds: 1200);
  static const milli1300 = Duration(milliseconds: 1300);
  static const milli1400 = Duration(milliseconds: 1400);
  static const milli1500 = Duration(milliseconds: 1500);
  static const milli1600 = Duration(milliseconds: 1600);
  static const milli1700 = Duration(milliseconds: 1700);
  static const milli1800 = Duration(milliseconds: 1800);
  static const milli1900 = Duration(milliseconds: 1900);
  static const milli1933 = Duration(milliseconds: 1933);
  static const milli1934 = Duration(milliseconds: 1934);
  static const milli1936 = Duration(milliseconds: 1936);
  static const milli1940 = Duration(milliseconds: 1940);
  static const milli1950 = Duration(milliseconds: 1950);
  static const milli2100 = Duration(milliseconds: 2100);
  static const milli2200 = Duration(milliseconds: 2200);
  static const milli2300 = Duration(milliseconds: 2300);
  static const milli2400 = Duration(milliseconds: 2400);
  static const milli2500 = Duration(milliseconds: 2500);
  static const milli2600 = Duration(milliseconds: 2600);
  static const milli2700 = Duration(milliseconds: 2700);
  static const milli2800 = Duration(milliseconds: 2800);
  static const milli2900 = Duration(milliseconds: 2900);
  static const milli3800 = Duration(milliseconds: 3800);
  static const milli3822 = Duration(milliseconds: 3822);
  static const milli3833 = Duration(milliseconds: 3833);
  static const milli3866 = Duration(milliseconds: 3866);
  static const milli4500 = Duration(milliseconds: 4500);
  static const second1 = Duration(seconds: 1);
  static const second2 = Duration(seconds: 2);
  static const second3 = Duration(seconds: 3);
  static const second4 = Duration(seconds: 4);
  static const second5 = Duration(seconds: 5);
  static const second6 = Duration(seconds: 6);
  static const second7 = Duration(seconds: 7);
  static const second8 = Duration(seconds: 8);
  static const second9 = Duration(seconds: 9);
  static const second10 = Duration(seconds: 10);
  static const second14 = Duration(seconds: 14);
  static const second15 = Duration(seconds: 15);
  static const second20 = Duration(seconds: 20);
  static const second30 = Duration(seconds: 30);
  static const second40 = Duration(seconds: 40);
  static const second50 = Duration(seconds: 50);
  static const second58 = Duration(seconds: 58);
  static const min1 = Duration(minutes: 1);
}

///
///
///
///
/// latex string
///
///
///
///

extension KLaTexString on String {
  static const quadraticRoots = r"{-b \pm \sqrt{b^2-4ac} \over 2a}";
  static const sn = r"S_n";
  static const x1_ = r"x_1 + x_2 + ... + x_n";
  static const x1_3 = r"x_1 + x_2 + x_3";
  static const x1_4 = r"x_1 + x_2 + x_3 + x_4";
  static const x1_5 = r"x_1 + x_2 + x_3 + x_4 + x_5";
  static const ax1_ = r"a_1x_1 + a_2x_2 + ... + a_nx_n";
  static const ax1_3 = r"a_1x_1 + a_2x_2 + a_3x_3";
  static const ax1_4 = r"a_1x_1 + a_2x_2 + a_3x_3 + a_4x_4";
  static const ax1_5 = r"a_1x_1 + a_2x_2 + a_3x_3 + a_4x_4 + a_5x_5";
}

extension KLatexStringEquation on String {
  static const quadraticRootsOfX = r"x = " + KLaTexString.quadraticRoots;
  static const yLinearABX = r"y = a + bx";
  static const yLinearMXK = r"y = mx + k";
}

extension KLatexStringMatrix1N on String {
  static const y1_ = r"""\begin{bmatrix}
  y_1\\
  y_2\\
  ...\\
  y_n\\
  \end{bmatrix}""";
}

extension KLatexStringMatrix2N on String {
  static const const1_x1_ = r"""\begin{bmatrix}
  1&x_1\\
  1&x_2\\
  ...&...\\
  1&x_n\\
  \end{bmatrix}""";
}

extension FLaTexString on String {
  static String equationOf(Iterable<String> values) => values.reduce(
        (a, b) => "$a = $b",
      );
}

///
/// random
///
extension VRandom on math.Random {
  static bool get binary => math.Random().nextBool();

  static double get doubleIn1 => math.Random().nextDouble();

  static int intTo(int max) => math.Random().nextInt(max);

  static double doubleTo(int max, [double factor = 0.1]) =>
      math.Random().nextInt(max) * factor;
}

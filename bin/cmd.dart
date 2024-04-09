// import 'package:damath/src/core/core.dart';
// import 'package:damath/src/experiment/experiment.dart';
// import 'package:damath/src/math/math.dart';

import 'package:damath/src/core/core.dart';
import 'package:damath/src/custom/experiment/experiment.dart';
// import 'package:damath/src/custom/structure/structure.dart';
// import 'package:damath/src/math/math.dart';

void main(List<String> arguments) async {
  /// p0:           0,               5,
  /// p1:           2,               3,
  /// p2:           4,               4,
  /// p3:           6,               2,
  print(ProcessUnitList([
    ProcessUnit(Future.value(''), Duration.zero, KCore.durationSecond5),
    ProcessUnit(Future.value(''), KCore.durationSecond2, KCore.durationSecond3),
    ProcessUnit(Future.value(''), KCore.durationSecond4, KCore.durationSecond4),
    ProcessUnit(Future.value(''), KCore.durationSecond6, KCore.durationSecond2),
  ]).completionTimesOf(ProcessSchedule.shortestJob));

  /// p0:           0,              10,
  /// p1:           2,               6,
  /// p2:           4,               1,
  /// p3:           6,               2,
  ///
  ///       completion time
  /// time.......0.............2.............4........5.............6........8.........11.........19
  /// c0:  arrive, 10-2=8      ,      -      ,   -    ,             ,   -    ,         , 11+8= 19#
  /// c1:        , arrive & 6<8,  6-2=4      ,     4<8,  4-1=3      ,     3<8, 8+3= 11#
  /// c2:        ,             , arrive & 1<4, 4+1= 5#
  /// c3:        ,             ,             ,        , arrive & 2<3, 6+2= 8#

  // print(ProcessUnitList([
  //   ProcessUnit(Future.value(''), Duration.zero, KCore.durationSecond10),
  //   ProcessUnit(Future.value(''), KCore.durationSecond2, KCore.durationSecond6),
  //   ProcessUnit(Future.value(''), KCore.durationSecond4, KCore.durationSecond1),
  //   ProcessUnit(Future.value(''), KCore.durationSecond6, KCore.durationSecond2),
  // ]).completionTimesOf(ProcessSchedule.preemptiveByArrival));


  // final queue = QueteratorCompared.increase(['b', 'be', 'aa', 'z', 'c']);
  // print(queue..insert('eel'));
  // print(queue..insert('eel')..insert('vv')..insert('mamx'));
}

///
///
/// this file contains:
///
///
///
///
part of damath_experiment;

///
///
/// [process], ...(variables)
/// [minBurst], ...(static methods)
/// [compareTo], ...(methods)
///
///
class ProcessUnit<P> implements Comparable<ProcessUnit> {
  final Future<P> process;
  final Duration arrival; // from start
  final Duration burst;

  ProcessUnit(this.process, this.arrival, this.burst);

  ///
  /// static methods
  ///
  static ProcessUnit<P> minBurst<P>(ProcessUnit<P> a, ProcessUnit<P> b) =>
      a.burst < b.burst ? a : b;

  static ProcessUnit<P> maxBurst<P>(ProcessUnit<P> a, ProcessUnit<P> b) =>
      a.burst > b.burst ? a : b;

  ///
  /// methods
  ///
  @override
  int compareTo(ProcessUnit other) => arrival.compareTo(other.arrival);

  // turnaround time
  Duration turnaroundOf(Duration completion) => completion - arrival;

  // waiting time
  Duration waitingOf(Duration completion) => completion - arrival - burst;
}

///
/// [sequence]
/// [shortestJob]
/// [shortestRemain]
/// [roundRobin]
///
enum ProcessSchedule {
  ///
  /// Sequence (First Come First Served / non-Preemptive):
  ///
  /// for example, these are the process units:
  ///     arrival time,  burst time
  /// p0:           0,               6,
  /// p1:           3,               6,
  /// p2:           7,               1,
  /// p3:           9,               3,
  /// ------------------------------------
  ///
  ///       completion time
  /// c0:                6
  /// c1:       6 + 6 = 12
  /// c2:      12 + 1 = 13
  /// c3:      13 + 3 = 16
  ///
  ///       turnaround time
  /// t0:                6
  /// t1:       12 - 3 = 9
  /// t2:       13 - 7 = 5
  /// t3:       16 - 9 = 7
  ///
  ///          waiting time
  /// w0:                0
  /// w1:        9 - 6 = 3
  /// w2:        5 - 1 = 4
  /// w3:        7 - 3 = 4
  ///
  sequence,
  shortestJob,
  shortestRemain,
  roundRobin;

  Mapper<ProcessUnit, Duration> get mapperCompletion {
    var completion = Duration.zero;
    return switch (this) {
      ProcessSchedule.sequence => (unit) => unit.arrival > completion
          ? completion = unit.arrival + unit.burst
          : completion += unit.burst,
      ProcessSchedule.shortestJob => throw UnimplementedError(),
      ProcessSchedule.shortestRemain => throw UnimplementedError(),
      ProcessSchedule.roundRobin => throw UnimplementedError(),
    };
  }
}

///
///
/// [_list], ...
/// [ProcessUnitList.copy], ...
/// [minBurst], ...
/// [completionTimesOf], ...
///
///
class ProcessUnitList<P> extends Operatable
    with OperatableIndexable<ProcessUnit<P>> {
  ///
  /// [_list] must be sorted by arrival times to make sure algorithms (some getters, methods) are valid.
  ///
  @override
  final List<ProcessUnit<P>> _list;

  ///
  /// constructors
  ///
  ProcessUnitList(List<ProcessUnit<P>> units) : _list = units..sort();

  ProcessUnitList.copy(List<ProcessUnit<P>> units) : _list = units.copySorted();

  ///
  /// static methods
  ///
  static MapEntry<int, ProcessUnit<P>> minBurst<P>(
    MapEntry<int, ProcessUnit<P>> a,
    MapEntry<int, ProcessUnit<P>> b,
  ) =>
      a.value.burst < b.value.burst ? a : b;

  static MapEntry<int, ProcessUnit<P>> maxBurst<P>(
    MapEntry<int, ProcessUnit<P>> a,
    MapEntry<int, ProcessUnit<P>> b,
  ) =>
      a.value.burst > b.value.burst ? a : b;

  ///
  /// methods
  ///

  ///
  /// [completionTimesOf], [turnaroundTimesOf], [waitingTimesOf]
  ///
  List<Duration> completionTimesOf(ProcessSchedule schedule) =>
      _list.iterator.mapToList(schedule.mapperCompletion);

  List<Duration> turnaroundTimesOf(ProcessSchedule schedule) {
    final completion = schedule.mapperCompletion;
    return _list.iterator.mapToList((p) => p.turnaroundOf(completion(p)));
  }

  List<Duration> waitingTimesOf(ProcessSchedule schedule) {
    var completion = schedule.mapperCompletion;
    return _list.iterator.mapToList((p) => p.waitingOf(completion(p)));
  }

  ///
  ///
  List<Duration> get completionTimesShortestJob {
    // final result = <MapEntry<int, Duration>>[];
    // var completion = Duration.zero;
    //
    // var index = 0;
    // final current = _list[index];
    //
    // final entry = _list
    //     .sublist(index + 1)
    //     .iterator
    //     .takeUntil((value) {
    //       index++;
    //       return value.arrival > current.arrival;
    //     })
    //     .iterator
    //     .toMap
    //     .reduce(minBurst);
    //
    // result.add(MapEntry(entry.key, completion += entry.value.burst));

    throw UnimplementedError();
  }
}

///
/// Shortest Job first (non-Preemptive):
///
/// process unit:
///     arrival time,  burst time
/// p0:           0,               5,
/// p1:           2,               3,
/// p2:           4,               4,
/// p3:           6,               2,
/// ------------------------------------
///
///       completion time
/// time.......0.............5.............8.........10........14
/// c0:  arrive,            5#
/// c1:        , arrive & 3<4, 5+3= 8#
/// c2:        , arrive      ,      -      ,    -    , 10+4= 14#
/// c3:        ,             , arrive & 2<4, 8+2= 10#
///
///       turnaround time
/// t0:                5
/// t1:        8 - 2 = 6
/// t2:      14 - 4 = 10
/// t3:       10 - 6 = 4
/// avg = (5 + 6 + 10 + 4) / 4 = 25 / 4
///
///          waiting time
/// w0:                0
/// w1:        6 - 3 = 3
/// w2:       10 - 4 = 6
/// w3:        4 - 2 = 2
/// avg = (3 + 6 + 2) / 4 = 11 / 4
///
///
///

///
/// Shortest-Remaining Time First (Preemptive):
///
/// process unit:
///     arrival time,  burst time
/// p0:           0,              10,
/// p1:           2,               6,
/// p2:           4,               1,
/// p3:           6,               2,
/// ------------------------------------
///
///       completion time
/// time.......0.............2.............4........5.............6........8.........11.........19
/// c0:  arrive, 10-2=8      ,      -      ,   -    ,             ,   -    ,         , 11+8= 19#
/// c1:        , arrive & 6<8,  6-2=4      ,     4<8,  4-1=3      ,     3<8, 8+3= 11#
/// c2:        ,             , arrive & 1<4, 4+1= 5#
/// c3:        ,             ,             ,        , arrive & 2<3, 6+2= 8#
///
///       turnaround time
/// t0:               19
/// t1:       11 - 2 = 8
/// t2:        5 - 4 = 1
/// t3:        8 - 6 = 2
/// avg = (19 + 8 + 1 + 2) / 4 = 15 / 2
///
///          waiting time
/// w0:      19 - 10 = 9
/// w1:        8 - 6 = 3
/// w2:        1 - 1 = 0
/// w3:        2 - 2 = 0
/// avg = (9 + 3 + 0 + 0) / 4 = 3
///
///

///
/// Round-robin (Preemptive), time slice = 2
///
/// process unit:
///     arrival time,  burst time
/// p0:           0,              10,
/// p1:           3,               5,
/// p2:           5,               1,
/// p3:           9,               6,
/// ------------------------------------
///
///       completion time
/// time........0.......2.......4.......6.......8.......9......11......13......15......16......18......20......22
/// c0:  arrive, 10-2=8,  8-2=6,   -   ,  6-2=4,   -   ,   -   ,  4-2=2,   -   ,   -   ,16+2= 18#
/// c1:        ,       , arrive,  5-2=3,   -   ,   -   ,  3-2=1,   -   ,   -   ,15+1= 16#
/// c2:        ,       ,       , arrive,   -   , 8+1= 9#
/// c3:        ,       ,       ,       ,       , arrive,   -   ,   -   ,  6-2=4,   -   ,   -   ,  4-2=2,20+2= 22#
/// queue...................1...0...02..21......10......03......31......10......03......3....................
///
///       turnaround time
/// t0:               18
/// t1:      16 - 3 = 13
/// t2:       9 - 5 = 4
/// t3:      22 - 9 = 13
/// avg = (18 + 13 + 4 + 13) / 4 = 12
///
///          waiting time
/// w0:      18 - 10 = 8
/// w1:   16 - 5 - 3 = 8
/// w2:    9 - 1 - 5 = 3
/// w3:   22 - 6 - 9 = 7
/// avg = (8 + 8 + 3 + 7) / 4 = 13 / 2
///
///

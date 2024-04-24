///
///
/// this file contains:
///
/// [ProcessUnitOrdered]
/// [ProcessUnit]
/// [ProcessUnitList]
///
///
///
part of damath_experiment;

typedef ProcessUnitOrdered<P> = (int, ProcessUnit<P>);

extension ProcessUnitOrderedExtension<P> on ProcessUnitOrdered<P> {
  ///
  /// mapping
  ///
  static Countable<Duration> toBurst<P>(ProcessUnitOrdered<P> unit) =>
      (unit.$1, unit.$2.burst);

  static Countable<Duration> toArrival<P>(ProcessUnitOrdered<P> unit) =>
      (unit.$1, unit.$2.arrival);

  ///
  /// reduce
  ///
  static ProcessUnitOrdered<P> minBurst<P>(
    ProcessUnitOrdered<P> a,
    ProcessUnitOrdered<P> b,
  ) =>
      a.$2.burst < b.$2.burst ? a : b;

  static ProcessUnitOrdered<P> maxBurst<P>(
    ProcessUnitOrdered<P> a,
    ProcessUnitOrdered<P> b,
  ) =>
      a.$2.burst > b.$2.burst ? a : b;

  ///
  /// predicator
  ///

  ///
  /// [predicateArrivalOver]
  ///
  static Predicator<ProcessUnitOrdered<P>> predicateArrivalOver<P>(
    Duration completion,
  ) =>
      (p) => completion < p.$2.arrival;

  ///
  /// comparator
  ///

  ///
  /// [compareByOrder]
  /// [compareByArrival]
  /// [compareByBurst]
  ///
  static int compareByOrder<P>(
    ProcessUnitOrdered<P> a,
    ProcessUnitOrdered<P> b,
  ) =>
      a.$1.compareTo(b.$1);

  static int compareByArrival<P>(
    ProcessUnitOrdered<P> a,
    ProcessUnitOrdered<P> b,
  ) =>
      a.$2.arrival.compareTo(b.$2.arrival);

  static int compareByBurst<P>(
    ProcessUnitOrdered<P> a,
    ProcessUnitOrdered<P> b,
  ) =>
      a.$2.burst.compareTo(b.$2.burst);
}

///
///
/// [process], ...(variables)
/// [minBurst], ...(static methods)
///
///
class ProcessUnit<P> {
  ///
  /// properties
  ///
  Duration get completionRightAfterArrival => arrival + burst;

  final Future<P> process;
  final Duration arrival;
  final Duration burst;

  ///
  /// constructor
  ///
  ProcessUnit(this.process, this.arrival, this.burst);

  ///
  ///
  /// static methods
  ///
  ///

  ///
  /// [comparatorArrival]
  /// [comparatorBurst]
  ///
  static int comparatorArrival<P>(
    ProcessUnit<P> a,
    ProcessUnit<P> b,
  ) =>
      a.arrival.compareTo(b.arrival);

  static int comparatorBurst<P>(ProcessUnit<P> a, ProcessUnit<P> b) =>
      a.burst.compareTo(b.burst);

  ///
  /// [minBurst]
  /// [maxBurst]
  ///
  static ProcessUnit<P> minBurst<P>(ProcessUnit<P> a, ProcessUnit<P> b) =>
      a.burst < b.burst ? a : b;

  static ProcessUnit<P> maxBurst<P>(ProcessUnit<P> a, ProcessUnit<P> b) =>
      a.burst > b.burst ? a : b;

  ///
  /// methods
  ///
  Duration turnaroundTime(Duration completion) => completion - arrival;

  Duration waitingTime(Duration completion) => completion - arrival - burst;

  ProcessUnit<P> terminateByArrival(ProcessUnit<P> another) => ProcessUnit(
        process,
        arrival,
        burst - turnaroundTime(another.arrival),
      );

  ProcessUnit<P> copyWith({
    Future<P>? process,
    Duration? arrival,
    Duration? burst,
  }) =>
      ProcessUnit(
        process ?? this.process,
        arrival ?? this.arrival,
        burst ?? this.burst,
      );
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
  shortestJob,

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
  preemptiveByArrival, // preemptiveByDemand ?

  // roundRobin
  ;
}

///
///
/// [_units], ...
/// [completionTimesOf], ...
///
///
class ProcessUnitList<P> implements IOperatableIndexable<ProcessUnit<P>> {
  ///
  /// overrides
  ///
  @override
  ProcessUnit<P> operator [](int i) => _units[i];

  ///
  /// [_units] must be sorted by arrival times to make sure algorithms (some getters, methods) are valid.
  ///
  final List<ProcessUnit<P>> _units;

  ///
  /// constructors
  ///
  ProcessUnitList(
    List<ProcessUnit<P>> units, [
    Comparator<ProcessUnit<P>>? comparator,
  ]) : _units = units;

  ///
  /// methods
  ///
  List<Duration> completionTimesOf(ProcessSchedule schedule) {
    var completion = Duration.zero;
    return switch (schedule) {
      ProcessSchedule.sequence => _units.iterator.mapToList((unit) =>
          unit.arrival > completion
              ? completion = unit.arrival + unit.burst
              : completion += unit.burst),

      ///
      ///
      ///
      ///
      /// p0:           0,               5,
      /// p1:           2,               3,
      /// p2:           4,               4,
      /// p3:           6,               2,
      // print(ProcessUnitList([
      //   ProcessUnit(Future.value(''), Duration.zero, KCore.durationSecond5),
      //   ProcessUnit(Future.value(''), KCore.durationSecond2, KCore.durationSecond3),
      //   ProcessUnit(Future.value(''), KCore.durationSecond4, KCore.durationSecond4),
      //   ProcessUnit(Future.value(''), KCore.durationSecond6, KCore.durationSecond2),
      // ]).completionTimesOf(ProcessSchedule.shortestJob)); // except to be 5, 8, 14, 10
      ProcessSchedule.shortestJob => () {
          final notArrived = Qurator<ProcessUnitOrdered<P>>.increaseExpired(
            _units.iterator.mapToListByIndex(Record2.mixReverse),
            ProcessUnitOrderedExtension.compareByArrival,
          );
          final waited = Qurator<Countable<Duration>>.emptyExpired(
            Record2.compareDurationOn2,
          );
          final completed = Qurator<Countable<Duration>>.emptyExpired(
            Record2.compareNumOn1,
          );

          //
          late final Listener execute;
          void progressOn(Duration time) {
            waited.insertAll(notArrived.mapUntil(
              ProcessUnitOrderedExtension.predicateArrivalOver(time),
              ProcessUnitOrderedExtension.toBurst,
            ));
            if (notArrived.isNotCleared) notArrived.movePrevious();
            if (waited.isEmpty && notArrived.isNotEmpty) execute();
          }

          //
          void progress() {
            if (notArrived.moveNext()) {
              final p0 = notArrived.current;
              waited.insert((p0.$1, p0.$2.burst));
              progressOn(p0.$2.arrival);

              while (waited.moveNext()) {
                completion += waited.current.$2;
                completed.insert((waited.current.$1, completion));
                if (notArrived.isNotEmpty) progressOn(completion);
              }
            }
          }

          execute = progress;

          execute();
          return completed.mapToList((record) => record.$2);
        }(),

      ///
      /// p0:           0,              10,
      /// p1:           2,               6,
      /// p2:           4,               1,
      /// p3:           6,               2,
      // print(ProcessUnitList([
      //   ProcessUnit(Future.value(''), Duration.zero, KCore.durationSecond10),
      //   ProcessUnit(Future.value(''), KCore.durationSecond2, KCore.durationSecond6),
      //   ProcessUnit(Future.value(''), KCore.durationSecond4, KCore.durationSecond1),
      //   ProcessUnit(Future.value(''), KCore.durationSecond6, KCore.durationSecond2),
      // ]).completionTimesOf(ProcessSchedule.preemptiveByArrival)); // except to be 19, 11, 5, 8
      ProcessSchedule.preemptiveByArrival => () {
          throw UnimplementedError();

          // // define waited, not arrived processes
          // final p0 = this[0];
          // final waited = IteratorNodeQueue<ProcessUnitOrdered<P>>(
          //   NodeHead.increaseMutable(MapEntry(0, p0)),
          //   ProcessUnitOrderedExtension.comparatorBurst,
          // );
          // var notArrived = [
          //   for (var i = 1; i < length; i++) MapEntry(i, this[i])
          // ];
          //
          // // prepare for enqueuing processes for each progress
          // void progress(Duration t) {
          //   final iterator = notArrived.iterator;
          //   waited.enqueueAll(iterator.takeUntil(
          //     ProcessUnitOrderedExtension.arrivalLargerThan(t),
          //   ));
          //   notArrived = iterator.takeListRemain;
          // }
          //
          // // get completed process for each timestamp
          // final completed = IteratorNodeQueue<MapEntry<int, Duration>>(
          //   NodeHead.increaseMutableNullable(),
          //   FComparator.entryKeyInt,
          // );
          // void execute(ProcessUnitOrdered<P> process) {
          //   completion += process.$2.burst;
          //   completed.enqueue(MapEntry(process.$1, completion));
          //   if (notArrived.isNotEmpty) progress(completion);
          // }
          //
          // progress(p0.arrival);
          // while (waited.moveNext()) {
          //   final timestamp = completion;
          //   final current = waited.current;
          //   final pC = current.$2;
          //   print(
          //     '${current.$1}, notArrived: ${notArrived.length}, waited: $waited',
          //   );
          //
          //   if (notArrived.isNotEmpty) {
          //     final nextArrival = notArrived.first.$2.arrival;
          //     progress(nextArrival);
          //
          //     if (nextArrival < pC.burst) {
          //       final next = waited.next;
          //
          //       final pN = next.$2;
          //       final remain = pC.burst - pN.arrival + timestamp;
          //       if (pN.burst < remain) {
          //         completion += pN.arrival - timestamp;
          //         waited.enqueue(MapEntry(
          //           current.$1,
          //           pC.copyWith(burst: remain),
          //         ));
          //
          //         print('preempt ${current.$1} by ${next.$1}');
          //         // print('p--waited: $waited\n--completed: $completed');
          //         continue;
          //       }
          //     }
          //   }
          //
          //   // print('@@waited: $waited\n@@completed: $completed');
          //   execute(current);
          //   print('@@@finish ${current.$1}, completed: ${completed}');
          //   print('@@@next ${waited.next.$1}, completed: $completed');
          //   // print('@@waited: $waited\n@@completed: $completed');
          // }
          //
          // return completed.mapToList((value) => value.$2);
        }(),
      // ProcessSchedule.roundRobin => throw UnimplementedError(),
    };
  }
}

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

///
///
/// banker's algorithm
///
/// allocation  A,   B,   C,
///   p0,       0,   1,   0,
///   p1,       2,   0,   0,
///   p2,       3,   0,   2,
///   p3,       2,   1,   1,
///   p4,       0,   0,   2,
///
/// max         A,   B,   C,
///   p0,       7,   5,   3,
///   p1,       3,   2,   2,
///   p2,       9,   0,   2,
///   p3,       2,   2,   2,
///   p4,       4,   3,   3,
///
/// need        A,   B,   C,  (max - allocation)
///   p0,       7,   4,   3,
///   p1,       1,   2,   2,
///   p2,       6,   0,   0,
///   p3,       0,   1,   1,
///   p4,       4,   3,   1,
///
/// available  A(3), B(3), C(2),  + p1 allocation
///     p1   ,    5,    3,    2,  + p3 allocation
///     p3   ,    7,    4,    3,  + p4 allocation
///     p4   ,    7,    4,    5,  + p0 allocation
///     p0   ,    7,    5,    5,  + p2 allocation
///     p2   ,   10,    5,    7,
/// find a safe state on p0, p1, p2, p3, p4,
///
///
/// when there is a requisition, p4 required (3, 3, 0), on resource (3, 3, 2), resource remains (0, 0, 2).
///
/// new allocation will be
///     p0   ,  0,   1,   0,
///     p1   ,  2,   0,   0,
///     p2   ,  3,   0,   2,
///     p3   ,  2,   1,   1,
///     p4   ,0+3, 0+3, 2+0, (3, 3, 2)
///
/// new need will be
///     p0   ,  7,   4,   3,
///     p1   ,  1,   2,   2,
///     p2   ,  6,   0,   0,
///     p3   ,  0,   1,   1,
///     p4   ,4-3, 3-3, 1-0, (1, 0, 1)
///
/// because (0, 0, 2) is not sufficient for the needs in (7, 4, 3), (1, 2, 2), (6, 0, 0), (0, 1, 1),
/// the requisition, p4 required (3, 3, 0), on resource (3, 3, 2), is not safe.
///
///


///
/// peterson's solution
///
/// do {
///   flag[i] = true
///   turn = j
///   while (flag[j] && turn == j);
///
///   flag[i] = false;
/// } while (true);
///
///

///
/// short-term scheduler (from ready queue)
/// medium-term scheduler
/// long-term scheduler (from job pool)
///
///

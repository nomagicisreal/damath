///
///
/// this file contains:
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
part of damath_experiment;

///
///
/// columns aka variables in R
/// rows aka observations in R
///
abstract class Dataframe {
  const Dataframe();

  factory Dataframe.fromColumns([bool repeatShortestAsLongest = false]) {
    throw UnimplementedError();
  }

  /// see also [RecordDouble2Extension], [RecordDouble3Extension], ...
  void bindRow();

  void bindCol();

  set cNames(List<String> values);

  set rNames(List<String> values);
}


// use indices, index vector, iterable bool into getter for rows or cols
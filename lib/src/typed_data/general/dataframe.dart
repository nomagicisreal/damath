///
///
/// this file contains:
///
///
///
part of damath_typed_data;

///
///
/// columns aka variables in R
/// rows aka observations in R
///
abstract class Dataframe {
  const Dataframe();

  factory Dataframe.fromVariables([bool repeatShortestAsLongest = false]) {
    throw UnimplementedError();
  }

  void bindObservations(); // be consistent with defined types

  void bindVariables(); // define type

  set variableNames(List<String> values);

  set observationNames(List<String> values);
}

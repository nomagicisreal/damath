///
///
/// this file contains:
///
///
part of damath_experiment;

abstract interface class Statistics {
  const Statistics();
}

abstract class StatisticsForVector extends Statistics {
  const StatisticsForVector();
}

abstract class StatisticsForDataframe extends Statistics {
  const StatisticsForDataframe();
}

// mean, median, mode
// measures of variation
//      - range, interquaretile range
//      - variance, standard deviation, deviations from mean)
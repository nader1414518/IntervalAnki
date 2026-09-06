/// Tunable inputs to the FSRS algorithm.
class FsrsParameters {
  /// Creates FSRS parameters, defaulting to [defaultWeights] and a 90%
  /// desired retention.
  const FsrsParameters({
    this.weights = defaultWeights,
    this.requestRetention = 0.9,
    this.maximumIntervalDays = 36500,
  });

  /// The 19 FSRS-4.5 weights. See [defaultWeights].
  final List<double> weights;

  /// Target probability of recall to schedule intervals for (PRD §4.4).
  final double requestRetention;

  /// Upper bound on any computed interval, in days (PRD §4.4).
  final int maximumIntervalDays;

  /// FSRS-4.5's published default parameter set, fit against a large public
  /// review-log dataset by the `open-spaced-repetition` project.
  static const List<double> defaultWeights = [
    0.4072,
    1.1829,
    3.1262,
    15.4722,
    7.2102,
    0.5316,
    1.0651,
    0.0234,
    1.616,
    0.1544,
    1.0824,
    1.9813,
    0.0953,
    0.2975,
    2.2042,
    0.2407,
    2.9466,
    0.5034,
    0.6567,
  ];
}

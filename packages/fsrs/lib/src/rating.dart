/// The grade a user gives a card when answering a review.
///
/// Index order matters: FSRS's default weight vector indexes the first four
/// weights by grade (`weights[Rating.again.index]` is the initial stability
/// for a new card rated "Again", etc).
enum Rating {
  /// The card was forgotten.
  again,

  /// The card was recalled, but with real difficulty.
  hard,

  /// The card was recalled correctly.
  good,

  /// The card was recalled trivially.
  easy,
}

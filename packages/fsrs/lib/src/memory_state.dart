import 'package:meta/meta.dart';

/// FSRS's model of how well a card is remembered: how long it takes to
/// forget ([stability], in days) and how intrinsically hard it is
/// ([difficulty], on a 1-10 scale).
@immutable
class MemoryState {
  /// Creates a memory state.
  const MemoryState({required this.stability, required this.difficulty});

  /// Days until retrievability decays to ~90%.
  final double stability;

  /// How intrinsically hard this card is, from 1 (easiest) to 10 (hardest).
  final double difficulty;

  @override
  String toString() =>
      'MemoryState(stability: $stability, difficulty: $difficulty)';

  @override
  bool operator ==(Object other) =>
      other is MemoryState &&
      other.stability == stability &&
      other.difficulty == difficulty;

  @override
  int get hashCode => Object.hash(stability, difficulty);
}

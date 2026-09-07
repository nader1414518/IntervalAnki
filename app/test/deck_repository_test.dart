import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/repositories/deck_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late DeckRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = DeckRepository(db);
  });

  tearDown(() => db.close());

  group('create', () {
    test('creates a deck and returns its id', () async {
      final id = await repo.create('Spanish');
      final deck = await repo.get(id);
      expect(deck.name, 'Spanish');
    });

    test('throws DeckNameTakenException for a name already in use', () async {
      // AppDatabase.forTesting seeds a "Welcome" deck.
      await expectLater(
        repo.create('Welcome'),
        throwsA(isA<DeckNameTakenException>()),
      );
    });
  });

  group('rename', () {
    test('renames a deck', () async {
      final id = await repo.create('Spanish');
      await repo.rename(id, 'Spanish Vocabulary');
      expect((await repo.get(id)).name, 'Spanish Vocabulary');
    });

    test(
      'throws DeckNameTakenException when renaming to a name already in use',
      () async {
        final id = await repo.create('Spanish');
        await expectLater(
          repo.rename(id, 'Welcome'),
          throwsA(isA<DeckNameTakenException>()),
        );
      },
    );
  });
}

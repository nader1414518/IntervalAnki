import 'package:app/src/app.dart';
import 'package:app/src/data/local/app_database.dart';
import 'package:app/src/data/local/database_provider.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the seeded Welcome deck', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Skip the first-run wizard: this test exercises the deck list, not
    // onboarding, so it stands in for an existing user who's past it.
    final settings = await db.select(db.settings).getSingle();
    await (db.update(db.settings)..where((s) => s.id.equals(settings.id)))
        .write(const SettingsCompanion(onboardingCompleted: Value(true)));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const IntervalApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Interval'), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);

    // Dispose the widget tree (and with it, the watched Drift stream)
    // explicitly, then pump once more so its cleanup timer fires before the
    // test ends — otherwise flutter_test's "no pending timers" check races
    // against Drift's stream-query cleanup and fails.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}

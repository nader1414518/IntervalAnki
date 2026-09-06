import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/backup_service.dart';
import '../../../data/local/tables.dart' show AppThemeMode;
import '../../../data/repositories/settings_repository.dart';

/// PRD §4.11: theme/accent, card font, answer-button layout, backups, plus
/// an accessibility section and a way to replay the first-run wizard.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        data: (settings) => _SettingsBody(settings: settings),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.settings});

  final AppSettings settings;

  Future<void> _update(
    WidgetRef ref,
    SettingsCompanion Function(AppSettings) build,
  ) {
    return ref.read(settingsRepositoryProvider).update(build);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const _SectionHeader('Appearance'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SegmentedButton<AppThemeMode>(
            segments: const [
              ButtonSegment(value: AppThemeMode.system, label: Text('System')),
              ButtonSegment(value: AppThemeMode.light, label: Text('Light')),
              ButtonSegment(value: AppThemeMode.dark, label: Text('Dark')),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selection) => unawaited(
              _update(
                ref,
                (_) => SettingsCompanion(themeMode: Value(selection.first)),
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text('Accent color'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 12,
              children: [
                for (final color in AppTheme.accentChoices)
                  _AccentSwatch(
                    color: color,
                    selected: settings.accentColor == null
                        ? color == AppTheme.accentChoices.first
                        : settings.accentColor == color.toARGB32(),
                    onTap: () => unawaited(
                      _update(
                        ref,
                        (_) => SettingsCompanion(
                          accentColor: Value(
                            color == AppTheme.accentChoices.first
                                ? null
                                : color.toARGB32(),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Divider(),
        const _SectionHeader('Card rendering'),
        ListTile(
          title: const Text('Font size'),
          subtitle: Slider(
            value: settings.cardFontScale,
            min: 0.75,
            max: 2,
            divisions: 25,
            label: '${(settings.cardFontScale * 100).round()}%',
            onChanged: (value) => unawaited(
              _update(
                ref,
                (_) => SettingsCompanion(cardFontScale: Value(value)),
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text('Font family'),
          trailing: DropdownButton<String?>(
            value: settings.cardFontFamily,
            hint: const Text('Template default'),
            items: const [
              DropdownMenuItem(child: Text('Template default')),
              DropdownMenuItem(value: 'Arial', child: Text('Arial')),
              DropdownMenuItem(value: 'Georgia', child: Text('Georgia')),
              DropdownMenuItem(
                value: 'Courier New',
                child: Text('Courier New'),
              ),
              DropdownMenuItem(
                value: 'Comic Sans MS',
                child: Text('Comic Sans MS'),
              ),
            ],
            onChanged: (value) => unawaited(
              _update(
                ref,
                (_) => SettingsCompanion(cardFontFamily: Value(value)),
              ),
            ),
          ),
        ),
        const Divider(),
        const _SectionHeader('Review'),
        ListTile(
          title: const Text('Answer buttons'),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
                ButtonSegment(value: 4, label: Text('4')),
              ],
              selected: {settings.answerButtonCount},
              onSelectionChanged: (selection) => unawaited(
                _update(
                  ref,
                  (_) => SettingsCompanion(
                    answerButtonCount: Value(selection.first),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(),
        const _SectionHeader('Accessibility'),
        SwitchListTile(
          title: const Text('Reduce motion'),
          subtitle: const Text('Cuts screen transitions to an instant swap'),
          value: settings.reducedMotion,
          onChanged: (value) => unawaited(
            _update(ref, (_) => SettingsCompanion(reducedMotion: Value(value))),
          ),
        ),
        const Divider(),
        const _SectionHeader('Backups'),
        SwitchListTile(
          title: const Text('Automatic local backups'),
          subtitle: const Text('Keeps the 5 most recent, on each app launch'),
          value: settings.autoBackupEnabled,
          onChanged: (value) => unawaited(
            _update(
              ref,
              (_) => SettingsCompanion(autoBackupEnabled: Value(value)),
            ),
          ),
        ),
        ListTile(
          title: const Text('Export a backup now'),
          subtitle: const Text('Save a copy of your database to a file'),
          trailing: const Icon(Icons.file_download_outlined),
          onTap: () => unawaited(_export(context, ref)),
        ),
        const Divider(),
        const _SectionHeader('Onboarding'),
        ListTile(
          title: const Text('Replay the welcome tour'),
          trailing: const Icon(Icons.replay),
          onTap: () => unawaited(_replayOnboarding(context, ref)),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final exported = await ref.read(backupServiceProvider).exportManually();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(exported ? 'Backup saved.' : 'Export canceled.')),
    );
  }

  Future<void> _replayOnboarding(BuildContext context, WidgetRef ref) async {
    await _update(
      ref,
      (_) => const SettingsCompanion(onboardingCompleted: Value(false)),
    );
    if (!context.mounted) return;
    context.go('/');
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 3,
                )
              : null,
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

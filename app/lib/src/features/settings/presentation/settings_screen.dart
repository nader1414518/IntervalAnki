import 'dart:async';
import 'dart:ui';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../data/local/app_database.dart';
import '../../../data/local/backup_service.dart';
import '../../../data/local/notification_service.dart';
import '../../../data/local/tables.dart' show AppThemeMode;
import '../../../data/repositories/settings_repository.dart';

/// Where the "Support Interval" entry (PRD §10 — donations, platform TBD
/// by eng) sends people.
const _donationUrl = 'https://buymeacoffee.com/llevelupdev';

/// PRD §4.11: theme/accent, card font, answer-button layout, backups, plus
/// an accessibility section and a way to replay the first-run wizard.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const routeName = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.7),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.08),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text('Settings'),
      ),
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
      // Top padding clears the floating glass app bar.
      padding: EdgeInsets.only(
        top: kToolbarHeight + MediaQuery.of(context).padding.top,
      ),
      children: [
        const _SectionHeader('Support'),
        ListTile(
          title: const Text('Support Interval'),
          subtitle: const Text(
            'Interval is free, with no ads or paywalls — donations are '
            'entirely optional and fund development.',
          ),
          trailing: const Icon(Icons.favorite_outline),
          onTap: () => unawaited(_openDonationLink(context)),
        ),
        const Divider(),
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
              runSpacing: 8,
              children: [
                // The app's own default is always the first choice, so it
                // reads as "the" default rather than just another color —
                // labeled explicitly rather than relying on position alone.
                for (final (index, color) in AppTheme.accentChoices.indexed)
                  _AccentSwatch(
                    color: color,
                    label: index == 0 ? 'Default' : null,
                    selected: settings.accentColor == null
                        ? index == 0
                        : settings.accentColor == color.toARGB32(),
                    onTap: () => unawaited(
                      _update(
                        ref,
                        (_) => SettingsCompanion(
                          accentColor: Value(
                            index == 0 ? null : color.toARGB32(),
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
        const _SectionHeader('Notifications'),
        SwitchListTile(
          title: const Text('Daily study reminder'),
          subtitle: const Text('A nudge at a time you choose'),
          value: settings.dailyReminderEnabled,
          onChanged: (value) => unawaited(_setDailyReminder(ref, value)),
        ),
        if (settings.dailyReminderEnabled)
          ListTile(
            title: const Text('Reminder time'),
            trailing: Text(
              TimeOfDay(
                hour: settings.dailyReminderHour,
                minute: settings.dailyReminderMinute,
              ).format(context),
            ),
            onTap: () => unawaited(_pickReminderTime(context, ref, settings)),
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
        ListTile(
          title: const Text('Restore from a backup'),
          subtitle: const Text(
            'Replaces everything currently in Interval with a backup file',
          ),
          trailing: const Icon(Icons.file_upload_outlined),
          onTap: () => unawaited(_restore(context, ref)),
        ),
        const Divider(),
        const _SectionHeader('Onboarding'),
        ListTile(
          title: const Text('Replay the welcome tour'),
          trailing: const Icon(Icons.replay),
          onTap: () => unawaited(_replayOnboarding(context, ref)),
        ),
        const Divider(),
        const _SectionHeader('About'),
        const ListTile(
          title: Text('Interval'),
          subtitle: Text(
            'Local-first spaced repetition, built around the FSRS scheduler. '
            'Version 1.0.0 — © 2026 Nader Sayed.',
          ),
        ),
        ListTile(
          title: const Text('Open-source licenses'),
          subtitle: const Text('Third-party libraries used by this app'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => unawaited(_showLicenses(context)),
        ),
        ListTile(
          title: const Text('Privacy policy'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => unawaited(
            _open(context, 'https://nadersayed.github.io/interval-privacy/'),
          ),
        ),
        ListTile(
          title: const Text('Contact support'),
          subtitle: const Text('nader19113118@gmail.com'),
          trailing: const Icon(Icons.open_in_new),
          onTap: () => unawaited(
            _open(context, 'mailto:nader19113118@gmail.com'),
          ),
        ),
      ],
    );
  }

  Future<void> _showLicenses(BuildContext context) async {
    showLicensePage(
      context: context,
      applicationName: 'Interval',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 Nader Sayed',
    );
  }

  Future<void> _open(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final exported = await ref.read(backupServiceProvider).exportManually();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(exported ? 'Backup saved.' : 'Export canceled.')),
    );
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final backups = ref.read(backupServiceProvider);
    final picked = await backups.pickBackupFile();
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    if (!backups.looksLikeDatabase(bytes)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("That file doesn't look like a valid backup."),
        ),
      );
      return;
    }
    if (!context.mounted) return;

    final confirmed = await showConfirmDialog(
      context,
      title: 'Restore from backup?',
      message:
          'This replaces everything currently in Interval — every deck, '
          'card, and setting — with the contents of "${picked.name}". '
          "This can't be undone.",
      confirmLabel: 'Restore',
      isDestructive: true,
    );
    if (!confirmed) return;

    // restoreFromBytes swaps the file without touching the live
    // connection (see its own doc comment for why — closing it here
    // deadlocks). That connection stays open but now stale, still
    // reading/writing the pre-restore snapshot, which is why a real app
    // restart is the only way to pick up the swapped file — the dialog
    // below is what makes that clear instead of leaving the rest of the
    // app silently running against stale data.
    await backups.restoreFromBytes(bytes);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Restore complete'),
        content: const Text(
          'Close Interval completely (swipe it away in your app switcher) '
          'and reopen it to see the restored data.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _openDonationLink(BuildContext context) async {
    final launched = await launchUrl(
      Uri.parse(_donationUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the donation link.")),
      );
    }
  }

  Future<void> _replayOnboarding(BuildContext context, WidgetRef ref) async {
    await _update(
      ref,
      (_) => const SettingsCompanion(onboardingCompleted: Value(false)),
    );
    if (!context.mounted) return;
    context.go('/');
  }

  Future<void> _setDailyReminder(WidgetRef ref, bool enabled) async {
    // Persist first: the toggle shouldn't hang on a slow (or, on some
    // simulators, unresponsive) permission round-trip — request it in the
    // background instead.
    await _update(
      ref,
      (_) => SettingsCompanion(dailyReminderEnabled: Value(enabled)),
    );
    if (enabled) {
      unawaited(ref.read(notificationServiceProvider).requestPermission());
    }
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.dailyReminderHour,
        minute: settings.dailyReminderMinute,
      ),
    );
    if (picked == null) return;
    await _update(
      ref,
      (_) => SettingsCompanion(
        dailyReminderHour: Value(picked.hour),
        dailyReminderMinute: Value(picked.minute),
      ),
    );
  }
}

class _AccentSwatch extends StatelessWidget {
  const _AccentSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
    this.label,
  });

  final Color color;
  final String? label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = InkWell(
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
    if (label == null) return swatch;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const SizedBox(height: 2),
        Text(label!, style: Theme.of(context).textTheme.labelSmall),
      ],
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/local/backup_service.dart';
import 'data/local/notification_service.dart';
import 'data/local/tables.dart' show AppThemeMode;
import 'data/repositories/settings_repository.dart';

class IntervalApp extends ConsumerWidget {
  const IntervalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(autoBackupOnStartupProvider)
      ..watch(notificationScheduleSyncProvider);
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(settingsProvider).value;
    final accentColor = settings?.accentColor == null
        ? null
        : Color(settings!.accentColor!);
    final reducedMotion = settings?.reducedMotion ?? false;
    return MaterialApp.router(
      title: 'Interval',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        accentColor: accentColor,
        reducedMotion: reducedMotion,
      ),
      darkTheme: AppTheme.dark(
        accentColor: accentColor,
        reducedMotion: reducedMotion,
      ),
      themeMode: switch (settings?.themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system || null => ThemeMode.system,
      },
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: reducedMotion),
        child: child!,
      ),
      routerConfig: router,
    );
  }
}

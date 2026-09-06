import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../repositories/settings_repository.dart';

part 'notification_service.g.dart';

/// The local daily study-reminder notification (PRD §4.10). Scheduling is
/// re-applied from Settings on every app start and whenever the reminder
/// setting changes — see `IntervalApp`.
///
/// Fires unconditionally at the set time rather than checking whether
/// today's reviews are already done first (the PRD's "smart nudge" idea):
/// a purely local notification is scheduled by the OS ahead of time, with
/// no hook to run app code and cancel it right before delivery.
class NotificationService {
  static const _dailyReminderId = 1;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    final localZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localZone.identifier));
    await _plugin.initialize(
      // iOS requests alert/badge/sound permission *during init* by default
      // — disabled here so the prompt only appears from requestPermission(),
      // when the user actually turns the reminder on in Settings.
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  /// Asks the OS for notification permission; returns whether it's granted.
  Future<bool> requestPermission() async {
    await _ensureInitialized();
    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return (androidGranted ?? true) && (iosGranted ?? true);
  }

  /// Schedules the daily reminder for [hour]:[minute] local time, repeating
  /// every day — replaces any previously scheduled one.
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _ensureInitialized();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _plugin.zonedSchedule(
      id: _dailyReminderId,
      title: 'Time to review',
      body: 'Your cards are waiting for you in Interval.',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily study reminder',
          channelDescription: 'A daily nudge to review your due cards.',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Inexact: fires within a window rather than to the exact minute, so
      // it doesn't need Android 12+'s special "exact alarm" permission for
      // what's just a daily nudge, not a time-critical alert.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _ensureInitialized();
    await _plugin.cancel(id: _dailyReminderId);
  }
}

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();

/// Keeps the scheduled reminder in sync with Settings — re-runs whenever
/// the daily-reminder fields change, since it watches `settingsProvider`.
/// Held alive by a `ref.watch` in `IntervalApp`, the app's root widget.
@riverpod
Future<void> notificationScheduleSync(Ref ref) async {
  final settings = await ref.watch(settingsProvider.future);
  final service = ref.watch(notificationServiceProvider);
  if (settings.dailyReminderEnabled) {
    await service.scheduleDailyReminder(
      hour: settings.dailyReminderHour,
      minute: settings.dailyReminderMinute,
    );
  } else {
    await service.cancelDailyReminder();
  }
}

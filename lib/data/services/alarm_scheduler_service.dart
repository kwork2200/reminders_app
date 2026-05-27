import 'dart:developer' as debug;
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/chime_model.dart';
import 'notification_service.dart';
import 'storage_service.dart';

/// Service that schedules exact alarms for chime reminders.
/// This is more reliable than timer-based checking when app is killed.
class AlarmSchedulerService {
  static final AlarmSchedulerService _instance = AlarmSchedulerService._internal();
  factory AlarmSchedulerService() => _instance;
  AlarmSchedulerService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();

  bool _isInitialized = false;
  Timer? _rescheduleTimer;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _notificationService.initialize();
    
    _isInitialized = true;
    debugPrint('✅ AlarmSchedulerService initialized');
  }

  /// Schedule all active chimes for the next 24 hours
  Future<void> scheduleAllChimes() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Check if we have exact alarm permission (Android 12+)
    try {
      final canSchedule = await _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.canScheduleExactNotifications() ?? false;
      if (!canSchedule) {
        debugPrint('❌ Cannot schedule exact notifications - permission not granted!');
        debugPrint('   Go to Settings > Apps > Special app access > Alarms & reminders');
        return;
      }
    } catch (e) {
      debugPrint('⚠️ Could not check exact alarm permission: $e');
    }

    debugPrint('📅 Scheduling all chimes...');
    
    // Cancel existing scheduled notifications first
    await _notificationService.cancelAllNotifications();
    debugPrint('🗑️ Cancelled existing scheduled notifications');

    final chimes = _storageService.getChimes();
    final now = DateTime.now();
    int scheduledCount = 0;

    for (final chime in chimes) {
      if (!chime.isEnabled) continue;
      
      final scheduled = await _scheduleChimeForNext24Hours(chime, now);
      scheduledCount += scheduled;
    }

    debugPrint('✅ Scheduled $scheduledCount chime notifications for next 24 hours');
  }

  /// Schedule a single chime for the next 24 hours (one per day)
  Future<int> _scheduleChimeForNext24Hours(Chime chime, DateTime now) async {
    int scheduledCount = 0;
    
    // Get current day of week (0=Sunday, 1=Monday, ..., 6=Saturday)
    final currentDayOfWeek = now.weekday == 7 ? 0 : now.weekday;
    
    // Convert chime time to 24-hour format
    int chimeHour24 = chime.hour;
    if (chime.isPM && chime.hour != 12) {
      chimeHour24 += 12;
    } else if (!chime.isPM && chime.hour == 12) {
      chimeHour24 = 0;
    }

    // Check next 7 days to find all matching days
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDay = (currentDayOfWeek + dayOffset) % 7;
      
      // Skip if this day is not in chime's active days
      if (!chime.days.contains(targetDay)) continue;

      // Calculate target date
      DateTime targetDate = DateTime(
        now.year,
        now.month,
        now.day + dayOffset,
        chimeHour24,
        chime.minute,
      );

      // If it's today and time has already passed, skip to next week
      if (dayOffset == 0 && targetDate.isBefore(now)) {
        continue;
      }

      // Schedule the notification using exact alarm
      await _scheduleExactNotification(
        chime: chime,
        scheduledTime: targetDate,
        notificationId: _generateNotificationId(chime.id, targetDate),
      );
      scheduledCount++;

      debugPrint('📅 Scheduled "${chime.name}" for ${targetDate.toString()}');
    }

    return scheduledCount;
  }

  /// Schedule an exact notification using Android's alarm manager
  Future<void> _scheduleExactNotification({
    required Chime chime,
    required DateTime scheduledTime,
    required int notificationId,
  }) async {
    final String? soundResource = chime.soundEnabled 
        ? _getAndroidSoundResource(chime.chimeSound) 
        : null;

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chime_exact_alarm_channel',
      'Chime Exact Alarms',
      channelDescription: 'Exact alarm notifications for chime reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      playSound: chime.soundEnabled,
      sound: soundResource != null 
          ? RawResourceAndroidNotificationSound(soundResource) 
          : null,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
      autoCancel: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      // Critical for exact alarms - use AlarmClock for reliability
      ongoing: false,
      usesChronometer: false,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );

    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      chime.name,
      'Time: ${chime.formattedTime}',
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: chime.id,
    );
  }

  /// Generate unique notification ID based on chime ID and date
  int _generateNotificationId(String chimeId, DateTime date) {
    // Create a unique ID using chime ID hash + date components
    final chimeHash = chimeId.hashCode;
    final dateHash = date.year * 10000 + date.month * 100 + date.day;
    return (chimeHash + dateHash).abs() % 2147483647; // Max int value
  }

  /// Map sound names to Android raw resource names
  String? _getAndroidSoundResource(String? soundName) {
    if (soundName == null) return 'beep';

    final soundMap = {
      'Beep': 'beep',
      'Happy Ending': 'happy_ending',
      'Casio Tone': 'casio_tone',
      'Smooth Notification': 'a_36505577_notification_smooth_modern_stereo_332449',
      'Dragon Alert': 'dragon_studio_alert_444816',
      'New Notification 3': 'dragon_studio_new_notification_3_398649',
      'Phone Ringing': 'dragon_studio_phone_ringing_382734',
      'Cell Phone Double Beep': 'freesound_community_cell_phone_dbl_beep_notification_83306',
      'Pop': 'freesound_community_pop_39222',
      'Smooth Intro': 'freesound_community_smooth_intro_72591',
      'Message Alert': 'liecio_message_alert_190042',
      'Digital Alert': 'soynoviembre_short_digital_notification_alert_440353',
      'Vibration': 'universfield_cell_phone_vibration_352298',
      'Double Car Horn': 'universfield_double_car_horn_352443',
      'Notification 036': 'universfield_new_notification_036_485897',
      'Notification 040': 'universfield_new_notification_040_493469',
      'Notification 057': 'universfield_new_notification_057_494255',
      'Notification 09': 'universfield_new_notification_09_352705',
      'Thriller Ring': 'bryansantosbreton_thriller_whooshes_amp_transitions_sfx_pack_186255',
      'Light Rain': 'jayalvarez66_light_rain_smooth_11608',
    };

    return soundMap[soundName] ?? 'beep';
  }

  /// Start periodic rescheduling (call this from background service)
  void startReschedulingTimer() {
    // Cancel existing timer
    _rescheduleTimer?.cancel();

    // Reschedule every 12 hours to ensure notifications are set for next 24 hours
    _rescheduleTimer = Timer.periodic(const Duration(hours: 12), (timer) async {
      debugPrint('🔄 Periodic rescheduling of chimes...');
      await scheduleAllChimes();
    });

    debugPrint('✅ Rescheduling timer started (every 12 hours)');
  }

  /// Stop the rescheduling timer
  void stopReschedulingTimer() {
    _rescheduleTimer?.cancel();
    _rescheduleTimer = null;
    debugPrint('🛑 Rescheduling timer stopped');
  }

  /// Reschedule a specific chime (call after adding/editing)
  Future<void> rescheduleChime(Chime chime) async {
    if (!chime.isEnabled) {
      debugPrint('⏭️ Chime "${chime.name}" is disabled, skipping reschedule');
      return;
    }

    debugPrint('🔄 Rescheduling chime: ${chime.name}');
    await _scheduleChimeForNext24Hours(chime, DateTime.now());
  }

  /// Cancel all scheduled notifications for a chime
  Future<void> cancelChimeNotifications(String chimeId) async {
    debugPrint('🗑️ Cancelling notifications for chime: $chimeId');
    
    // Cancel notifications for next 7 days
    final now = DateTime.now();
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDate = DateTime(
        now.year,
        now.month,
        now.day + dayOffset,
      );
      final notificationId = _generateNotificationId(chimeId, targetDate);
      await _notificationService.cancelNotification(notificationId);
    }
  }
}

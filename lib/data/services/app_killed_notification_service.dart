import 'dart:developer' as debug;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/chime_model.dart';
import 'storage_service.dart';

/// Service that handles notifications when app is killed using exact alarms
/// Note: notification_when_app_is_killed package has limited API, using flutter_local_notifications with exact alarms instead
class AppKilledNotificationService {
  static final AppKilledNotificationService _instance = AppKilledNotificationService._internal();
  factory AppKilledNotificationService() => _instance;
  AppKilledNotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final StorageService _storageService = StorageService();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize notification plugin
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create notification channel for killed-app notifications
    await _createNotificationChannel();

    _isInitialized = true;
    debugPrint('✅ AppKilledNotificationService initialized');
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'chime_killed_app_channel',
      'Chime App-Killed Notifications',
      description: 'Notifications that work even when app is killed',
      importance: Importance.max,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule all chimes using the killed-app notification system
  Future<void> scheduleAllChimes() async {
    if (!_isInitialized) await initialize();

    final chimes = _storageService.getChimes();
    final now = DateTime.now();
    int scheduledCount = 0;

    for (final chime in chimes) {
      if (!chime.isEnabled) continue;
      
      final scheduled = await _scheduleChimeForNext7Days(chime, now);
      scheduledCount += scheduled;
    }

    debugPrint('✅ Scheduled $scheduledCount notifications via killed-app plugin');
  }

  /// Schedule a chime for next 7 days
  Future<int> _scheduleChimeForNext7Days(Chime chime, DateTime now) async {
    int scheduledCount = 0;
    
    int chimeHour24 = chime.hour;
    if (chime.isPM && chime.hour != 12) chimeHour24 += 12;
    else if (!chime.isPM && chime.hour == 12) chimeHour24 = 0;

    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDateTime = DateTime(
        now.year, now.month, now.day + dayOffset,
        chimeHour24, chime.minute,
      );

      final targetDayOfWeek = targetDateTime.weekday % 7;
      if (!chime.days.contains(targetDayOfWeek)) continue;

      // Skip if time already passed (with 1 min buffer)
      if (targetDateTime.isBefore(now.add(const Duration(minutes: 1)))) continue;

      // Schedule using exact alarm that survives app kill
      await _scheduleExactAlarm(
        chime: chime,
        scheduledTime: targetDateTime,
      );
      scheduledCount++;
    }

    return scheduledCount;
  }

  /// Schedule exact alarm notification
  Future<void> _scheduleExactAlarm({
    required Chime chime,
    required DateTime scheduledTime,
  }) async {
    final String? soundResource = _getAndroidSoundResource(chime.chimeSound);

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'chime_killed_app_channel',
      'Chime App-Killed Notifications',
      channelDescription: 'Notifications that work even when app is killed',
      importance: Importance.max,
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

    await _localNotifications.zonedSchedule(
      _generateNotificationId(chime.id, scheduledTime),
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

  /// Generate unique notification ID
  int _generateNotificationId(String chimeId, DateTime date) {
    final chimeHash = chimeId.hashCode;
    final dateHash = date.year * 10000 + date.month * 100 + date.day;
    return (chimeHash + dateHash).abs() % 2147483647;
  }

  /// Map sound names to Android raw resources (must match file names in res/raw/ exactly)
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

  /// Cancel all notifications for a specific chime
  Future<void> cancelChimeNotifications(String chimeId) async {
    final now = DateTime.now();
    for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
      final targetDate = DateTime(now.year, now.month, now.day + dayOffset);
      final notificationId = _generateNotificationId(chimeId, targetDate);
      await _localNotifications.cancel(notificationId);
    }
    debugPrint('🗑️ Cancelled notifications for chime: $chimeId');
  }

  /// Reschedule a specific chime
  Future<void> rescheduleChime(Chime chime) async {
    await cancelChimeNotifications(chime.id);
    if (!chime.isEnabled) return;
    await _scheduleChimeForNext7Days(chime, DateTime.now());
    debugPrint('✅ Rescheduled: ${chime.name}');
  }
}

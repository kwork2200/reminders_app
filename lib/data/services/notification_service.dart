import 'dart:developer' as debug;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels
    await _createNotificationChannels();

    _isInitialized = true;
    debugPrint('✅ Notification service initialized');
  }

  Future<void> _createNotificationChannels() async {
    // Foreground service channel
    const AndroidNotificationChannel foregroundChannel = AndroidNotificationChannel(
      'chime_foreground_channel',
      'Chime Foreground Service',
      description: 'Keeps chime reminders active in background',
      importance: Importance.low,
      enableLights: false,
      enableVibration: false,
      playSound: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(foregroundChannel);

    // Silent chime notifications channel (for when sound is disabled)
    const AndroidNotificationChannel chimeChannel = AndroidNotificationChannel(
      'chime_channel_silent',
      'Silent Chime Notifications',
      description: 'Silent notifications for chime reminders',
      importance: Importance.high,
      enableLights: true,
      enableVibration: false,
      playSound: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(chimeChannel);

    // Sound chime notifications channel (for when sound is enabled)
    const AndroidNotificationChannel chimeSoundChannel = AndroidNotificationChannel(
      'chime_channel_sound_v2',
      'Chime Reminder Notifications',
      description: 'Notifications for chime reminders with sound',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(chimeSoundChannel);

    // Exact alarm channel (for scheduled notifications that work when app is killed)
    const AndroidNotificationChannel exactAlarmChannel = AndroidNotificationChannel(
      'chime_exact_alarm_channel',
      'Chime Exact Alarms',
      description: 'Exact alarm notifications for reliable chime reminders',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(exactAlarmChannel);

    debugPrint('✅ Notification channels created');
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Notification tapped: ${response.payload}');
    // Stop any playing sound when notification is tapped
    _audioPlayer.stop();
    debugPrint('🔇 Sound stopped on notification tap');
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  String _getSoundFile(String soundName) {
    // Map sound names to their file names (without .mp3 extension)
    // Android raw resources use underscores instead of hyphens
    final soundMap = {
      'Beep': 'beep',
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
      'Happy Ending': 'happy_ending',
    };
    
    return soundMap[soundName] ?? 'beep';
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? soundName,
  }) async {
    if (!_isInitialized) {
      debugPrint('⚠️ Notification service not initialized');
      await initialize();
    }

    // Get sound resource for Android notification
    final String? soundResource = _getAndroidSoundResource(soundName);
    debugPrint('🔊 Using notification sound: $soundResource');

    // Configure Android notification with sound
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chime_channel_sound_v2',
      'Chime Reminder Notifications',
      channelDescription: 'Notifications for chime reminders with sound',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      playSound: true, // Enable notification sound
      sound: soundResource != null ? RawResourceAndroidNotificationSound(soundResource) : null,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
      autoCancel: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    debugPrint('🔔 Notification shown: $title - $body with sound: $soundName');
  }

  // Map sound names to Android raw resource names (must match file names in res/raw/ exactly, without .mp3)
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

  Future<void> stopSound() async {
    await _audioPlayer.stop();
    debugPrint('🔇 Sound stopped manually');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) {
      debugPrint('⚠️ Notification service not initialized');
      await initialize();
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chime_channel',
      'Chime Notifications',
      channelDescription: 'Notifications for chime reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    debugPrint('📅 Notification scheduled for: $scheduledTime');
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    debugPrint('🗑️ Notification cancelled: $id');
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('🗑️ All notifications cancelled');
  }
}

import 'dart:async';
import 'dart:developer' as debug;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import '../models/chime_model.dart';
import 'storage_service.dart';
import 'notification_service.dart';
import 'alarm_scheduler_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize notification service first to create channels
    await _notificationService.initialize();
    
    final service = FlutterBackgroundService();
    
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'chime_foreground_channel',
        initialNotificationTitle: 'Chime Reminders Active',
        initialNotificationContent: 'Your reminders will work even when app is closed',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    _isInitialized = true;
    debugPrint('✅ Background service initialized');
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    debugPrint('iOS background service started');
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    debugPrint('🚀 Background service started');

    DartPluginRegistrant.ensureInitialized();

    // Initialize GetStorage for background isolate
    final storageService = StorageService();
    await storageService.init(); // CRITICAL: Initialize GetStorage in background
    debugPrint('✅ Storage service initialized in background');

    final notificationService = NotificationService();

    // Initialize notification service in background
    await notificationService.initialize();

    // Initialize alarm scheduler for exact alarms
    final alarmScheduler = AlarmSchedulerService();
    await alarmScheduler.initialize();
    
    // Schedule all chimes using exact alarms (more reliable than timer)
    await alarmScheduler.scheduleAllChimes();
    
    // Start periodic rescheduling timer (every 12 hours)
    alarmScheduler.startReschedulingTimer();

    debugPrint('✅ Background service using exact alarm scheduling');

    // Handle stopService event so the service properly restores itself
    if (service is AndroidServiceInstance) {
      service.on('stopService').listen((event) {
        service.stopSelf();
      });
    }
  }

  static Future<void> _triggerChimeInBackground(
    Chime chime,
    NotificationService notificationService,
  ) async {
    try {
      debugPrint('🚀 Background: Triggering chime ${chime.name}');

      // Show notification with sound (sound comes from notification, not audioplayers)
      // This works even when app is killed because Android handles notification sounds natively
      await notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: chime.name,
        body: 'Time: ${chime.formattedTime}',
        soundName: chime.soundEnabled ? chime.chimeSound : null,
      );
      debugPrint('✅ Background: Notification shown with sound');

      // Vibrate if enabled (vibration also comes from notification channel)
      // VibrationService requires Flutter engine which may not work when app is killed
      debugPrint('✅ Background: Chime execution completed');
    } catch (e) {
      debugPrint('❌ Background: Error triggering chime: $e');
    }
  }

  Future<void> startService() async {
    final service = FlutterBackgroundService();
    await service.startService();
    debugPrint('🚀 Background service started manually');
  }

  Future<void> stopService() async {
    final service = FlutterBackgroundService();
    service.invoke('stopService');
    debugPrint('🛑 Background service stopped');
  }

  Future<bool> isServiceRunning() async {
    return await FlutterBackgroundService().isRunning();
  }

  void updateNotification({
    String? title,
    String? content,
  }) {
    if (title != null || content != null) {
      FlutterBackgroundService().invoke(
        'updateNotification',
        {
          'title': title ?? 'Chime Reminders',
          'content': content ?? 'Background service is running',
        },
      );
    }
  }
}

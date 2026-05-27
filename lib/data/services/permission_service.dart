import 'dart:developer' as debug;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service to handle runtime permissions for exact alarms and notifications
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check and request all necessary permissions for background notifications
  Future<bool> requestAllPermissions() async {
    bool allGranted = true;

    // 1. Notification permission (Android 13+)
    final notificationStatus = await Permission.notification.request();
    if (notificationStatus.isGranted) {
      debugPrint('✅ Notification permission granted');
    } else {
      debugPrint('❌ Notification permission denied');
      allGranted = false;
    }

    // 2. Exact alarm permission (Android 12+)
    final exactAlarmStatus = await Permission.scheduleExactAlarm.request();
    if (exactAlarmStatus.isGranted) {
      debugPrint('✅ Exact alarm permission granted');
    } else {
      debugPrint('❌ Exact alarm permission denied - alarms may not work when app is killed');
      allGranted = false;
    }

    return allGranted;
  }

  /// Check if exact alarm permission is granted
  Future<bool> canScheduleExactAlarms() async {
    final status = await Permission.scheduleExactAlarm.status;
    return status.isGranted;
  }

  /// Open system settings for exact alarm permission
  Future<void> openExactAlarmSettings() async {
    try {
      const platform = MethodChannel('app.channel.shared.data');
      await platform.invokeMethod('openExactAlarmSettings');
    } catch (e) {
      debugPrint('Could not open exact alarm settings: $e');
      // Fallback: open general app settings
      await openAppSettings();
    }
  }

  /// Open general app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

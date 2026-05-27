import 'dart:developer' as debug;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BatteryOptimizationService {
  static Future<bool> isBatteryOptimizationEnabled() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      return status.isDenied || status.isRestricted;
    } catch (e) {
      debugPrint('❌ Error checking battery optimization: $e');
      return true; // Assume enabled if we can't check
    }
  }

  static Future<bool> requestDisableBatteryOptimization() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.request();
      return status.isGranted;
    } catch (e) {
      debugPrint('❌ Error requesting battery optimization: $e');
      return false;
    }
  }

  static void showBatteryOptimizationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Battery Optimization'),
        content: const Text(
          'For reminders to work when the app is closed, please disable battery optimization for this app.\n\n'
          'This will allow the app to run in the background and trigger reminders at the scheduled time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await requestDisableBatteryOptimization();
            },
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer' as debug;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/functions.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final bodyColor = isDark ? Colors.white70 : Colors.black54;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        title: Text(
          'Battery Optimization',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'For reminders to work when the app is closed, please disable battery optimization for this app.\n\n'
          'This will allow the app to run in the background and trigger reminders at the scheduled time.',
          style: TextStyle(color: bodyColor, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await showManagedInterstitialAd(context);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              'Later',
              style: TextStyle(color: bodyColor),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await showManagedInterstitialAd(context);
              if (context.mounted) Navigator.pop(context);
              await requestDisableBatteryOptimization();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              foregroundColor: Colors.white,
            ),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }
}

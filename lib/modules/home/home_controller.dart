import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../data/models/chime_model.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/notification_service.dart';
import '../../data/services/sound_service.dart';
import '../../data/services/vibration_service.dart';
import '../../data/services/background_service.dart';
import '../../data/services/alarm_scheduler_service.dart';
import '../../data/services/background_test_service.dart';
import '../../data/services/battery_optimization_service.dart';
import '../../utils/functions.dart';

class HomeController extends GetxController {
  final isDefaultChimeEnabled = false.obs; // Always false by default
  final chimes = <Chime>[].obs;
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  final AlarmSchedulerService _alarmScheduler = AlarmSchedulerService();
  
  // Reactive flag to trigger refresh
  final shouldRefreshChimes = false.obs;
  
  // Timer for checking time (kept for foreground functionality)
  Timer? _timeCheckTimer;
  
  // Track last triggered chimes to prevent duplicate notifications
  final Set<String> _triggeredChimesToday = {};
  
  // Track chime card taps for full-screen ads
  int _chimeCardTapCount = 0;
  
  // Reactive banner ad state

  final isBannerAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('HomeController initialized');
    loadChimes();
    _loadDefaultChimeSetting();
    
    _notificationService.initialize();

    Future.delayed(const Duration(seconds: 3), () async {
      final isOptimized = await BatteryOptimizationService.isBatteryOptimizationEnabled();
      if (isOptimized) {
        final context = Get.context;
        if (context != null) {
          BatteryOptimizationService.showBatteryOptimizationDialog(context);
        }
      } else {
        print('✅ Battery optimization is disabled - reminders will work in background');
      }
    });

    _startTimeCheckTimer();
    
    ever(shouldRefreshChimes, (bool shouldRefresh) async {
      if (shouldRefresh) {
        loadChimes();
        shouldRefreshChimes.value = false;
        await _alarmScheduler.scheduleAllChimes();
      }
    });
  }

  @override
  void onClose() {
    print('HomeController onClose: Cancelling timer and disposing ads');
    _timeCheckTimer?.cancel();
    _timeCheckTimer = null;
    super.onClose();
  }

  void _startTimeCheckTimer() {
    _timeCheckTimer?.cancel();
    _timeCheckTimer = null;
    
    _timeCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkChimeTimes();
    });
  }

  void _checkChimeTimes() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentDayOfWeek = now.weekday % 7;
    
    print('🕐 Checking time: $currentHour:$currentMinute (Day: $currentDayOfWeek)');
    print('📋 Total chimes: ${chimes.length}');

    for (final chime in chimes) {
      print('🔍 Checking chime: ${chime.name}');
      print('   - Enabled: ${chime.isEnabled}');
      print('   - Time: ${chime.hour}:${chime.minute} ${chime.isPM ? "PM" : "AM"}');
      print('   - Days: ${chime.days}');
      print('   - Sound enabled: ${chime.soundEnabled}');
      
      // Skip if chime is not enabled
      if (!chime.isEnabled) {
        print('   ❌ Chime disabled, skipping');
        continue;
      }
      
      // Skip if today is not in the chime's days
      if (!chime.days.contains(currentDayOfWeek)) {
        print('   ❌ Today not in chime days, skipping');
        continue;
      }
      
      // Convert chime time to 24-hour format for comparison
      int chimeHour24 = chime.hour;
      if (chime.isPM && chime.hour != 12) {
        chimeHour24 += 12;
      } else if (!chime.isPM && chime.hour == 12) {
        chimeHour24 = 0;
      }
      
      print('   - Converted 24h time: $chimeHour24:${chime.minute}');
      print('   - Current time: $currentHour:$currentMinute');
      
      // Check if current time matches chime time
      if (currentHour == chimeHour24 && currentMinute == chime.minute) {
        final triggerKey = '${chime.id}_${now.year}_${now.month}_${now.day}';
        print('   ⏰ Time match found!');
        print('   - Trigger key: $triggerKey');
        print('   - Already triggered today: ${_triggeredChimesToday.contains(triggerKey)}');
        
        // Prevent duplicate notifications for the same chime on the same day
        if (!_triggeredChimesToday.contains(triggerKey)) {
          _triggeredChimesToday.add(triggerKey);
          print('   ✅ Triggering chime now!');
          _triggerChime(chime);
          print('🔔 Chime triggered: ${chime.name} at ${chime.formattedTime}');
        } else {
          print('   ⚠️ Already triggered today, skipping');
        }
      } else {
        print('   ⏱️ Time does not match');
      }
    }
    
    // Clear triggered chimes at midnight (simple check)
    if (currentHour == 0 && currentMinute == 0) {
      _triggeredChimesToday.clear();
      print('🗑️ Cleared triggered chimes at midnight');
    }
  }

  Future<void> _triggerChime(Chime chime) async {
    print('🚀 _triggerChime called for: ${chime.name}');
    print('   - Sound enabled: ${chime.soundEnabled}');
    print('   - Sound file: ${chime.chimeSound}');
    print('   - Vibration: ${chime.vibration}');
    
    // Show notification with custom sound
    try {
      print('📱 Showing notification...');
      await _notificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: chime.name,
        body: 'Time: ${chime.formattedTime}',
        soundName: chime.soundEnabled ? chime.chimeSound : null,
      );
      print('✅ Notification shown successfully');
    } catch (e) {
      print('❌ Error showing notification: $e');
    }
    
    // Play sound if enabled (additional playback for in-app)
    if (chime.soundEnabled) {
      try {
        print('🔊 Playing sound: ${chime.chimeSound}');
        await SoundService.playSound(chime.chimeSound);
        print('✅ Sound played successfully');
      } catch (e) {
        print('❌ Error playing sound: $e');
      }
    }
    
    // Vibrate if enabled
    if (chime.vibration != 'None') {
      try {
        print('📳 Vibrating: ${chime.vibration}');
        await VibrationService.vibrate(chime.vibration);
        print('✅ Vibration completed');
      } catch (e) {
        print('❌ Error vibrating: $e');
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadChimes();
  }

  void loadChimes() {
    print('Loading chimes from storage');
    chimes.value = _storageService.getChimes();
    print('Loaded ${chimes.value.length} chimes');
    
    // Clear triggered chimes when chimes are reloaded to allow immediate testing
    _triggeredChimesToday.clear();
    print('🗑️ Cleared triggered chimes cache for testing');
    
    // Restart timer to ensure it uses latest data
    _startTimeCheckTimer();
  }

  void toggleDefaultChime(bool value) {
    isDefaultChimeEnabled.value = value;
    _saveDefaultChimeSetting();
  }

  void _saveDefaultChimeSetting() {
    final settings = {
      'isDefaultChimeEnabled': isDefaultChimeEnabled.value,
    };
    _storageService.saveSettings(settings);
  }

  void _loadDefaultChimeSetting() {
    final settings = _storageService.getSettings();
    isDefaultChimeEnabled.value = settings['isDefaultChimeEnabled'] ?? false;
  }
  
  void toggleChime(String chimeId) async {
    await _storageService.toggleChime(chimeId);
    loadChimes();
    
    // Reschedule chimes after toggle
    final chime = chimes.firstWhereOrNull((c) => c.id == chimeId);
    if (chime != null) {
      if (chime.isEnabled) {
        await _alarmScheduler.rescheduleChime(chime);
      } else {
        await _alarmScheduler.cancelChimeNotifications(chimeId);
      }
    }
  }

  void _stopChimeNotifications(String chimeId) {
    // Stop any playing sound for this chime
    SoundService.stopSound();
    
    // Clear this chime from triggered cache to prevent future notifications
    final now = DateTime.now();
    final triggerKey = '${chimeId}_${now.year}_${now.month}_${now.day}';
    _triggeredChimesToday.remove(triggerKey);
    
    print('🛑 Stopped notifications and sounds for chime: $chimeId');
  }

  void deleteChime(String chimeId) async {
    // Cancel notifications for this chime first
    await _alarmScheduler.cancelChimeNotifications(chimeId);
    await _storageService.deleteChime(chimeId);
    loadChimes();
  }

  Future<void> navigateToUpgrade() async {
    final context = Get.context;
    if (context != null) {
      await showManagedInterstitialAd(context);
    }
    Get.toNamed(Routes.UPGRADE);
  }

  void addChime() async {
    print('addChime() method called');
    print('Navigating to ADD_CHIME');
    try {
      final context = Get.context;
      if (context != null) {
        await showManagedInterstitialAd(context);
      }
      final result = await Get.toNamed(Routes.ADD_CHIME);
      print('Returned from ADD_CHIME with result: $result');
      if (result == 'refresh') {
        print('Refreshing chimes list');
        loadChimes();
      } else {
        print('No refresh needed, result was: $result');
      }
    } catch (e) {
      print('Error in addChime navigation: $e');
    }
  }

  void editChime(String chimeId) async {
    print('editChime() method called with chimeId: $chimeId');
    print('Navigating to ADD_CHIME for editing chime: $chimeId');
    try {
      final result = await Get.toNamed(Routes.ADD_CHIME, arguments: chimeId);
      print('Returned from ADD_CHIME with result: $result');
      if (result == 'refresh') {
        print('Refreshing chimes list');
        loadChimes();
      } else {
        print('No refresh needed, result was: $result');
      }
    } catch (e) {
      print('Error in editChime navigation: $e');
    }
  }

  Future<void> navigateToSettings() async {
    final context = Get.context;
    if (context != null) {
      await showManagedInterstitialAd(context);
    }
    Get.toNamed(Routes.SETTINGS);
  }

  void refreshChimes() {
    loadChimes();
  }
  
  // Method to trigger refresh from external controllers
  void triggerRefresh() {
    print('External refresh triggered');
    shouldRefreshChimes.value = true;
  }
  

  // Handle chime card tap with full-screen ad logic
  void onChimeCardTap(String chimeId) {
    print('🔵 Chime card tapped: $chimeId');
    
    // Increment tap counter
    _chimeCardTapCount++;
    print('🔵 Tap count: $_chimeCardTapCount');
    
    // Check if it's the 5th tap
    if (_chimeCardTapCount % 5 == 0) {
      print('🎯 5th tap detected! Showing full-screen ad...');
      _showFullScreenAdAndNavigate(chimeId);
    } else {
      print('📱 Navigating directly to edit chime');
      editChime(chimeId);
    }
  }
  
  void _showFullScreenAdAndNavigate(String chimeId) async {

      print('📱 Loading full-screen ad...');
      // Wait for ad to load before showing
      bool adShown = false;
      
      // Try to show ad every 500ms for up to 5 seconds
      for (int i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        
          print('✅ Interstitial ad is ready, showing now...');
            print('📱 Full-screen ad dismissed, navigating to edit chime');
            editChime(chimeId);
          adShown = true;
          break;
      }
      // If ad never showed after 5 seconds, navigate anyway
      if (!adShown) {
        print('⏰ Timeout: Ad never loaded, navigating to edit chime');
        editChime(chimeId);
      }
  }

  
  // Test background service functionality
  Future<void> testBackgroundService() async {
    print('🧪 Testing background service...');
    await BackgroundTestService.testBackgroundService();
  }
  
  // Show background service status
  Future<void> showBackgroundServiceStatus() async {
    print('🔍 Checking background service status...');
    await BackgroundTestService.showServiceStatus();
  }
}

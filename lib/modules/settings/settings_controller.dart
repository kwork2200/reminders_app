import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/services/sound_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/functions.dart';
import '../theme/theme_controller.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = StorageService();
  final notificationsEnabled = true.obs;
  final soundEnabled = true.obs;
  final vibrationEnabled = false.obs;
  final darkMode = true.obs;
  final RxDouble volume = 1.0.obs;
  final RxBool chimeOverMusic = false.obs;
  final RxBool chimeDuringCalls = false.obs;
  
  // Rating variables
  final RxInt selectedRating = 0.obs;
  final TextEditingController feedbackController = TextEditingController();
  
  // Feedback variables
  final RxString selectedFeedbackType = ''.obs;
  
  // Quiet hours variables
  final RxBool quietHoursEnabled = false.obs;
  final RxInt quietHoursStartHour = 23.obs; // 11 PM
  final RxInt quietHoursStartMinute = 0.obs;
  final RxBool quietHoursStartIsPM = true.obs;
  final RxInt quietHoursEndHour = 5.obs; // 5 AM
  final RxInt quietHoursEndMinute = 0.obs;
  final RxBool quietHoursEndIsPM = false.obs;
  
  String get currentThemeLabel => _themeCtrl.themeModeString.value;

  void toggleNotifications(bool val) => notificationsEnabled.value = val;
  void toggleSound(bool val) => soundEnabled.value = val;
  void toggleVibration(bool val) => vibrationEnabled.value = val;
  void setVolume(double val) {
    volume.value = val;
    // Update SoundService volume
    SoundService.setVolume(val);
    // Save volume to storage
    _saveVolumeSettings();
  }

  void _saveVolumeSettings() {
    final settings = {
      'volume': volume.value,
    };
    _storageService.saveSettings(settings);
  }

  void _loadVolumeSettings() {
    final settings = _storageService.getSettings();
    if (settings.isNotEmpty) {
      volume.value = settings['volume'] ?? 1.0;
      SoundService.setVolume(volume.value);
    }
  }

  void _loadQuietHoursSettings() {
    final settings = _storageService.getSettings();
    if (settings.isNotEmpty && settings['quietHours'] != null) {
      final quietHoursData = settings['quietHours'];
      quietHoursEnabled.value = quietHoursData['enabled'] ?? false;
      quietHoursStartHour.value = quietHoursData['startHour'] ?? 23;
      quietHoursStartMinute.value = quietHoursData['startMinute'] ?? 0;
      quietHoursStartIsPM.value = quietHoursData['startIsPM'] ?? true;
      quietHoursEndHour.value = quietHoursData['endHour'] ?? 5;
      quietHoursEndMinute.value = quietHoursData['endMinute'] ?? 0;
      quietHoursEndIsPM.value = quietHoursData['endIsPM'] ?? false;
    }
  }
  void toggleChimeOverMusic(bool val) => chimeOverMusic.value = val;
  void toggleChimeDuringCalls(bool val) => chimeDuringCalls.value = val;
  ThemeController get _themeCtrl => Get.find<ThemeController>();

  void openThemeSettings() {
    Get.bottomSheet(
      Material(
        color: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Choose Theme',
              style: TextStyle(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildThemeTile('System Default', Icons.settings_suggest_outlined),
            _buildThemeTile('Light', Icons.light_mode_outlined),
            _buildThemeTile('Dark', Icons.dark_mode_outlined),
            SizedBox(height: 24),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
  Widget _buildThemeTile(String label, IconData icon) {
    return Obx(() => ListTile(
      leading: Icon(icon, color: Get.isDarkMode ? Colors.white70 : Colors.black54),
      title: Text(
        label,
        style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
      ),
      trailing: _themeCtrl.themeModeString.value == label
          ? Icon(
              Icons.check_circle,
              color: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
            )
          : Icon(
              Icons.radio_button_unchecked,
              color: Get.isDarkMode ? Colors.white24 : Colors.black12,
            ),
      onTap: () {
        _themeCtrl.setTheme(label); // ✅ saves + rebuilds MyApp instantly
        Get.back();
      },
    ));
  }


  Future<void> _openWithAd(String route) async {
    final context = Get.context;
    if (context != null) {
      await showManagedInterstitialAd(context);
    }
    Get.toNamed(route);
  }

  void openQuietHours() {
    _openWithAd(Routes.QUIET_HOURS);
  }

  String formatTime(int hour, int minute, bool isPM) {
    String period = isPM ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
  void openPremium() {
    _openWithAd(Routes.UPGRADE);
  }
  void openFeedback() {
    selectedRating.value = 0;
    selectedFeedbackType.value = '';
    feedbackController.clear();

    _openWithAd(Routes.FEEDBACK);
  }
  void openOurApps() {
    _openWithAd(Routes.OUR_APPS);
  }
  
  void openApp(String appName) {
    // Here you would normally navigate to the app store for the specific app
    Get.snackbar(
      'Opening App',
      'Opening $appName in app store...',
      backgroundColor: const Color(0xFF2979FF),
      colorText: Colors.white,
      isDismissible: false,
    );
    
    // For demo purposes, we'll just show a snackbar
    // In a real app, you would use the appropriate app store URLs
    // Example: launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.reminders.reminder_app'));
  }
  void rateApp() {
    selectedRating.value = 0;
    feedbackController.clear();
    
    Get.dialog(
      Dialog(
        backgroundColor: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rate Reminders',
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your feedback helps us improve the app',
                style: TextStyle(
                  color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Star Rating
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => selectedRating.value = index + 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        index < selectedRating.value ? Icons.star : Icons.star_border,
                        color: const Color(0xFFFFD700),
                        size: 32,
                      ),
                    ),
                  );
                }),
              )),
              const SizedBox(height: 16),
              
              // Feedback text field (only show if rating is selected)
              Obx(() => selectedRating.value > 0
                  ? Column(
                      children: [
                        Text(
                          'Tell us more (optional)',
                          style: TextStyle(
                            color: Get.isDarkMode ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: feedbackController,
                          maxLines: 3,
                          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Your feedback...',
                            hintStyle: TextStyle(color: Get.isDarkMode ? Colors.white38 : Colors.black38),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF2979FF)),
                            ),
                            fillColor: Get.isDarkMode ? const Color(0xFF2C2C3E) : Colors.grey.shade50,
                            filled: true,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
              
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'Maybe Later',
                        style: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedRating.value > 0 ? submitRating : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  void submitRating() {
    final rating = selectedRating.value;
    final feedback = feedbackController.text.trim();
    
    // Here you would normally send the rating to your backend
    print('Rating submitted: $rating stars');
    if (feedback.isNotEmpty) {
      print('Feedback: $feedback');
    }
    
    Get.back();
    
    if (rating >= 4) {
      Get.defaultDialog(
        title: 'Thank You!',
        titleStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black87, fontSize: 18),
        middleText: 'We\'re glad you enjoy the app! Would you like to rate us on the app store?',
        middleTextStyle: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14),
        backgroundColor: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
        radius: 16,
        confirm: ElevatedButton(
          onPressed: () {
            Get.back();
            // Open app store (you'll need to implement this with your actual app URL)
            _openAppStore();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
          ),
          child: const Text('Rate Now', style: TextStyle(color: Colors.white)),
        ),
        cancel: OutlinedButton(
          onPressed: () => Get.back(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Get.isDarkMode ? const Color(0xFF3A3A4C) : Colors.grey.shade300),
          ),
          child: Text('No Thanks', style: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black54)),
        ),
      );
    } else {
      Get.snackbar(
        'Thank You!',
        'We appreciate your feedback and will work to improve the app.',
        backgroundColor: const Color(0xFF2979FF),
        colorText: Colors.white,
        isDismissible: false,
      );
    }
  }
  
  void _openAppStore() {
    final appStoreUrl = 'https://play.google.com/store/apps/details?id=com.reminders.reminder_app';
    Get.snackbar(
      'App Store',
      'Opening app store to rate the app...',
      backgroundColor: const Color(0xFF2979FF),
      colorText: Colors.white,
      isDismissible: false,
    );
  }
  
  bool canSubmitFeedback() {
    return selectedRating.value > 0 && 
           selectedFeedbackType.value.isNotEmpty && 
           feedbackController.text.trim().isNotEmpty;
  }
  
  void submitFeedback() {
    if (!canSubmitFeedback()) {
      Get.snackbar(
        'Incomplete Form',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        isDismissible: false,
      );
      return;
    }
    
    final feedback = {
      'rating': selectedRating.value,
      'type': selectedFeedbackType.value,
      'message': feedbackController.text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    Get.defaultDialog(
      title: 'Thank You!',
      titleStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black87, fontSize: 18),
      middleText: 'Your feedback has been submitted successfully. We appreciate your input and will use it to improve the app.',
      middleTextStyle: TextStyle(color: Get.isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14),
      backgroundColor: Get.isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
      radius: 16,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Get.isDarkMode ? const Color(0xFF2979FF) : const Color(0xFF1976D2),
        ),
        child: const Text('Done', style: TextStyle(color: Colors.white)),
      ),
    );
  }
  
  void toggleQuietHours(bool value) {
    quietHoursEnabled.value = value;
    _saveQuietHoursSettings();
  }
  
  Future<void> _saveQuietHoursSettings() async {
    final quietHoursData = {
      'enabled': quietHoursEnabled.value,
      'startHour': quietHoursStartHour.value,
      'startMinute': quietHoursStartMinute.value,
      'startIsPM': quietHoursStartIsPM.value,
      'endHour': quietHoursEndHour.value,
      'endMinute': quietHoursEndMinute.value,
      'endIsPM': quietHoursEndIsPM.value,
    };
    await _storageService.saveSettings({'quietHours': quietHoursData});
  }

  // ✅ FIXED: Navigate back FIRST, then show snackbar on the previous screen
  Future<void> saveQuietHours() async {
    try {
      await _saveQuietHoursSettings();

      // Go back BEFORE showing snackbar
      Get.back();

      // Small delay ensures the previous route is fully mounted
      await Future.delayed(const Duration(milliseconds: 300));

      Get.snackbar(
        'Settings Saved',
        'Quiet hours have been configured successfully',
        backgroundColor: const Color(0xFF00C853),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM, // More reliable than TOP after navigation
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        isDismissible: false,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save settings: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        isDismissible: false,
      );
    }
  }
  void shareApp() {
    final String appLink = 'https://play.google.com/store/apps/details?id=com.reminders.reminder_app';
    final String shareText = 'Check out Reminders - Perfect time management with beautiful chimes!\n\n$appLink';

    Share.share(
      shareText,
      subject: 'Reminders App',
    ).catchError((error) {
      Get.snackbar(
        'Share Error',
        'Could not share the app. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        isDismissible: false,
      );
    });
  }

  void openPrivacyPolicy() {
    _openWithAd(Routes.PRIVACY_POLICY);
  }

  void openTerms() {
    _openWithAd(Routes.TERMS);
  }

  void openAbout() {
    _openWithAd(Routes.ABOUT_US);
  }

  void openContact() {
    _openWithAd(Routes.CONTACT_US);
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      titleStyle: const TextStyle(color: Colors.white),
      middleText: 'Are you sure you want to logout?',
      middleTextStyle: const TextStyle(color: Colors.white70),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.white,
      buttonColor: const Color(0xFF2979FF),
      // cancelTextColor: Colors.white70,
      onConfirm: () async {
        Get.back();
        Get.offAllNamed('/onboarding');
        await Future.delayed(const Duration(milliseconds: 300));
        Get.snackbar(
          'Logged Out',
          'You have been logged out',
          isDismissible: false,
        );
      },
    );
  }

  void goBack() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    _loadVolumeSettings();
    _loadQuietHoursSettings();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}

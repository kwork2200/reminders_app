import 'package:get/get.dart';
import '../../data/firebase/admob_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    print('🚀 SplashController: Starting splash screen');

    // Load app open ad and wait for it
    _loadAppOpenAdAndWait();
  }

  void _loadAppOpenAdAndWait() async {
    print('📱 Loading app open ad...');

    try {
      // Load the ad with timeout
      await AdMobService().loadAppOpenAd().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('⏰ Ad loading timeout, proceeding with navigation');
        },
      );
    } catch (e) {
      print('❌ Error loading app open ad: $e');
    }

    // Wait for splash screen minimum time (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    print('📱 Splash time completed, checking ad availability...');
    _showAppOpenAdAndNavigate();
  }
  
  void _showAppOpenAdAndNavigate() {
    print('📱 Checking if app open ad is available...');

    // Add safety timeout to prevent infinite splash (reduced to 5 seconds)
    Future.delayed(const Duration(seconds: 5), () {
      if (Get.currentRoute == '/splash') {
        print('⏰ Safety timeout: Force navigating to onboarding');
        try {
          Get.offNamed('/onboarding');
        } catch (e) {
          print('❌ Error during safety navigation: $e');
        }
      }
    });

    // Show app open ad if available, then navigate
    try {
      if (AdMobService().isAppOpenAdAvailable) {
        print('✅ App open ad is available, showing ad...');
        AdMobService().showAppOpenAd();

        // Navigate after a longer delay to allow ad to display
        Future.delayed(const Duration(seconds: 1), () {
          print('📱 Navigating to onboarding after ad display');
          try {
            Get.offNamed('/onboarding');
          } catch (e) {
            print('❌ Error during navigation after ad: $e');
          }
        });
      } else {
        print('❌ No app open ad available, navigating directly');
        Get.offNamed('/onboarding');
      }
    } catch (e) {
      print('❌ Error in _showAppOpenAdAndNavigate: $e');
      // Ensure navigation happens even if there's an error
      try {
        Get.offNamed('/onboarding');
      } catch (navError) {
        print('❌ Critical error during fallback navigation: $navError');
      }
    }
  }
}

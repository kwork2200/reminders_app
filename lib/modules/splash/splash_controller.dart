import 'package:get/get.dart';
import '../../ads/app_open_ad_manager.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startSplashFlow();
  }

  Future<void> _startSplashFlow() async {
    await Future.delayed(const Duration(seconds: 3));

    if (Get.currentRoute != '/splash') return;

    final adManager = AppOpenAdManager.instance;

    // Give the ad preloaded at startup a short chance to finish loading
    var waitedMs = 0;
    while (!adManager.isAdAvailable && adManager.isLoading && waitedMs < 2000) {
      await Future.delayed(const Duration(milliseconds: 200));
      waitedMs += 200;
    }

    Get.offNamed('/onboarding');

    // Let the onboarding transition settle, then cover it with the app open ad
    await Future.delayed(const Duration(milliseconds: 400));

    adManager.showAdIfAvailable();
  }
}

import 'package:flutter/material.dart';
import 'package:reminders_app/ads/interstitial_ad_manager.dart';
import 'package:reminders_app/ads/qureka_interstitial.dart';
import '../services/ad_service.dart';
import '../services/fb_ad_service.dart';
import '../services/remote_config_service.dart';

Future<bool> showManagedInterstitialAd(BuildContext context) async {
  try {
    debugPrint('🎬 [SHOW AD] showManagedInterstitialAd called');

    final bool googleEnabled = AdService.instance.shouldShowInterstitialAds;
    final bool facebookEnabled = FbAdService.instance.shouldShowInterstitialAds;
    final bool thirdPartyEnabled =
        RemoteConfigService.instance.showThirdPartyInterstitialAds && ENABLE_THIRD_PARTY_ADS;

    debugPrint('🔍 [SHOW AD] Networks: Google=$googleEnabled, Facebook=$facebookEnabled, '
        'ThirdParty=$thirdPartyEnabled, Frequency=${AdService.instance.interstitialAdFrequency}');

    if (!googleEnabled && !facebookEnabled) {
      if (!thirdPartyEnabled) {
        debugPrint('🚫 [SHOW AD] Every ad network is disabled');
        return false;
      }

      debugPrint('🎯 [SHOW AD] Both Google & Facebook disabled - checking third-party frequency');
      final shouldShow = await InterstitialAdManager.instance.showAdIfAvailable();
      if (shouldShow && context.mounted) {
        await showQurekaInterstitialAd(context);
        return true;
      }
      return false;
    }

    final shouldShow = await InterstitialAdManager.instance.showAdIfAvailable();
    debugPrint('📊 [SHOW AD] Ad shown: $shouldShow');
    return shouldShow;
  } catch (e) {
    debugPrint('❌ [SHOW AD] Error in showManagedInterstitialAd: $e');
    return false;
  }
}

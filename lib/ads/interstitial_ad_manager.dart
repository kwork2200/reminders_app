import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';
import '../services/fb_ad_service.dart';
import '../services/remote_config_service.dart';

/// Manager for Interstitial Ads with real-time Remote Config updates.
/// Every ad opportunity (tap, back, screen change) counts toward the
/// Firebase-controlled frequency (`reminders_interstitial_ad_frequency`).
class InterstitialAdManager {
  static InterstitialAdManager? _instance;
  static InterstitialAdManager get instance => _instance ??= InterstitialAdManager._();

  InterstitialAdManager._() {
    _configSubscription = RemoteConfigService.instance.configUpdates.listen((_) {
      _handleConfigUpdate();
    });
  }

  InterstitialAd? _interstitialAd;
  bool _isAdLoading = false;
  bool _isFbAdLoaded = false;
  int _actionCounter = 0;
  StreamSubscription? _configSubscription;

  int get _adFrequency => AdService.instance.interstitialAdFrequency;

  void _handleConfigUpdate() {
    final shouldShow = AdService.instance.shouldShowInterstitialAds;
    final shouldShowFb = FbAdService.instance.shouldShowInterstitialAds;

    if (!shouldShow && !shouldShowFb) {
      print('🚫 All interstitial ads disabled via Remote Config');
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isAdLoading = false;
      _isFbAdLoaded = false;
    } else {
      print('📢 Interstitial ads enabled via Remote Config');
      if (shouldShowFb && !_isFbAdLoaded) {
        _loadFacebookAd();
      }
      if (shouldShow && _interstitialAd == null && !_isAdLoading) {
        loadAd();
      }
    }
  }

  /// Load the interstitial ad - Prioritize Google Ads first, then Facebook as fallback
  Future<void> loadAd() async {
    debugPrint('🔧 [AD MANAGER] Frequency from Firebase: $_adFrequency');

    if (AdService.instance.shouldShowInterstitialAds) {
      if (_isAdLoading || _interstitialAd != null) {
        print('⏭️ Google ad already loading or loaded');
      } else {
        _loadGoogleAd();
      }
    } else {
      print('⏭️ Google ads disabled via Remote Config');
    }

    if (FbAdService.instance.shouldShowInterstitialAds) {
      if (!_isFbAdLoaded) {
        _loadFacebookAd();
      } else {
        print('⏭️ Facebook ad already loaded');
      }
    } else {
      print('⏭️ Facebook ads disabled via Remote Config');
    }
  }

  Future<void> _loadGoogleAd() async {
    if (_isAdLoading || _interstitialAd != null) return;
    _isAdLoading = true;

    try {
      await InterstitialAd.load(
        adUnitId: AdService.instance.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isAdLoading = false;
            print('✅ Google Interstitial ad loaded');
          },
          onAdFailedToLoad: (error) {
            print('❌ Google Interstitial ad failed to load: $error');
            _isAdLoading = false;
            _interstitialAd = null;
            if (FbAdService.instance.shouldShowInterstitialAds && !_isFbAdLoaded) {
              print('🔄 Google ads failed, loading Facebook ads as fallback');
              _loadFacebookAd();
            }
          },
        ),
      );
    } catch (e) {
      print('❌ Error loading Google interstitial ad: $e');
      _isAdLoading = false;
      if (FbAdService.instance.shouldShowInterstitialAds && !_isFbAdLoaded) {
        print('🔄 Google ads error, loading Facebook ads as fallback');
        _loadFacebookAd();
      }
    }
  }

  Future<void> _loadFacebookAd() async {
    if (_isFbAdLoaded) return;
    try {
      final loaded = await FbAdService.instance.loadInterstitialAd();
      _isFbAdLoaded = loaded;
      if (loaded) {
        print('✅ Facebook Interstitial ad loaded');
      }
    } catch (e) {
      print('❌ Error loading Facebook interstitial ad: $e');
      _isFbAdLoaded = false;
    }
  }

  /// Counts one ad opportunity and shows an interstitial only when the
  /// Firebase frequency is reached.
  /// Priority: Google Ads, then Facebook, then third-party (returns true).
  Future<bool> showAdIfAvailable() async {
    try {
      final int frequency = _adFrequency;
      final bool googleEnabled = AdService.instance.shouldShowInterstitialAds;
      final bool facebookEnabled = FbAdService.instance.shouldShowInterstitialAds;
      final bool thirdPartyEnabled = RemoteConfigService.instance.showThirdPartyInterstitialAds;

      if (!googleEnabled && !facebookEnabled && !thirdPartyEnabled) {
        debugPrint('🚫 [AD] All interstitial networks disabled');
        return false;
      }

      _actionCounter++;
      debugPrint('🔢 [AD] Opportunity $_actionCounter / frequency $frequency');

      if (_actionCounter < frequency) {
        debugPrint('⏭️ [AD] Waiting for frequency threshold');
        return false;
      }

      debugPrint('📺 [AD] Frequency reached (counter: $_actionCounter, frequency: $frequency)');

      if (!googleEnabled && !facebookEnabled) {
        debugPrint('✅ [AD] Caller should show third-party interstitial');
        _actionCounter = 0;
        return true;
      }

      // Google disabled: only Facebook is available.
      if (!googleEnabled) {
        if (facebookEnabled && _isFbAdLoaded) {
          print('📺 [AD] Showing Facebook interstitial (Google disabled)');
          try {
            await FbAdService.instance.showInterstitialAd();
            _isFbAdLoaded = false;
            _actionCounter = 0;
            _loadFacebookAd();
            return true;
          } catch (e) {
            debugPrint('❌ [AD] Facebook ad error: $e');
            _isFbAdLoaded = false;
            return false;
          }
        }
        print('⚠️ [AD] Facebook ad not ready, loading...');
        await loadAd();
        return false;
      }

      // Google enabled: try Google first.
      if (_interstitialAd != null) {
        print('📺 [AD] Showing Google interstitial');
        final completer = Completer<void>();
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            debugPrint('✅ [AD] Google ad dismissed');
            ad.dispose();
            _interstitialAd = null;
            _actionCounter = 0;
            loadAd();
            if (!completer.isCompleted) completer.complete();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            print('❌ [AD] Failed to show Google interstitial: $error');
            ad.dispose();
            _interstitialAd = null;
            if (facebookEnabled && _isFbAdLoaded) {
              print('🔄 [AD] Falling back to Facebook ad');
              FbAdService.instance.showInterstitialAd().then((_) {
                _isFbAdLoaded = false;
                _actionCounter = 0;
                _loadFacebookAd();
              }).catchError((e) {
                print('❌ Facebook fallback also failed: $e');
                _isFbAdLoaded = false;
              });
            }
            loadAd();
            if (!completer.isCompleted) completer.complete();
          },
        );
        await _interstitialAd!.show();
        await completer.future;
        return true;
      }

      // Google not loaded: use Facebook fallback if available.
      if (facebookEnabled && _isFbAdLoaded) {
        print('📺 [AD] Showing Facebook interstitial (Google not ready)');
        try {
          await FbAdService.instance.showInterstitialAd();
          _isFbAdLoaded = false;
          _actionCounter = 0;
          loadAd();
          return true;
        } catch (e) {
          debugPrint('❌ [AD] Facebook ad error: $e');
          _isFbAdLoaded = false;
          return false;
        }
      }

      print('⚠️ [AD] No ad ready (Google: $googleEnabled, Facebook: $facebookEnabled), loading...');
      await loadAd();
      return false;
    } catch (e) {
      debugPrint('❌ [AD] Critical error in showAdIfAvailable: $e');
      return false;
    }
  }

  void dispose() {
    _configSubscription?.cancel();
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isFbAdLoaded = false;
    FbAdService.instance.destroyInterstitialAd();
  }
}

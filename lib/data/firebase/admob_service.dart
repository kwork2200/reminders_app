// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'firebase_service.dart';
//
// class AdMobService {
//   static final AdMobService _instance = AdMobService._internal();
//   factory AdMobService() => _instance;
//   AdMobService._internal();
//
//   // Ad Unit IDs (using test IDs for debugging)
//   static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
//   static const String appOpenAdUnitId = 'ca-app-pub-3940256099942544/9257395921';
//   static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
//   static const String nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';
//
//   BannerAd? bannerAd;
//   bool _isBannerAdLoaded = false;
//
//   // Callback for banner ad load status
//   VoidCallback? onBannerAdLoaded;
//
//   AppOpenAd? _appOpenAd;
//   bool _isShowingAd = false;
//   bool _isLoadingAd = false;
//
//   // Interstitial Ad
//   InterstitialAd? _interstitialAd;
//   bool _isInterstitialAdLoaded = false;
//
//   // Native Ad
//   NativeAd? nativeAd;
//   bool isNativeAdLoaded = false;
//
//   // Initialize Mobile Ads SDK
//   Future<void> initialize() async {
//     await MobileAds.instance.initialize();
//
//     // Initialize Firebase and fetch ads config
//     await FirebaseService().fetchAdsConfig();
//
//     // Start listening for real-time updates
//     FirebaseService().onAdsConfigChanged = (bool isEnabled) {
//       print('AdMob: Ads config changed - Enabled: $isEnabled');
//       if (!isEnabled) {
//         // If ads are disabled, dispose all ads
//         disposeAllAds();
//       }
//     };
//     FirebaseService().startAdsConfigListener();
//   }
//
//   // Check if ads are enabled from Firebase
//   bool get areAdsEnabled {
//     final enabled = FirebaseService().isAdsEnabled;
//     print('📱 AdMob: areAdsEnabled = $enabled');
//     return enabled;
//   }
//
//   // Dispose all ads
//   void disposeAllAds() {
//     print('AdMob: Disposing all ads due to config change');
//     disposeBannerAd();
//     _appOpenAd?.dispose();
//     _appOpenAd = null;
//     _interstitialAd?.dispose();
//     _interstitialAd = null;
//     _isInterstitialAdLoaded = false;
//     nativeAd?.dispose();
//     nativeAd = null;
//     isNativeAdLoaded = false;
//   }
//
//   // Create Banner Ad
//   void createBannerAd() {
//     print('🎯 createBannerAd() called');
//     print('📱 areAdsEnabled: $areAdsEnabled');
//
//     if (!areAdsEnabled) {
//       print('🚫 Ads are disabled, skipping banner ad creation');
//       return;
//     }
//
//     print('🎯 Creating banner ad with unit ID: $bannerAdUnitId');
//     bannerAd = BannerAd(
//       adUnitId: bannerAdUnitId,
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (Ad ad) {
//           print('✅ Banner ad loaded successfully!');
//           _isBannerAdLoaded = true;
//           onBannerAdLoaded?.call();
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           print('❌ Banner ad failed to load: ${error.message}');
//           print('❌ Error code: ${error.code}');
//           print('❌ Error domain: ${error.domain}');
//           ad.dispose();
//           _isBannerAdLoaded = false;
//         },
//         onAdOpened: (Ad ad) {
//           print('📱 Banner ad opened');
//         },
//         onAdClosed: (Ad ad) {
//           print('📱 Banner ad closed');
//         },
//       ),
//     );
//     bannerAd?.load();
//     print('🔄 Banner ad loading...');
//   }
//
//   // Get Banner Ad Widget
//   Widget getBannerAdWidget() {
//     print('📱 getBannerAdWidget() called');
//     print('📱 bannerAd is null: ${bannerAd == null}');
//     print('📱 _isBannerAdLoaded: $_isBannerAdLoaded');
//
//     if (bannerAd != null && _isBannerAdLoaded) {
//       print('✅ Returning banner ad widget');
//       return AdWidget(ad: bannerAd!);
//     } else {
//       print('❌ No banner ad available, returning empty widget');
//       return const SizedBox.shrink();
//     }
//   }
//
//   // Check if interstitial ad is loaded
//   bool get isInterstitialAdLoaded => _isInterstitialAdLoaded;
//
//   // Dispose Banner Ad
//   void disposeBannerAd() {
//     bannerAd?.dispose();
//     bannerAd = null;
//     _isBannerAdLoaded = false;
//   }
//
//   // Load App Open Ad
//   Future<void> loadAppOpenAd() async {
//     if (!areAdsEnabled) {
//       print('🚫 Ads are disabled, skipping app open ad loading');
//       return;
//     }
//
//     if (_isLoadingAd || _appOpenAd != null) {
//       print('📱 App open ad already loading or loaded');
//       return;
//     }
//
//     print('🎯 Loading app open ad with unit ID: $appOpenAdUnitId');
//     _isLoadingAd = true;
//
//     final completer = Completer<void>();
//
//     AppOpenAd.load(
//       adUnitId: appOpenAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (AppOpenAd ad) {
//           print('✅ App open ad loaded successfully!');
//           _appOpenAd = ad;
//           _isLoadingAd = false;
//           completer.complete();
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('❌ App open ad failed to load: ${error.message}');
//           _isLoadingAd = false;
//           completer.complete();
//         },
//       ),
//     );
//
//     await completer.future;
//   }
//
//   void loadInterstitialAd() {
//     if (!areAdsEnabled) {
//       print('🚫 Ads are disabled, skipping interstitial ad loading');
//       return;
//     }
//
//     print('🎯 Loading interstitial ad with unit ID: $interstitialAdUnitId');
//     InterstitialAd.load(
//       adUnitId: interstitialAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           print('✅ Interstitial ad loaded successfully!');
//           _interstitialAd = ad;
//           _isInterstitialAdLoaded = true;
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('❌ Interstitial ad failed to load: ${error.message}');
//           _isInterstitialAdLoaded = false;
//         },
//       ),
//     );
//   }
//
//   // Show Interstitial Ad
//   void showInterstitialAd({VoidCallback? onAdDismissed}) {
//     if (!areAdsEnabled) {
//       print('🚫 Ads are disabled, skipping interstitial ad show');
//       onAdDismissed?.call();
//       return;
//     }
//
//     if (_interstitialAd == null) {
//       print('⚠️ No interstitial ad available, loading new one...');
//       loadInterstitialAd();
//       return;
//     }
//
//     print('📱 Showing interstitial ad');
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) {
//         print('✅ Interstitial ad showed');
//       },
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('📱 Interstitial ad dismissed');
//         ad.dispose();
//         _interstitialAd = null;
//         _isInterstitialAdLoaded = false;
//         loadInterstitialAd(); // Load next ad
//         onAdDismissed?.call(); // Execute callback
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('❌ Interstitial ad failed to show: ${error.message}');
//         ad.dispose();
//         _interstitialAd = null;
//         _isInterstitialAdLoaded = false;
//         loadInterstitialAd(); // Load next ad
//         onAdDismissed?.call(); // Execute callback even on failure
//       },
//     );
//
//     _interstitialAd!.show();
//   }
//
//   // Show App Open Ad
//   void showAppOpenAd() {
//     if (!areAdsEnabled) {
//       print('🚫 Ads are disabled, skipping app open ad show');
//       return;
//     }
//
//     if (_appOpenAd == null || _isShowingAd) {
//       print('⚠️ No app open ad available or already showing');
//       return;
//     }
//
//     print('📱 Showing app open ad');
//     _isShowingAd = true;
//     _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (AppOpenAd ad) {
//         print('✅ App open ad showed');
//       },
//       onAdDismissedFullScreenContent: (AppOpenAd ad) {
//         print('📱 App open ad dismissed');
//         ad.dispose();
//         _appOpenAd = null;
//         _isShowingAd = false;
//         loadAppOpenAd(); // Load next ad
//       },
//       onAdFailedToShowFullScreenContent: (AppOpenAd ad, AdError error) {
//         print('❌ App open ad failed to show: ${error.message}');
//         ad.dispose();
//         _appOpenAd = null;
//         _isShowingAd = false;
//         loadAppOpenAd(); // Load next ad
//       },
//     );
//
//     _appOpenAd!.show();
//   }
//
//   // Check if App Open Ad is available
//   bool get isAppOpenAdAvailable => _appOpenAd != null && !_isShowingAd;
//
//   // Dispose all ads
//   void dispose() {
//     disposeBannerAd();
//     _appOpenAd?.dispose();
//     _appOpenAd = null;
//     nativeAd?.dispose();
//     nativeAd = null;
//   }
//
//   // Load Native Ad
//   void loadNativeAd() {
//     if (!areAdsEnabled) {
//       print('🚫 Ads are disabled, skipping native ad loading');
//       return;
//     }
//
//     print('🎯 Loading native ad with unit ID: $nativeAdUnitId');
//     nativeAd = NativeAd(
//       adUnitId: nativeAdUnitId,
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (Ad ad) {
//           print('✅ Native ad loaded successfully!');
//           isNativeAdLoaded = true;
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError error) {
//           print('❌ Native ad failed to load: ${error.message}');
//           ad.dispose();
//           isNativeAdLoaded = false;
//         },
//         onAdOpened: (Ad ad) {
//           print('📱 Native ad opened');
//         },
//         onAdClosed: (Ad ad) {
//           print('📱 Native ad closed');
//         },
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         templateType: TemplateType.medium,
//         mainBackgroundColor: Colors.white,
//         callToActionTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.white,
//           backgroundColor: Colors.blue,
//           style: NativeTemplateFontStyle.bold,
//           size: 10,
//         ),
//         primaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.black,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.bold,
//           size: 10,        ),
//         secondaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.grey,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.normal,
//           size: 10,        ),
//         tertiaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.grey,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.normal,
//           size: 10,        ),
//       ),
//     );
//     nativeAd?.load();
//     print('🔄 Native ad loading...');
//   }
//
//   // Get Native Ad Widget
//   Widget getNativeAdWidget() {
//     if (nativeAd != null && isNativeAdLoaded) {
//       return AdWidget(ad: nativeAd!);
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
//
//   // Dispose Native Ad
//   void disposeNativeAd() {
//     nativeAd?.dispose();
//     nativeAd = null;
//     isNativeAdLoaded = false;
//   }
// }

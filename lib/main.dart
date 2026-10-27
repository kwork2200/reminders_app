import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reminders_app/ads/app_open_ad_manager.dart';
import 'package:reminders_app/ads/interstitial_ad_manager.dart';
import 'package:reminders_app/services/app_lifecycle_service.dart';
import 'package:reminders_app/services/remote_config_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'data/services/storage_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/background_service.dart';
import 'data/services/alarm_scheduler_service.dart';
import 'data/services/app_killed_notification_service.dart';
import 'data/services/permission_service.dart';
import 'data/firebase/admob_service.dart';
import 'modules/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await MobileAds.instance.initialize();
  print('✅ Google Mobile Ads initialized');

  await RemoteConfigService.instance.initialize();

  print('🔄 Preloading App Open Ad at app startup...');
  AppOpenAdManager.instance.loadAd();

  print('🔄 Preloading Interstitial Ad at app startup...');
  InterstitialAdManager.instance.loadAd();

  Get.put(AppLifecycleService(), permanent: true);


  await StorageService().init();

  final themeController = Get.put(ThemeController());
  await themeController.loadTheme(); // Ensure theme is loaded before app starts

  _initializeBackgroundServices();

  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MyApp();
      },
    ),
  );
}

void _initializeBackgroundServices() async {
  try {
    final permissionService = PermissionService();
    await permissionService.requestAllPermissions();

    await NotificationService().initialize();

    await AlarmSchedulerService().initialize();
    await AlarmSchedulerService().scheduleAllChimes();
    debugPrint('✅ Alarm scheduler initialized with exact alarms');

    await AppKilledNotificationService().initialize();
    await AppKilledNotificationService().scheduleAllChimes();
    debugPrint('✅ App-killed notification service initialized');

    await BackgroundService().initialize();
    await BackgroundService().startService();
    debugPrint('✅ Background service started');
  } catch (e) {
    debugPrint('Error initializing background services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) => GetMaterialApp(
        title: 'Reminders',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: controller.themeMode,
        initialRoute: Routes.SPLASH,
        getPages: AppPages.routes,
      ),
    );
  }
}

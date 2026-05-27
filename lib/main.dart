import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize essential services only
  await StorageService().init();

  // Initialize theme controller
  final themeController = Get.put(ThemeController());
  await themeController.loadTheme(); // Ensure theme is loaded before app starts

  // Initialize non-blocking services in background
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
    // Request required permissions first (Android 12+ needs exact alarm permission)
    final permissionService = PermissionService();
    await permissionService.requestAllPermissions();

    // Initialize notification service
    await NotificationService().initialize();

    // Initialize alarm scheduler for exact alarms (works when app killed)
    await AlarmSchedulerService().initialize();
    await AlarmSchedulerService().scheduleAllChimes();
    debugPrint('✅ Alarm scheduler initialized with exact alarms');

    // Initialize app-killed notification service for extra reliability
    await AppKilledNotificationService().initialize();
    await AppKilledNotificationService().scheduleAllChimes();
    debugPrint('✅ App-killed notification service initialized');

    // Initialize background service for foreground monitoring
    await BackgroundService().initialize();
    await BackgroundService().startService();
    debugPrint('✅ Background service started');

    // Initialize AdMob service (non-blocking)
    AdMobService().initialize();
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
        title: 'Hourly Chime',
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

import 'package:get/get.dart';
import '../modules/theme/theme_controller.dart';
import 'app_routes.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';
import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/add_chime/add_chime_binding.dart';
import '../modules/add_chime/add_chime_view.dart';
import '../modules/settings/settings_binding.dart';
import '../modules/settings/settings_view.dart';
import '../modules/settings/privacy_policy_view.dart';
import '../modules/settings/terms_view.dart';
import '../modules/settings/about_view.dart';
import '../modules/settings/contact_view.dart';
import '../modules/settings/our_apps_view.dart';
import '../modules/settings/feedback_view.dart';
import '../modules/settings/quiet_hours_view.dart';
import '../modules/theme/theme_view.dart';
import '../modules/upgrade/upgrade_binding.dart';
import '../modules/upgrade/upgrade_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),

    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.ADD_CHIME,
      page: () => const AddChimeView(),
      binding: AddChimeBinding(),
    ),

    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.UPGRADE,
      page: () => const UpgradeView(),
      binding: UpgradeBinding(),
    ),

    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.TERMS,
      page: () => const TermsView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.ABOUT_US,
      page: () => const AboutView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.CONTACT_US,
      page: () => const ContactView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.OUR_APPS,
      page: () => const OurAppsView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.FEEDBACK,
      page: () => const FeedbackView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.QUIET_HOURS,
      page: () => const QuietHoursView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.THEME,
      page: () => const ThemeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ThemeController());
      }),
    ),

  ];
}

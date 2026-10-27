import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class UpgradeController extends GetxController {
  final selectedPlan = 'yearly'.obs;

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  void upgrade() async {
    Get.back();
    await Future.delayed(const Duration(milliseconds: 300));
    Get.snackbar(
      'Coming Soon',
      'Premium upgrade is not available yet. Stay tuned!',
      backgroundColor: const Color(0xFF2979FF),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: false,
    );
  }

  void openTerms() {
    Get.toNamed(Routes.TERMS);
  }

  void openPrivacy() {
    Get.toNamed(Routes.PRIVACY_POLICY);
  }

  void goBack() {
    Get.back();
  }
}

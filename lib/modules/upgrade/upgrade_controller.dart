import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpgradeController extends GetxController {
  final selectedPlan = 'yearly'.obs;

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  void upgrade() {
    Get.snackbar(
      'Upgrade Successful',
      'Welcome to Premium! Enjoy all features.',
      backgroundColor: const Color(0xFF2979FF),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  void openTerms() {
    Get.snackbar('Terms', 'Terms of Service would open here');
  }

  void openPrivacy() {
    Get.snackbar('Privacy', 'Privacy Policy would open here');
  }

  void goBack() {
    Get.back();
  }
}

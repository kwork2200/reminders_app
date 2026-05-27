import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void skip() {
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

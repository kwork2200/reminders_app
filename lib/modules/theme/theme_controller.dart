import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxString themeModeString = 'System Default'.obs;

  ThemeMode get themeMode {
    switch (themeModeString.value) {
      case 'Light':
        return ThemeMode.light;
      case 'Dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Theme is loaded in main.dart before app starts
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode') ?? 'Dark';
    themeModeString.value = saved;
    update();
  }

  Future<void> setTheme(String mode) async {
    themeModeString.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode);
    update();
  }
}
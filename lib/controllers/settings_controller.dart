import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  SettingsController();

  SharedPreferences? prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    _loadPreferences();
  }

  savePreferences(String key, String value) {
    prefs!.setString(key, value);
  }

  _loadPreferences() async {
    final theme = prefs!.getString('theme') ?? 'light';
    final language = prefs!.getString('language') ?? 'en';
    Get.changeThemeMode(theme == 'dark' ? ThemeMode.dark : ThemeMode.light);
    Get.updateLocale(Locale(language));
  }
}

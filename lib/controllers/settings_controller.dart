import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  SettingsController();

  SharedPreferences? prefs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  savePreferences(String key, String value) {
    prefs!.setString(key, value);
  }
}

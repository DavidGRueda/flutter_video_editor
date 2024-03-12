import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_video_editor/shared/translations/translation_keys.dart' as translations;

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _settingsBar(context),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translations.settingsPageThemeTitle.tr, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                  },
                  icon: Icon(
                    Icons.brightness_6,
                    color: Colors.white,
                  ),
                  label: Text(
                    translations.settingsPageThemeButton.tr,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Theme.of(context).primaryColorLight, width: 2.0),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _settingsBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Don't show the leading button
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onBackground),
              onPressed: () => Get.back(),
              splashRadius: 24,
            ),
            SizedBox(width: 8),
            Text(translations.settingsPageTitle.tr, style: Theme.of(context).textTheme.titleLarge)
          ],
        ),
      ),
    );
  }
}

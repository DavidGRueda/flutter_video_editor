import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_editor/firebase_options.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/themes.dart';
import 'package:flutter_video_editor/shared/translations/messages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final [themeMode, locale] = await _initializePreferences();
  runApp(MyApp(themeMode: themeMode, locale: locale));
}

Future<List<dynamic>> _initializePreferences() async {
  final prefs = await SharedPreferences.getInstance();
  final theme = prefs.getString('theme');
  final language = prefs.getString('language') ?? 'en';
  final themeMode = theme == null
      ? ThemeMode.system
      : theme == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light;
  final locale = Locale(language);

  return [themeMode, locale];
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.themeMode, required this.locale}) : super(key: key);

  final ThemeMode themeMode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      title: 'LiteEdit',
      translations: Messages(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      themeMode: themeMode,
      theme: appThemeData,
      darkTheme: appThemeDataDark,
      debugShowCheckedModeBanner: false,
    );
  }
}

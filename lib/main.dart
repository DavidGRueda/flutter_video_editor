import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_editor/firebase_options.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/core/themes.dart';
import 'package:flutter_video_editor/shared/translations/messages.dart';
import 'package:get/get.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return GetMaterialApp(
      title: 'LiteEdit',
      translations: Messages(),
      locale: const Locale('es', 'ES'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      theme: appThemeData,
      darkTheme: appThemeDataDark,
      debugShowCheckedModeBanner: false,
    );
  }
}

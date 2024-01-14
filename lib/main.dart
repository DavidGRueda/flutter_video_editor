import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_editor/firebase_options.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/themes.dart';
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
    return GetMaterialApp(
      title: 'Video Editor',
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      theme: appThemeData,
      debugShowCheckedModeBanner: false,
    );
  }
}

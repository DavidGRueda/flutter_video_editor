import 'package:flutter/material.dart';
import 'package:flutter_video_editor/routes/app_pages.dart';
import 'package:flutter_video_editor/shared/themes.dart';
import 'package:get/get.dart';

void main() {
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
    );
  }
}

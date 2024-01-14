// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_video_editor/pages/home/home.dart';
import 'package:get/route_manager.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.NEW_PROJECT,
      page: () => const Scaffold(),
    ),
    GetPage(
      name: Routes.EDITOR,
      page: () => const Scaffold(),
    ),
  ];
}

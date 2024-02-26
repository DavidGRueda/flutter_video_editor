// ignore_for_file: constant_identifier_names

import 'package:flutter_video_editor/pages/editor/editor_page.dart';
import 'package:flutter_video_editor/pages/export/export_page.dart';
import 'package:flutter_video_editor/pages/home/home.dart';
import 'package:flutter_video_editor/pages/project/project_page.dart';
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
      page: () => ProjectPage(),
    ),
    GetPage(
      name: Routes.EDITOR,
      page: () => EditorPage(),
    ),
    GetPage(
      name: Routes.EXPORT,
      page: () => ExportPage(),
    ),
  ];
}

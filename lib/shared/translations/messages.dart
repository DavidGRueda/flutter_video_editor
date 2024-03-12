import 'package:flutter_video_editor/shared/translations/languages/en.dart';
import 'package:flutter_video_editor/shared/translations/languages/es.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': En().messages,
        'es_ES': Es().messages,
      };
}

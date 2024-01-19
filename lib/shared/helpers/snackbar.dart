import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbar(Color color, String title, String message, IconData icon) {
  Get.snackbar(
    '',
    '',
    titleText: Text(title, style: Theme.of(Get.context!).textTheme.titleSmall),
    messageText: Text(message, style: Theme.of(Get.context!).textTheme.bodySmall),
    duration: Duration(seconds: 2),
    backgroundColor: Theme.of(Get.context!).colorScheme.background,
    icon: Icon(icon, color: color, size: 32.0),
    borderRadius: 16.0,
    shouldIconPulse: false,
    margin: EdgeInsets.all(8.0),
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
    borderColor: color,
    borderWidth: 1.0,
  );
}

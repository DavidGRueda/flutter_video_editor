import 'package:flutter/material.dart';

class EditOption {
  final String title;
  final IconData icon;
  final Function onPressed;

  EditOption({required this.title, required this.icon, required this.onPressed});
}

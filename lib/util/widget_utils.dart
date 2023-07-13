import 'package:flutter/material.dart';

class WidgetUtils {
  static PreferredSize getCustomAppBar(String title, {bool titleCenter = false}) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: AppBar(
          centerTitle: titleCenter,
          title: Text(title, style: const TextStyle(fontSize: 12)),
        ));
  }
}

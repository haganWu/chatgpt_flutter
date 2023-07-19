import 'package:flutter/material.dart';

class WidgetUtils {
  static PreferredSize getCustomAppBar(String title, {String? subTitle, bool titleCenter = false}) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: AppBar(
          centerTitle: titleCenter,
          title: subTitle == null
              ? Text(title, style: const TextStyle(fontSize: 12))
              : Column(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 10)),
                    Text(subTitle, style: const TextStyle(fontSize: 8)),
                  ],
                ),
        ));
  }
}

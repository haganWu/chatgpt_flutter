import 'package:flutter/material.dart';
import 'package:login_sdk/util/padding_extension.dart';

typedef OnClickCallback = Function();

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

  static PreferredSize getMyPageAppBar(double statusHeight, Color color, String icon, String userName, String userId, OnClickCallback clickCallback) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(90),
      child: Container(
        decoration: BoxDecoration(color: color),
        padding: EdgeInsets.only(left: 8, top: (12 + statusHeight), right: 8, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                getCircleAvatar(icon, 50, 6),
                10.paddingWidth,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text("用户ID：$userId", style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                )
              ],
            ),
            InkWell(
                onTap: () {
                  clickCallback();
                },
                child: Icon(Icons.logout, color: color))
          ],
        ),
      ),
    );
  }

  static Widget getCircleAvatar(String url, double size, double radius) {
    return ClipRRect(borderRadius: BorderRadius.all(Radius.circular(radius)), child: Image.network(url, height: size, width: size));
  }
}

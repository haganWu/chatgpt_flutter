import 'package:flutter/material.dart';
import 'package:login_sdk/util/padding_extension.dart';

typedef OnClickCallback = Function();

class HeaderWidget extends StatelessWidget {
  final String userName;
  final String avatar;
  final String userId;
  final double paddingTop;
  final Color backgroundColor;
  final OnClickCallback clickCallback;

  const HeaderWidget({
    super.key,
    required this.userName,
    required this.avatar,
    required this.userId,
    required this.paddingTop,
    required this.backgroundColor,
    required this.clickCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      padding: const EdgeInsets.only(left: 8, top: 12, right: 8, bottom: 20),
      margin: EdgeInsets.only(top: paddingTop),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(6)), child: Image.network(avatar, height: 50, width: 50)),
              10.paddingWidth,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  6.paddingHeight,
                  Text("用户ID：$userId", style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              )
            ],
          ),
          InkWell(
              onTap: () {
                clickCallback();
              },
              child: const Icon(Icons.logout, color: Colors.white))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../util/widget_utils.dart';

/// 我的页面
class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar('我的', titleCenter: true),
      body: const Center(
        child: Text('我的页面', style: TextStyle(fontSize: 30, color: Colors.blue)),
      ),
    );
  }
}

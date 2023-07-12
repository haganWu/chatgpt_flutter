import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('我的')),
      body: const Center(
        child: Text('我的页面', style: TextStyle(fontSize: 30, color: Colors.blue)),
      ),
    );
  }
}

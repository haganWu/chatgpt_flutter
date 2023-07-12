import 'package:flutter/material.dart';

class WonderfulPage extends StatefulWidget {
  const WonderfulPage({Key? key}) : super(key: key);

  @override
  State<WonderfulPage> createState() => _WonderfulPageState();
}

class _WonderfulPageState extends State<WonderfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('精彩内容')),
      body: const Center(
        child: Text('收藏页面', style: TextStyle(fontSize: 30, color: Colors.blue)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// 学习页面
class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('学习')),
      body: const Center(
        child: Text('学习页面', style: TextStyle(fontSize: 30, color: Colors.blue)),
      ),
    );
  }
}

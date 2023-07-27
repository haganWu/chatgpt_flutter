import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';
import '../util/widget_utils.dart';

/// 学习页面
class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var color = themeProvider.themeColor;
    // 设置状态栏的背景颜色与顶部导航栏背景颜色保持一致
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar('学习', titleCenter: true),
      body: Center(child: Text('学习页面', style: TextStyle(fontSize: 30, color: color))),
    );
  }
}

import 'package:chatgpt_flutter/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/navigator_util.dart';
import 'package:openai_flutter/http/ai_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _initConfig();
  }

  @override
  Widget build(BuildContext context) {
    // 更新导航器上下文context
    NavigatorUtil.updateContext(context);
    return const ConversationPage();
  }

  void _initConfig() {
    AiConfigBuilder.init(apiKey: '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',proxy:'10.1.37.84:54484');
  }
}

import 'package:flutter/material.dart';
import 'package:login_sdk/util/navigator_util.dart';
import 'package:openai_flutter/http/ai_config.dart';

import 'conversation_list_page.dart';

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
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: AppBar(
            title: const Text('ChatGPT', style: TextStyle(fontSize: 12)),
          )),
      body: const ConversationListPage(),
    );
  }

  void _initConfig() {
    AiConfigBuilder.init(apiKey: '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', proxy: '10.1.37.84:56288');
  }

}

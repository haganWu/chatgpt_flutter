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
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: AppBar(
            title: const Text('ChatGPT', style: TextStyle(fontSize: 12)),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ElevatedButton(onPressed: _jumpConversationPage, child: const Text('CreateChat'))],
        ),
      ),
    );
  }

  void _initConfig() {
    AiConfigBuilder.init(apiKey: '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', proxy: '10.1.37.84:53730');
  }

  void _jumpConversationPage() {
    NavigatorUtil.push(context, const ConversationPage());
  }
}

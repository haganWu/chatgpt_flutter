import 'package:chatgpt_flutter/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:login_sdk/util/navigator_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  get _logoutBtn => ElevatedButton(
      onPressed: () {
        LoginDao.logout();
      },
      child: const Text('登出'));

  // get _listView => ListView(
  //       children: [
  //         _logoutBtn,
  //         const Text(
  //           '首页',
  //           style: TextStyle(fontSize: 30, color: Colors.deepOrangeAccent),
  //         )
  //       ],
  //     );

  @override
  Widget build(BuildContext context) {
    // 更新导航器上下文context
    NavigatorUtil.updateContext(context);
    return const ConversationPage();
    //   Scaffold(
    //   appBar: AppBar(title: const Text('ChatGPT')),
    //   body: _listView,
    // );
  }
}

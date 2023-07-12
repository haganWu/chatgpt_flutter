import 'package:chatgpt_flutter/pages/conversation_list_page.dart';
import 'package:chatgpt_flutter/pages/my_page.dart';
import 'package:chatgpt_flutter/pages/study_page.dart';
import 'package:chatgpt_flutter/pages/wonderful_page.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/navigator_util.dart';

/// 首页底部导航
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final PageController _controller = PageController(initialPage: 0);
  final defaultColor = Colors.grey;
  var _activeColor = Colors.blue;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 更新导航器上下文context
    NavigatorUtil.updateContext(context);
    return Scaffold(
      body: PageView(
        controller: _controller,
        // 禁止PageView左右滑动
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          ConversationListPage(),
          WonderfulPage(),
          StudyPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,//将label固定
        unselectedItemColor: defaultColor,
        selectedItemColor:_activeColor ,
        items: [
          _bottomItem(title: '聊天', icon: Icons.chat, index: 0),
          _bottomItem(title: '精彩', icon: Icons.local_fire_department, index: 1),
          _bottomItem(title: '学习', icon: Icons.newspaper, index: 2),
          _bottomItem(title: '我的', icon: Icons.account_circle, index: 3),
        ],
      ),
    );
  }

  _bottomItem({required String title, required IconData icon, required int index}) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: defaultColor),
      activeIcon: Icon(icon, color: _activeColor),
      label: title,
    );
  }
}

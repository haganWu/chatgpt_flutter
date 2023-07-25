import 'package:chatgpt_flutter/widget/custom_theme_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:login_sdk/util/padding_extension.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

import '../util/widget_utils.dart';

/// 我的页面
class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late Map<String, dynamic>? userInfo = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.getMyPageAppBar(
        (MediaQuery.of(context).padding.top),
        userInfo?['avatar'],
        userInfo?['userName'],
        userInfo?['imoocId'],
        _logout,
      ),
      body: Column(
        children: [
          _genItem(title: "检查更新", icon: Icons.update, onClick: onCheckUpdate),
          _genItem(title: "设置代理", icon: Icons.wifi_tethering_error, onClick: onSetAgency),
          _genItem(title: "设置主题", subTitle: "请选择你喜欢的主题", onClick: onSetTheme),
        ],
      ),
    );
  }

  static void _logout() {
    AiLogger.log(message: "退出登陆", tag: '');
    LoginDao.logout();
  }

  _genItem({required String title, IconData? icon, String? subTitle, Function? onClick}) {
    return InkWell(
      onTap: () {
        if (onClick != null) {
          onClick();
        }
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          children: [
            const Divider(height: 1, color: Colors.grey),
            10.paddingHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                8.paddingWidth,
                (subTitle != null && subTitle.isNotEmpty)
                    ? Expanded(
                        child: Text(
                        subTitle,
                        style: const TextStyle(color: Colors.grey, fontSize: 8),
                        textAlign: TextAlign.start,
                      ))
                    : Container(),
                icon != null ? Icon(icon, color: Colors.blue) : Container(),
              ],
            ),
            10.paddingHeight
          ],
        ),
      ),
    );
  }

  void _getUserInfo() {
    setState(() {
      userInfo = LoginDao.getUserInfo();
    });
    AiLogger.log(message: "userInfo: $userInfo}", tag: "MyPage");
  }

  onCheckUpdate() {
    AiLogger.log(message: "检查更新", tag: "MyPage");
  }

  onSetAgency() {
    AiLogger.log(message: "设置代理", tag: "MyPage");
  }

  onSetTheme() {
    AiLogger.log(message: "设置主题", tag: "MyPage");
    showSetThemeDialog(context);
  }

  void showSetThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomThemeDialogWidget(
          onColorClickCallback: _onThemeColorCallback,
        );
      },
    );
  }

  void _onThemeColorCallback(MaterialColor color, String colorStr) {
    AiLogger.log(message: 'colorStr: $colorStr', tag: "MyPage");
  }
}

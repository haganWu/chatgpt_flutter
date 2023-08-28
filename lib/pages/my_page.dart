import 'package:chatgpt_flutter/provider/theme_provider.dart';
import 'package:chatgpt_flutter/util/hi_dialog.dart';
import 'package:chatgpt_flutter/util/hi_utils.dart';
import 'package:chatgpt_flutter/widget/custom_theme_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hi_cache/flutter_hi_cache.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:login_sdk/util/padding_extension.dart';
import 'package:openai_flutter/http/ai_config.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import 'package:provider/provider.dart';
import '../util/hi_constants.dart';
import '../widget/header_widget.dart';

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
    var themeProvider = context.watch<ThemeProvider>();
    var color = themeProvider.themeColor;
    // 设置状态栏的背景颜色与顶部导航栏背景颜色保持一致
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
    return Scaffold(
      // appBar: WidgetUtils.getMyPageAppBar(
      //   (MediaQuery.of(context).padding.top),
      //   color,
      //   userInfo?['avatar'],
      //   userInfo?['userName'],
      //   userInfo?['imoocId'],
      //   _logout,
      // ),
      body: Column(
        children: [
          HeaderWidget(
            avatar: userInfo?['avatar'],
            userName: userInfo?['userName'],
            userId: userInfo?['imoocId'],
            paddingTop: (MediaQuery.of(context).padding.top),
            backgroundColor: color,
            clickCallback: _logout,
          ),
          _genItem(title: "检查更新", icon: Icons.update, color: color, onClick: onCheckUpdate),
          _genItem(title: "设置代理", icon: Icons.wifi_tethering_error, color: color, onClick: onSetAgency),
          _genItem(title: "设置主题", subTitle: "请选择你喜欢的主题", color: color, onClick: onSetTheme),
        ],
      ),
    );
  }

  static void _logout() {
    AiLogger.log(message: "退出登陆", tag: '');
    LoginDao.logout();
  }

  _genItem({required String title, IconData? icon, String? subTitle, required Color color, Function? onClick}) {
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
                Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                8.paddingWidth,
                (subTitle != null && subTitle.isNotEmpty)
                    ? Expanded(
                        child: Text(
                        subTitle,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        textAlign: TextAlign.start,
                      ))
                    : Container(),
                icon != null ? Icon(icon, color: color) : Container(),
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

  onSetAgency() async {
    var cacheProxy = HiCache.getInstance().get(HiConstants.keyHiProxySaveTag);
    AiLogger.log(message: "设置代理-$cacheProxy", tag: "MyPage");
   var result = await HiDialog.showProxySettingDialog(context,proxyText: cacheProxy,onTap: _openH5);
   // 点击取消
    if(!result[0]){
      return;
    }
    String? proxy = result[1];
    AiConfigBuilder.instance.setProxy(proxy);
    if(proxy == null || proxy.isEmpty) {
      HiCache.getInstance().remove(HiConstants.keyHiProxySaveTag);
    } else {
      HiCache.getInstance().setString(HiConstants.keyHiProxySaveTag, proxy);
    }
  }

  /// 打开设置说明
  void _openH5() {
    AiLogger.log(message: "打开设置说明H5", tag: "MyPage");
    HiUtils.openH5(HiConstants.proxySettingDocUrl);
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
          onThemeChange: _onThemeChange,
        );
      },
    );
  }

  void _onThemeChange(String colorStr) {
    AiLogger.log(message: 'colorStr: $colorStr', tag: "MyPage");
    context.read<ThemeProvider>().setTheme(colorName: colorStr);
  }

}

import 'package:chatgpt_flutter/pages/bottom_navigator.dart';
import 'package:chatgpt_flutter/provider/hi_provider.dart';
import 'package:chatgpt_flutter/provider/theme_provider.dart';
import 'package:chatgpt_flutter/util/hi_constants.dart';
import 'package:chatgpt_flutter/util/hi_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hi_cache/flutter_hi_cache.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:login_sdk/login_sdk.dart';
import 'package:login_sdk/pages/login_page.dart';
import 'package:openai_flutter/http/ai_config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget get _loadingPage => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: doInit(context),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        Widget widget;
        if (snapshot.connectionState == ConnectionState.done) {
          widget = LoginDao.getBoardingPass() == null ? const LoginPage() : const BottomNavigator();
        } else {
          return _loadingPage;
        }
        return MultiProvider(
          providers: mainProviders,
          child: Consumer<ThemeProvider>(builder: (BuildContext context, ThemeProvider themeProvider, Widget? child) {
            return MaterialApp(
              home: widget,
              theme: themeProvider.getTheme(),
              title: 'ChatGPT',
            );
          }),
        );
      },
    );
  }

  Future<void> doInit(BuildContext context) async {
    String? proxy = HiCache.getInstance().get(HiConstants.keyHiProxySaveTag);
    if(proxy == null || proxy.isEmpty) {
      proxy = HiUtils.getPoxyByPlatform(context);
    }
    await LoginConfig.instance().init(homePage: const BottomNavigator());
    await HiCache.preInit();
    AiConfigBuilder.init(apiKey: HiConstants.apiKey, proxy: proxy);
  }
}

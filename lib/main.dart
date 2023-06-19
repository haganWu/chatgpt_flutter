import 'package:chatgpt_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:login_sdk/login_sdk.dart';
import 'package:login_sdk/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<void>(
        future: doInit(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (LoginDao.getBoardingPass() == null) {
              return const LoginPage();
            } else {
              return const HomePage();
            }
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Future<void> doInit() async {
    await LoginConfig.instance().init(homePage: const HomePage());
  }
}

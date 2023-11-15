import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatgpt_flutter/dao/notice_dao.dart';
import 'package:chatgpt_flutter/models/notice_model.dart';
import 'package:chatgpt_flutter/util/hi_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
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
  var noticeList = [];

  get _listView => ListView.builder(
        padding: const EdgeInsets.only(left: 2, right: 2),
        itemCount: noticeList.length,
        itemBuilder: (BuildContext context, int index) => _bannerWidget(index),
      );

  get _body => noticeList.isEmpty ? _loading : _listView;

  get _loading => Center(
        // child: Image.asset('assets/images/loading.gif',height: 200,width: 200,),
        child: Lottie.asset('assets/lottie/loading.json.zip'),
      );

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var color = themeProvider.themeColor;
    // 设置状态栏的背景颜色与顶部导航栏背景颜色保持一致
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar('精彩课程', titleCenter: true),
      body: _body,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _bannerWidget(int index) {
    BannerMo model = noticeList[index];
    return InkWell(
      onTap: () => HiUtils.openH5(model.url),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          child: CachedNetworkImage(imageUrl: model.cover, height: 190, fit: BoxFit.fill),
        ),
      ),
    );
  }

  void _loadData() async {
    var mo = await NoticeDao.noticeList(
        hitCache: (NoticeModel model) => {
              AiLogger.log(message: 'hiCache-${DateTime.now().millisecondsSinceEpoch}'),
              setState(() {
                noticeList = model.list!;
              })
            });
    setState(() {
      noticeList = mo.list;
    });
  }
}

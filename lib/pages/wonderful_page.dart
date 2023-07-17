import 'dart:convert';

import 'package:chat_message/util/date_format_utils.dart';
import 'package:chatgpt_flutter/db/favorite_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/models/favorite_model.dart';
import 'package:chatgpt_flutter/util/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/padding_extension.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

class WonderfulPage extends StatefulWidget {
  const WonderfulPage({Key? key}) : super(key: key);

  @override
  State<WonderfulPage> createState() => _WonderfulPageState();
}

class _WonderfulPageState extends State<WonderfulPage> with AutomaticKeepAliveClientMixin {
  List<FavoriteModel> favoriteList = [];
  late FavoriteDao favoriteDao;
  int pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: WidgetUtils.getCustomAppBar('精彩内容', titleCenter: true),
        body: ListView.builder(
            // 解决ListView数据量较少时无法滑动问题
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: favoriteList.length,
            itemBuilder: (BuildContext context, int index) => _wonderfulItemWidget(context, index)));
  }

  void _doInit() async {
    var storage = await HiDBManager.instance(dbName: HiDBManager.getAccountHash());
    favoriteDao = FavoriteDao(storage: storage);
    _loadData();
  }

  Future<List<FavoriteModel>> _loadData({bool loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    var list = await favoriteDao.getFavoriteList(pageIndex: pageIndex);
    AiLogger.log(message: 'count:${list.length}', tag: 'ConversationListPage');
    AiLogger.log(message: 'conversationList:${jsonEncode(list)}', tag: 'ConversationListPage');
    if (loadMore) {
      setState(() {
        favoriteList.addAll(list);
      });
    } else {
      setState(() {
        favoriteList = list;
      });
    }
    return list;
  }

  @override
  bool get wantKeepAlive => true;

  _wonderfulItemWidget(BuildContext context, int index) {
    FavoriteModel model = favoriteList[index];
    return GestureDetector(
      onTap: () => toWonderfulDetailPage(index),
      onLongPress: () => showPopupWindow(context, index),
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
        padding: const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.content!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            10.paddingHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.ownerName!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  DateFormatUtils.format(model.createdAt!, dayOnly: false),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  toWonderfulDetailPage(int index) {
    AiLogger.log(message: 'toWonderfulDetailPage', tag: 'WonderfulPage');
  }

  showPopupWindow(BuildContext context, int index) {
    AiLogger.log(message: 'showPopupWindow', tag: 'WonderfulPage');
  }
}

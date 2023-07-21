import 'dart:convert';
import 'package:chatgpt_flutter/db/favorite_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/models/favorite_model.dart';
import 'package:chatgpt_flutter/pages/wonderful_detail_page.dart';
import 'package:chatgpt_flutter/util/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_sdk/util/navigator_util.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import '../util/hi_dialog.dart';
import '../util/hi_utils.dart';
import '../widget/wonderful_item_widget.dart';

class WonderfulPage extends StatefulWidget {
  const WonderfulPage({Key? key}) : super(key: key);

  @override
  State<WonderfulPage> createState() => _WonderfulPageState();
}

class _WonderfulPageState extends State<WonderfulPage> /*with AutomaticKeepAliveClientMixin*/ {
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
    return Scaffold(
        appBar: WidgetUtils.getCustomAppBar('精彩内容', titleCenter: true),
        body: ListView.builder(
            // 解决ListView数据量较少时无法滑动问题
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: favoriteList.length,
            itemBuilder: (BuildContext ancestor, int index) => _wonderfulItemWidget(index)));
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

  // @override
  // bool get wantKeepAlive => true;

  _wonderfulItemWidget(int index) {
    return WonderfulItemWidget(
      model: favoriteList[index],
      onPress: _jumpToWonderfulDetailPage,
      onDelete: _onDelete,
      onCopy: _onCopy,
      onShare: _onShare,
      onMore: _onMore,
    );
  }

  _jumpToWonderfulDetailPage(FavoriteModel model) {
    AiLogger.log(message: 'toWonderfulDetailPage', tag: 'WonderfulPage');
    NavigatorUtil.push(context, WonderfulDetailPage(model: model));
  }

  _onDelete(FavoriteModel model) async {
    var result = await favoriteDao.removeFavorite(model);
    var showText = "";
    if (result != null && result > 0) {
      setState(() {
        favoriteList.remove(model);
      });
      showText = "删除成功";
    } else {
      showText = "删除失败";
    }
    if (!mounted) return;
    HiDialog.showSnackBar(context, showText);
  }

  _onCopy(FavoriteModel model) async {
    await Clipboard.setData(ClipboardData(text: model.content));
    if (!mounted) return;
    HiUtils.copyMessage(context, '文本已复制到系统剪切板');
  }

  _onShare(FavoriteModel model) {
    HiDialog.showSnackBar(context, '转发 - ${model.content.length < 20 ? model.content : model.content.substring(0, 20)}');
  }

  _onMore(FavoriteModel model) {
    HiDialog.showSnackBar(context, '更多 - ${model.content.length < 20 ? model.content : model.content.substring(0, 20)}');
  }
}

import 'dart:convert';
import 'package:chatgpt_flutter/db/conversation_list_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/db/message_dao.dart';
import 'package:chatgpt_flutter/models/conversation_model.dart';
import 'package:chatgpt_flutter/util/constants.dart';
import 'package:chatgpt_flutter/util/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/navigator_util.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import '../widget/conversation_item_widget.dart';
import 'conversation_page.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> with AutomaticKeepAliveClientMixin {
  List<ConversationModel> conversationList = [];
  late ConversationListDao conversationListDao;

  // 跳转到对话详情待更新的model
  ConversationModel? pendingModel;
  int pageIndex = 1;

  get _listView => ListView.builder(
      // 解决ListView数据量较少时无法滑动问题
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: conversationList.length,
      itemBuilder: (BuildContext context, int index) => ConversationItemWidget(
            model: conversationList[index],
            showDivider: index < conversationList.length - 1,
            onPress: _jumpToConversation,
            onDelete: _onDelete,
            onStick: _onStick,
          ));

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  void _doInit() async {
    var storage = await HiDBManager.instance(dbName: HiDBManager.getAccountHash());
    conversationListDao = ConversationListDao(storage: storage);
    _loadData();
  }

  Future<List<ConversationModel>> _loadData({bool loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    var list = await conversationListDao.getConversationList(pageIndex: pageIndex);
    AiLogger.log(message: 'count:${list.length}', tag: 'ConversationListPage');
    AiLogger.log(message: 'conversationList:${jsonEncode(list)}', tag: 'ConversationListPage');
    if (loadMore) {
      setState(() {
        conversationList.addAll(list);
      });
    } else {
      setState(() {
        conversationList = list;
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar('ChatGPT', titleCenter: true),
      body: _listView,
      floatingActionButton: FloatingActionButton(
        onPressed: _createConversation,
        mini: true,
        tooltip: '新建会话',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createConversation() {
    int cid = DateTime.now().millisecondsSinceEpoch;
    _jumpToConversation(ConversationModel(cid: cid, icon: Constants.conversationIcon));
  }

  void _jumpToConversation(ConversationModel model) {
    AiLogger.log(message: 'model:${model.title}', tag: '_jumpToConversation');
    pendingModel = model;
    NavigatorUtil.push(context, ConversationPage(conversationModel: model,conversationUpdate: (model) => _doUpdate(model.cid),)).then((value) {
      Future.delayed(const Duration(milliseconds: 500), () => _doUpdate(model.cid));
    });
  }

  _doUpdate(int cid) async {
    if(pendingModel == null || pendingModel?.title == null){
      return;
    }
    var messageDao = MessageDao(storage: conversationListDao.storage, cid: cid);
    var count = await messageDao.getMessageCount();
    if(pendingModel!.stickTime > 0){
      //TODO 置顶列表
    } else {
      if(!conversationList.contains(pendingModel)){
        conversationList.add(pendingModel!);
      }
    }
    // 刷新
    setState(() {
      pendingModel?.messageCount = count;
    });
    conversationListDao.saveConversation(pendingModel!);
  }

  // 防止页面切回来时请求刷新数据
  @override
  bool get wantKeepAlive => true;

  _onDelete(ConversationModel model) {
    // TODO 更新数据
  }

  _onStick({required bool isStick, required ConversationModel model}) {
    // TODO 更新数据
  }
}

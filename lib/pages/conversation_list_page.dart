import 'dart:convert';
import 'package:chat_message/util/date_format_utils.dart';
import 'package:chatgpt_flutter/db/conversation_list_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/models/conversation_model.dart';
import 'package:chatgpt_flutter/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/navigator_util.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import 'conversation_page.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> with  AutomaticKeepAliveClientMixin{
  List<ConversationModel> conversationList = [];
  late ConversationListDao conversationListDao;

  // 跳转到对话详情待更新的model
  ConversationModel? pendingModel;
  int pageIndex = 1;

  get _listView => ListView.builder(itemCount: conversationList.length, itemBuilder: (BuildContext context, int index) => _conversationItemWidget(index));

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
      // appBar: AppBar(
      //   title: const Text('ChatGPT'),
      // ),
      body: Container(
        padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
        child: _listView,
      ),
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

  _conversationItemWidget(int index) {
    ConversationModel model = conversationList[index];
    return InkWell(
      onTap: () {
        _onItemClick(model);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            _buildCircleAvatar(model),
            const SizedBox(width: 6),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      model.title!,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(width: 2),
                    Text(DateFormatUtils.format(model.updateAt!, dayOnly: false), style: const TextStyle(fontSize: 12, color: Colors.grey))
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text('[${model.messageCount}条对话]', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${model.lastMessage}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                if (index < conversationList.length - 1)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Divider(
                      height: 1,
                      color: Color(0xFFD6D6D6),
                    ),
                  )
              ],
            ))
          ],
        ),
      ),
    );
  }

  _buildCircleAvatar(ConversationModel model) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: Image.network(
          model.icon,
          height: 38,
          width: 38,
        ));
  }

  _onItemClick(ConversationModel model) {
    NavigatorUtil.push(context, ConversationPage(conversationModel: model));
  }

  void _jumpToConversation(ConversationModel model) {
    pendingModel = model;
    NavigatorUtil.push(context, ConversationPage(conversationModel: model)).then((value) {
      Future.delayed(const Duration(milliseconds: 500), () => _doUpdate(model.cid));
    });
  }

  _doUpdate(int cid) {
    conversationListDao.saveConversation(pendingModel!);
    // TODO 更新数据
  }

  // 防止页面切回来时请求刷新数据
  @override
  bool get wantKeepAlive => true;
}

import 'dart:convert';

import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/chat_list_widget.dart';
import 'package:chatgpt_flutter/dao/completion_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/db/message_dao.dart';
import 'package:chatgpt_flutter/models/conversation_model.dart';
import 'package:chatgpt_flutter/widget/message_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import '../util/constants.dart';

class ConversationPage extends StatefulWidget {
  final ConversationModel conversationModel;

  const ConversationPage({Key? key, required this.conversationModel}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  String _inputMessage = '';
  bool _sendBtnEnable = true;
  late MessageDao messageDao;
  late ChatController chatController;
  late CompletionDao completionDao;
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 1;

  get _chatList => Expanded(
          child: ChatListWidget(
        chatController: chatController,
        onBubbleTap: (MessageModel messageModel, BuildContext ancestor) {
          debugPrint('onBubbleLongPress - ${messageModel.content}');
        },
      ));

  get _appBar => PreferredSize(
      preferredSize: const Size.fromHeight(36),
      child: AppBar(
        centerTitle: true,
        title: Text(_title, style: const TextStyle(fontSize: 12)),
      ));

  String get _title => _sendBtnEnable ? '与ChatGPT会话' : '对方正在输入...';

  _inputWidget() {
    return MessageInputWidget(
      hint: '请输入内容',
      enable: _sendBtnEnable,
      onChanged: (text) => _inputMessage = text,
      onSend: () => _onSend(_inputMessage),
    );
  }

  @override
  void initState() {
    super.initState();
    _doInit();
  }

  void _doInit() async {
    chatController = ChatController(
      initialMessageList: [],
      scrollController: _scrollController,
      timePellet: 60,
    );
    // 下拉触发加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        AiLogger.log(message: "下拉触发加载更多", tag: "ConversationPage");
        _loadData(loadMore: true);
      }
    });
    var dbManager = await HiDBManager.instance(dbName: HiDBManager.getAccountHash());
    // TODO fix cid
    messageDao = MessageDao(storage: dbManager, cid: 123);
    // 加载历史对话信息
    var list = await _loadData();
    chatController.loadMoreData(list);
    completionDao = CompletionDao(messages: list);
  }

  void _addMessage(MessageModel model) {
    chatController.addMessage(model);
    messageDao.saveMessage(model);
  }

  @override
  void dispose() {
    super.dispose();
    // chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Column(
        children: [
          _chatList,
          const SizedBox(height: 6),
          _inputWidget(),
        ],
      ),
    );
  }

  // 不适用_inputMessage 是因为在结果回来之前_inputMessage可能会边
  void _onSend(final String inputMessage) async {
    _addMessage(_genMessageModel(ownerType: OwnerType.sender, message: inputMessage));
    setState(() {
      _sendBtnEnable = false;
    });
    String? response;
    try {
      response = await completionDao.createCompletions(prompt: inputMessage);
      response = response?.replaceFirst("\n\n", "");
      AiLogger.log(message: 'response:$response', tag: 'conversation onSend');
    } catch (e) {
      AiLogger.log(message: 'response:${e.toString()}', tag: 'conversation onSend');
    }
    response ??= 'No Response';
    _addMessage(_genMessageModel(ownerType: OwnerType.receiver, message: response));
    setState(() {
      _sendBtnEnable = true;
    });
  }

  MessageModel _genMessageModel({required OwnerType ownerType, required String message}) {
    String avatar, ownerName;
    if (ownerType == OwnerType.sender) {
      avatar = Constants.senderIcon;
      ownerName = Constants.senderName;
    } else {
      avatar = Constants.chatGPTIcon;
      ownerName = Constants.chatGPTName;
    }

    return MessageModel(
      ownerType: ownerType,
      content: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      avatar: avatar,
      ownerName: ownerName,
    );
  }

  Future<List<MessageModel>> _loadData({bool loadMore = false}) async {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    var list = await messageDao.getMessages(pageIndex: pageIndex, pageSize: 4);
    AiLogger.log(message: 'count: ${list.length}', tag: 'ConversationPage');
    AiLogger.log(message: '_loadAll: ${jsonEncode(list)}', tag: 'ConversationPage');
    if (loadMore) {
      if (list.isNotEmpty) {
        chatController.loadMoreData(list);
      } else {
        pageIndex--;
      }
    }
    return list;
  }
}

import 'dart:convert';
import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/chat_list_widget.dart';
import 'package:chatgpt_flutter/dao/completion_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/db/message_dao.dart';
import 'package:chatgpt_flutter/models/conversation_model.dart';
import 'package:chatgpt_flutter/models/favorite_model.dart';
import 'package:chatgpt_flutter/util/hi_dialog.dart';
import 'package:chatgpt_flutter/util/widget_utils.dart';
import 'package:chatgpt_flutter/widget/message_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import '../db/favorite_dao.dart';
import '../util/constants.dart';

typedef OnConversationUpdate = void Function(ConversationModel model);

class ConversationPage extends StatefulWidget {
  final ConversationModel conversationModel;
  final OnConversationUpdate? conversationUpdate;

  const ConversationPage({Key? key, required this.conversationModel, this.conversationUpdate}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  //若为新建的对话框，则_pendingUpdate为tue
  bool get _pendingUpdate => widget.conversationModel.title == null;

  // 是否有通知聊天列表页面更新会话
  bool _hadUpdate = false;
  late Map<String, dynamic> userInfo;
  String _inputMessage = '';
  bool _sendBtnEnable = true;
  late MessageDao messageDao;
  late ChatController chatController;
  late CompletionDao completionDao;
  final ScrollController _scrollController = ScrollController();
  int pageIndex = 1;
  late FavoriteDao favoriteDao;

  get _chatList => Expanded(
          child: ChatListWidget(
        chatController: chatController,
        onBubbleTap: (MessageModel messageModel, BuildContext ancestor) {
          debugPrint('onBubbleTap - ${messageModel.content}');
        },
        onBubbleLongPress: _onBubbleLongPress,
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
    userInfo = LoginDao.getUserInfo()!;
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
    messageDao = MessageDao(storage: dbManager, cid: widget.conversationModel.cid);
    favoriteDao = FavoriteDao(storage: dbManager);
    // 加载历史对话信息
    var list = await _loadData();
    chatController.loadMoreData(list);
    completionDao = CompletionDao(messages: list);
  }

  void _addMessage(MessageModel model) {
    chatController.addMessage(model);
    messageDao.saveMessage(model);
    _notifyConversationListUpdate();
  }

  @override
  void dispose() {
    _updateConversation();
    super.dispose();
    // chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar(_title),
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
    widget.conversationModel.hadChanged = true;
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

  ///通知聊天列表更新当前会话
  _notifyConversationListUpdate() {
    if (!_hadUpdate && _pendingUpdate && widget.conversationUpdate != null) {
      _hadUpdate = true;
      _updateConversation();
      widget.conversationUpdate!(widget.conversationModel);
    }
  }

  @override
  void setState(VoidCallback fn) {
    // 页面关闭后不再处理消息更新
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  MessageModel _genMessageModel({required OwnerType ownerType, required String message}) {
    String avatar, ownerName;
    if (ownerType == OwnerType.sender) {
      avatar = userInfo['avatar'];
      ownerName = userInfo['userName'];
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
    var list = await messageDao.getMessages(pageIndex: pageIndex, pageSize: 10);
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

  void _updateConversation() {
    if (chatController.initialMessageList.isNotEmpty) {
      var model = chatController.initialMessageList.first;
      widget.conversationModel.lastMessage = model.content;
      widget.conversationModel.updateAt = model.createdAt;
      widget.conversationModel.title ??= chatController.initialMessageList.last.content;
    }
  }

  void _onBubbleLongPress(MessageModel message, BuildContext ancestor) {
    bool left = message.ownerType == OwnerType.receiver ? true : false;
    double offsetX = left ? -120 : 30;
    HiDialog.showPopMenu(
      ancestor,
      offsetX: offsetX,
      items: [
        PopupMenuItem(
          onTap: () => _addFavorite(message),
          child: const Text('设为精彩'),
        ),
        PopupMenuItem(
          onTap: () => _copyMessage(message),
          child: const Text('复制'),
        ),
        PopupMenuItem(
          onTap: () => _deleteMessage(message),
          child: const Text('删除'),
        ),
        PopupMenuItem(
          onTap: () => _shareMessage(message),
          child: const Text('转发'),
        ),
      ],
    );
  }

  _addFavorite(MessageModel message) async {
    FavoriteModel model = FavoriteModel(ownerName: message.ownerName, createdAt: message.createdAt, content: message.content);
    var result = await favoriteDao.addFavorite(model);
    if (!mounted) return;
    HiDialog.showSnackBar(context, (result != null && result > 0) ? '收藏成功' : '收藏失败');
  }

  _copyMessage(MessageModel message) async {
    await Clipboard.setData(ClipboardData(text: message.content));
    if (!mounted) return;
    HiDialog.showSnackBar(context, '文本已复制到系统剪切板');
  }

  _deleteMessage(MessageModel message) {
    AiLogger.log(message: '删除！！', tag: 'DialogClick');
    chatController.deleteMessage(message);
    messageDao.deleteMessage(message.id!);
    _notifyConversationListUpdate();
  }

  _shareMessage(MessageModel message) {
    // TODO 转发
    AiLogger.log(message: '转发！！', tag: 'DialogClick');
  }
}

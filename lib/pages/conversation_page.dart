import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/chat_list_widget.dart';
import 'package:chatgpt_flutter/dao/completion_dao.dart';
import 'package:chatgpt_flutter/widget/message_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  String _inputMessage = '';
  bool _sendBtnEnable = true;
  final List<MessageModel> _messageList = [];
  late ChatController chatController;
  final CompletionDao completionDao = CompletionDao();

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
    chatController = ChatController(
      initialMessageList: _messageList,
      scrollController: ScrollController(),
      timePellet: 60,
    );
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
    chatController.addMessage(_genMessageModel(ownerType: OwnerType.sender, message: inputMessage));

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
    chatController.addMessage(_genMessageModel(ownerType: OwnerType.receiver, message: response));
    setState(() {
      _sendBtnEnable = true;
    });
  }

  MessageModel _genMessageModel({required OwnerType ownerType, required String message}) {
    String avatar, ownerName;
    if(ownerType == OwnerType.sender){
      avatar = 'https://o.devio.org/images/o_as/avatar/tx2.jpeg';
      ownerName = 'HaganWu';
    } else {
      avatar = 'https://o.devio.org/images/o_as/avatar/tx4.jpeg';
      ownerName = "ChatGPT";
    }

    return MessageModel(
      ownerType: ownerType,
      content: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      avatar: avatar,
      ownerName: ownerName,
    );
  }
}

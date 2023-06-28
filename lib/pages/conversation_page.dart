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
  final List<MessageModel> _messageList = [];
  late ChatController chatController;

  get _chatList => Expanded(
          child: ChatListWidget(
        chatController: chatController,
        onBubbleTap: (MessageModel messageModel, BuildContext ancestor) {
          debugPrint('onBubbleLongPress - ${messageModel.content}');
        },
      ));

  _inputWidget() {
    return MessageInputWidget(
      hint: '请输入内容',
      onChanged: (text) => _inputMessage = text,
      onSend: _onSend,
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
    chatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatGPT会话')),
      body: Column(
        children: [
          _chatList,
          const SizedBox(height: 6),
          _inputWidget(),
        ],
      ),
    );
  }

  void _onSend() async {
    chatController.addMessage(MessageModel(
      ownerType: OwnerType.sender,
      content: _inputMessage,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg',
      ownerName: 'HaganWu',
    ));

    String? response;
    try {
      response = await CompletionDao.createCompletions(prompt: _inputMessage);
      response = response?.replaceFirst("\n\n", "");
      AiLogger.log(message: 'response:$response', tag: 'conversation onSend');
    } catch (e) {
      AiLogger.log(message: 'response:${e.toString()}', tag: 'conversation onSend');
    }
    response ??= 'No Response';
    chatController.addMessage(MessageModel(
      ownerType: OwnerType.receiver,
      content: response,
      avatar: 'https://o.devio.org/images/o_as/avatar/tx4.jpeg',
      ownerName: 'ChatGPT',
      createdAt: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}

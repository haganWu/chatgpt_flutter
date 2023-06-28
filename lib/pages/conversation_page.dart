import 'package:chat_message/core/chat_controller.dart';
import 'package:chat_message/models/message_model.dart';
import 'package:chat_message/widget/chat_list_widget.dart';
import 'package:chatgpt_flutter/widget/message_input_widget.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key? key}) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  int count = 0;
  String _inputMessage = '';
  final List<MessageModel> _messageList = [
    // MessageModel(ownerType: OwnerType.receiver, content: 'ChatGPT是由OpenAI研发的聊天机器人程序', createdAt: DateTime.parse('2023-06-20 08:08:08').millisecondsSinceEpoch, id: 2, avatar: 'https://o.devio.org/images/o_as/avatar/tx4.jpeg', ownerName: 'ChatGPT'),
    // MessageModel(ownerType: OwnerType.sender, content: '介绍一下ChatGPT', createdAt: DateTime.parse('2023-06-19 18:18:18').millisecondsSinceEpoch, id: 1, avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg', ownerName: 'Imooc'),
  ];
  late ChatController chatController;

  get _chatList => Expanded(
      child: ChatListWidget(
        chatController: chatController,
        onBubbleTap: (MessageModel messageModel, BuildContext ancestor){
          debugPrint('onBubbleLongPress - ${messageModel.content}');
        },
      ));

  _inputWidget(){
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
         _inputWidget(),
        ],
      ),

    );
  }

  void _loadMore() {
    var tl = DateTime.parse('2023-06-18 18:18:18').millisecondsSinceEpoch;
    tl = tl - ++count * 1000000;
    final List<MessageModel> messageList = [
      MessageModel(ownerType: OwnerType.sender, content: 'Look History', createdAt: DateTime.parse('2023-06-19 18:18:18').millisecondsSinceEpoch, id: count + 2, avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg', ownerName: 'Imooc'),
      MessageModel(ownerType: OwnerType.receiver, content: 'ChatGPT History - $count', createdAt: DateTime.parse('2023-06-20 08:08:08').millisecondsSinceEpoch, id: count + 3, avatar: 'https://o.devio.org/images/o_as/avatar/tx4.jpeg', ownerName: 'ChatGPT'),
    ];
    chatController.loadMoreData(messageList);
  }

  void _onSend() {
    count++;
    chatController.addMessage(MessageModel(ownerType: OwnerType.sender, content: 'Hello-$count', createdAt: DateTime.now().millisecondsSinceEpoch, id: count + 2, avatar: 'https://o.devio.org/images/o_as/avatar/tx2.jpeg', ownerName: 'Imooc'));
    Future.delayed(const Duration(milliseconds: 2000), () {
      chatController.addMessage(
        MessageModel(ownerType: OwnerType.receiver, content: 'ChatGPT Response - $count', createdAt: DateTime.now().millisecondsSinceEpoch, id: count + 3, avatar: 'https://o.devio.org/images/o_as/avatar/tx4.jpeg', ownerName: 'ChatGPT'),
      );
    });
  }
}

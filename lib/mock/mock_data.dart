import 'package:chat_message/models/message_model.dart';
import 'package:chatgpt_flutter/db/conversation_list_dao.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/db/message_dao.dart';
import 'package:chatgpt_flutter/models/conversation_model.dart';
import 'package:chatgpt_flutter/util/hi_constants.dart';
import 'package:login_sdk/dao/login_dao.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

const title1 = '请介绍一下Flutter';
const title2 = 'Flutter是由Google开发的开源UI软件开发工具包，用于构建跨平台移动应用程序。它允许开发人员使用单一代码库来创建高性能、高保真度的移动应用，同时支持iOS、Android、Web和桌面应用程序';

mockConversation() async {
  var storage = await HiDBManager.instance(dbName: HiDBManager.getAccountHash());
  var conversationListDao = ConversationListDao(storage: storage);
  var cid = DateTime.now().millisecondsSinceEpoch;
  var userInfo = LoginDao.getUserInfo();
  var avatar = userInfo!['avatar'];
  ConversationModel conversationModel = ConversationModel(cid: cid, icon: avatar, title: '$cid - $title1', updateAt: cid, lastMessage: title1);

  await conversationListDao.saveConversation(conversationModel);
  print('mockConversation - mockConversation');

  for (var i = 0; i < 50000; i++) {
    MessageDao messageDao = MessageDao(storage: storage, cid: cid);
    messageDao.saveMessage(MessageModel(ownerType: OwnerType.receiver, content: '$title1: $i', createdAt: DateTime.now().millisecondsSinceEpoch, avatar:HiConstants.chatGPTIcon));
    messageDao.saveMessage(MessageModel(ownerType: OwnerType.sender, content: '$title2: $i', createdAt: DateTime.now().millisecondsSinceEpoch, avatar:HiConstants.senderIcon));
    AiLogger.log(message: '保存第$i条数据');
  }
}

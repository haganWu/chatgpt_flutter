import 'package:chat_message/models/message_model.dart';
import 'package:chatgpt_flutter/util/conversation_context_helper.dart';
import 'package:openai_flutter/core/ai_completions.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

class CompletionDao {
  final IConversationContext conversationContextHelper = ConversationContextHelper();

  ///初始化会话上下文
  CompletionDao({List<MessageModel>? messages}) {
    MessageModel? question, answer;
    messages?.forEach((model) {
      // sender：提问者；  receiver：ChatGPT回答
      if (model.ownerType == OwnerType.sender) {
        question = model;
      } else {
        answer = model;
      }
      if (question != null && answer != null) {
        conversationContextHelper.add(ConversationModel(question!.content, answer!.content));
        question = answer = null;
      }
    });
    AiLogger.log(message: 'init finish, prompt is ${conversationContextHelper.getPromptContext('')}', tag: 'CompletionDao');
  }

  /// 创建会话
  Future<String?> createCompletions({required String prompt}) async {
    var fullPrompt = conversationContextHelper.getPromptContext(prompt);
    AiLogger.log(message: 'fullPrompt:$fullPrompt', tag: 'CompletionDao');
    var response = await AiCompletions().createChat(prompt: fullPrompt, maxTokens: 1000);
    var choices = response.choices?.first;
    var content = choices?.message?.content;
    AiLogger.log(message: 'content:$content', tag: 'CompletionDao');
    if (content != null) {
      var splitList = content.split('A:');
      content = splitList.length > 1 ? splitList[1] : content;
      content = content.replaceFirst("\n\n", "");
      conversationContextHelper.add(ConversationModel(prompt, content));
    }
    return content;
  }
}

import 'package:chatgpt_flutter/util/conversation_context_helper.dart';
import 'package:openai_flutter/core/ai_completions.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

class CompletionDao {
  final IConversationContext conversationContextHelper = ConversationContextHelper();

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

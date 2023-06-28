import 'package:openai_flutter/core/ai_completions.dart';

class CompletionDao {
  static Future<String?> createCompletions({required String prompt}) async {
    var response = await AiCompletions().createChat(prompt: prompt, maxTokens: 1000);
    var choices = response.choices?.first;
    return choices?.message?.content;

  }
}
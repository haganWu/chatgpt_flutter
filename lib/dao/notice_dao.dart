import 'dart:convert';

import 'package:chatgpt_flutter/models/notice_model.dart';
import 'package:http/http.dart' as http;
import 'package:login_sdk/dao/header_util.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

/// Learn 更多课程

class NoticeDao {
  /// 接口地址
  /// https://api.devio.org/'uapi/notice/banner?pageIndex=1&pageSize=100
  static noticeList({int pageIndex = 1, int pageSize = 100}) async {
    Map<String, String> paramsMap = {};
    paramsMap['pageIndex'] = pageIndex.toString();
    paramsMap['pageSize'] = pageSize.toString();
    var uri = Uri.https('api.devio.org', 'uapi/notice/banner', paramsMap);
    final response = await http.get(uri, headers: hiHeaders());
    Utf8Decoder utf8codec = const Utf8Decoder();
    String bodyString = utf8codec.convert(response.bodyBytes);
    if (response.statusCode == 200) {
      var result = json.decode(bodyString);
      if (result['code'] == 0 && result['data'] != null) {
        AiLogger.log(message: 'noticeList"$result');
        return NoticeModel.fromJson(result['data']);
      } else {
        throw Exception(bodyString);
      }
    } else {
      throw Exception(bodyString);
    }
  }
}

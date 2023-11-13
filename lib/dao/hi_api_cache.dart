import 'package:flutter_hi_cache/flutter_hi_cache.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

/// 接口缓存
class HiApiCache {
  late HiCache _hiCache;

  HiApiCache._();

  static HiApiCache? _instance;

  get _timeNow => DateTime.now().millisecondsSinceEpoch;

  static HiApiCache getInstance() {
    _instance ??= HiApiCache._();
    return _instance!;
  }

  static init(HiCache hiCache) {
    getInstance()._hiCache = hiCache;
  }

  /// 获取缓存
  /// [url] 请求url
  /// [expire] 缓冲过期时间，毫秒
  String? getCache(String url, {int? expire}) {
    var key = _fixedKey(url);
    var list = _hiCache.get(key);
    if (list == null) return null;
    var cacheTime = list[0];
    if (expire == null || _timeNow - int.parse(cacheTime) <= expire) {
      AiLogger.log(message: 'key: $key has cache.', tag: 'HiApiCache');
      return list[1];
    } else {
      // 移除过期缓存
      _hiCache.remove(key);
      AiLogger.log(message: 'remove key: $key.', tag: 'HiApiCache');
      return null;
    }
  }

  /// 设置缓存
  void setCache(String url, String cache) {
    _hiCache.setStringList(_fixedKey(url), ['$_timeNow', cache]);
  }

  /// 统一缓存前缀
  String _fixedKey(String url) {
    return 'urlCache_$url';
  }
}

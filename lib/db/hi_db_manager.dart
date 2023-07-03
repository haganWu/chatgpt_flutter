import 'package:login_sdk/dao/login_dao.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import 'package:sqflite/sqflite.dart';

/// 数据库管理类
class HiDBManager {
  /// 多实例
  static final Map<String, HiDBManager> _storageMap = {};

  /// 数据库名称
  final String _dbName;

  /// 数据库实例
  late Database _db;

  /// 获取HiStorage实例
  static Future<HiDBManager> instance({required String dbName}) async {
    if (!dbName.endsWith(".db")) {
      dbName = '$dbName.db';
    }
    var storage = _storageMap[dbName];
    storage ??= await HiDBManager._(dbName: dbName)._init();
    return storage;
  }

  Database get db {
    return _db;
  }

  /// 私有构造
  HiDBManager._({required String dbName}) : _dbName = dbName {
    _storageMap[_dbName] = this;
  }

  /// 初始化数据库
  Future<HiDBManager> _init() async {
    _db = await openDatabase(_dbName);
    AiLogger.log(message: 'db ver:${await _db.getVersion()}', tag: 'HiDBManager');
    return this;
  }

  /// 销毁数据库
  void destroy() {
    _db.close();
    _storageMap.remove(_dbName);
  }

  /// 账号唯一标识
  static String getAccountHash() {
    return LoginDao.getAccountHash() ?? "test";
  }
}

import 'package:chat_message/models/message_model.dart';
import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/db/table_name.dart';

/// 消息表数据操作接口
abstract class IMessage {
  ///保存消息
  void saveMessage(MessageModel model);

  /// 删除消息
  Future<int> deleteMessage(int id);

  /// 更新消息
  void update(MessageModel model);

  /// 获取所有消息
  Future<List<MessageModel>> getAllMessage();

  /// 分页获取消息
  Future<List<MessageModel>> getMessages({int pageIndex = 1, int pageSize = 20});

  /// 获取消息总数
  Future<int> getMessageCount();
}

class MessageDao implements IMessage, ITable {
  final HiDBManager storage;

  /// 会话id
  final int cid;
  @override
  String tableName = "";

  MessageDao({required this.storage, required this.cid}) : tableName = tableNameByCid(cid) {
    storage.db.execute('create table if not exists $tableName (id integer primary key autoincrement,content text'
        ',createdAt integer, ownerName text, ownerType text, avatar text)');
  }

  /// 获取带会话id（cid）的表名称
  static String tableNameByCid(int cid) {
    return 'tb_$cid';
  }

  @override
  Future<int> deleteMessage(int id) {
    return storage.db.delete(tableName, where: 'id=$id');
  }

  @override
  Future<List<MessageModel>> getAllMessage() async {
    var results = await storage.db.rawQuery('select * from $tableName order by id asc');
    var list = results.map((item) => MessageModel.fromJson(item)).toList();
    return list;
  }

  @override
  Future<int> getMessageCount() async {
    var result = await storage.db.query(tableName, columns: ['COUNT(*) as cnt']);
    return result.first['cnt'] as int;
  }

  @override
  // Future<List<MessageModel>> getMessages({int pageIndex = 1, int pageSize = 10*10000}) async {
  Future<List<MessageModel>> getMessages({int pageIndex = 1, int pageSize = 10}) async {
    var offset = (pageIndex - 1) * pageSize;
    var results = await storage.db.rawQuery('select * from $tableName order by id desc limit $pageSize offset $offset');
    var list = results.map((item) => MessageModel.fromJson(item)).toList();
    // 反转列表数据
    return List.from(list.reversed);
  }

  @override
  void saveMessage(MessageModel model) {
    storage.db.insert(tableName, model.toJson());
  }

  @override
  void update(MessageModel model) {
    storage.db.update(tableName, model.toJson(), where: 'id=?', whereArgs: [model.id]);
  }
}

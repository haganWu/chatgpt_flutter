import 'package:chatgpt_flutter/db/hi_db_manager.dart';
import 'package:chatgpt_flutter/db/message_dao.dart';
import 'package:chatgpt_flutter/db/table_name.dart';
import 'package:sqflite/sqflite.dart';

import '../models/conversation_model.dart';

/// 会话表数据操作接口
abstract class IConversationList {
  /// 保存会话
  Future<int?> saveConversation(ConversationModel model);

  /// 删除会话
  void deleteConversation(ConversationModel model);

  /// 分页查询
  Future<List<ConversationModel>> getConversationList({int pageIndex = 1, int pageSize = 10});

  // /// 置顶和取消置顶
  // Future<int> updateStickTime(ConversationModel model, {bool isStick = false});
  //
  // /// 查询置顶的会话
  // Future<List<ConversationModel>> getStickConversationList();
  //
  // /// 更新会话
  // void update(ConversationModel model);
  //
  // Future<ConversationModel> getConversationByCid(int cid);
}

class ConversationListDao implements IConversationList, ITable {
  final HiDBManager storage;

  @override
  String tableName = "tb_con";

  ConversationListDao({required this.storage}) {
    storage.db.execute('create table if not exists $tableName (id integer primary key autoincrement, cid integer'
        ', title text, icon text, updateAt integer, messageCount integer, lastMessage text, stickTime integer);');
    // 创建唯一索引，以便能够使用title作为唯一键来更新数据
    storage.db.execute('create unique index if not exists ${tableName}_cid_idx on $tableName (cid);');
  }

  @override
  void deleteConversation(ConversationModel model) {
    // 删除聊天会话
    if (model.id == null) {
      storage.db.delete(tableName, where: 'cid=${model.cid}');
    } else {
      storage.db.delete(tableName, where: 'id=${model.id}');
    }
    // 删除会话对应的聊天消息
    storage.db.execute('drop table if exists ${MessageDao.tableNameByCid(model.cid)};');
  }

  @override
  Future<List<ConversationModel>> getConversationList({int pageIndex = 1, int pageSize = 10}) async {
    var offset = (pageIndex - 1) * pageSize;
    var results = await storage.db.rawQuery('select * from $tableName where cast(stickTime as integer) <=0 order by updateAt desc limit $pageSize offset $offset');
    var list = results.map((item) => ConversationModel.fromJson(item)).toList();
    return list;
  }

  @override
  Future<int?> saveConversation(ConversationModel model) async {
    await storage.db.insert(tableName, model.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    var result = await storage.db.query(tableName, where: 'cid = ${model.cid}');
    var resultModel = ConversationModel.fromJson(result.first);
    // 解决新建会话没有id问题
    if (resultModel.id != null) {
      model.id = resultModel.id;
    }
    return resultModel.id;
  }

  // @override
  // Future<List<ConversationModel>> getStickConversationList() async {
  //   var results = await storage.db.rawQuery('select * from $tableName cast(stickTime as integer) >0 order by updateAt desc');
  //   var list = results.map((item) => ConversationModel.fromJson(item)).toList();
  //   return list;
  // }
  //
  // @override
  // Future<int> updateStickTime(ConversationModel model, {bool isStick = false}) {
  //   if (isStick) {
  //     model.stickTime = DateFormatUtils.getZhCurrentTimeMilliseconds();
  //   }
  //   return storage.db.update(tableName, model.toJson(), where: 'id=?', whereArgs: [model.id]);
  // }
  //
  // @override
  // void update(ConversationModel model) {
  //   storage.db.update(tableName, model.toJson(), where: 'cid=?', whereArgs: [model.cid]);
  // }
  //
  // @override
  // Future<ConversationModel> getConversationByCid(int cid) async {
  //   var results = await storage.db.query(tableName, where: 'cid = ?', whereArgs: [cid]);
  //   var list = results.map((item) => ConversationModel.fromJson(item)).toList();
  //   return list.first;
  // }
}

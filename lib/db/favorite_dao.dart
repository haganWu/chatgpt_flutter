import 'package:chatgpt_flutter/db/table_name.dart';
import 'package:chatgpt_flutter/models/favorite_model.dart';

import 'hi_db_manager.dart';

abstract class IFavorite {
  Future<int?> addFavorite(FavoriteModel model);

  Future<int?> removeFavorite(FavoriteModel model);

  Future<List<FavoriteModel>> getFavoriteList({int pageIndex = 1, int pageSize = 10});
}

class FavoriteDao implements ITable, IFavorite {
  final HiDBManager storage;

  @override
  String tableName = 'tb_fav';

  FavoriteDao({required this.storage}) {
    storage.db.execute('create table if not exists $tableName (id integer primary key autoincrement, ownerName text'
        ',createdAt integer, content text);');
  }

  @override
  Future<int?> addFavorite(FavoriteModel model) {
    return storage.db.insert(tableName, model.toJson());
  }

  @override
  Future<List<FavoriteModel>> getFavoriteList({int pageIndex = 1, int pageSize = 10}) async {
    var offset = (pageIndex - 1) * pageSize;
    var results = await storage.db.rawQuery('select * from $tableName order by createdAt desc limit $pageSize offset $offset');
    var list = results.map((item) => FavoriteModel.fromJson(item)).toList();
    return List.from(list);
  }

  @override
  Future<int?> removeFavorite(FavoriteModel model) {
    return storage.db.delete(tableName, where: 'id=${model.id}');
  }
}

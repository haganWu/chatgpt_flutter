class ConversationModel {
  /// 主键、自增
  int? id;

  /// 会话id
  int cid;

  /// 会话标题
  String? title;

  /// 会话图标
  String icon;

  /// 会话更新时间
  int? updateAt;

  ///置顶的时间，millisecondsSinceEpoch，0表示不置顶
  int stickTime;

  /// 消息数
  int? messageCount;

  /// 最后一条消息
  String? lastMessage;

  /// 会话消息是否有变化（如果变化需要更新列表信息）
  bool hadChanged = false;

  ConversationModel({this.id, required this.cid, this.title, required this.icon, this.updateAt, this.stickTime = 0, this.messageCount, this.lastMessage});

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
        id: json['id'],
        cid: json['cid'],
        title: json['title'],
        icon: json['icon'],
        updateAt: json['updateAt'],
        stickTime: json['stickTime'],
        messageCount: json['messageCount'],
        lastMessage: json['lastMessage'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cid'] = cid;
    data['title'] = title;
    data['icon'] = icon;
    data['updateAt'] = updateAt;
    data['stickTime'] = stickTime;
    data['messageCount'] = messageCount;
    data['lastMessage'] = lastMessage;
    return data;
  }
}

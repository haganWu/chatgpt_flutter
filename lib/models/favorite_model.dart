class FavoriteModel {
  int? id;
  String? ownerName;
  int? createdAt;
  String? content;

  FavoriteModel({this.id, this.ownerName, this.createdAt, this.content});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerName = json['ownerName'];
    createdAt = json['createdAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerName'] = ownerName;
    data['createdAt'] = createdAt;
    data['content'] = content;
    return data;
  }
}

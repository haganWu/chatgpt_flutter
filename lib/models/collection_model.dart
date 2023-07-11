class CollectionModel {
  int? id;
  String? ownerName;
  int? createdAt;
  String? content;

  CollectionModel({this.id, this.ownerName, this.createdAt, this.content});

  CollectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerName = json['ownerName'];
    createdAt = json['createdAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownerName'] = this.ownerName;
    data['createdAt'] = this.createdAt;
    data['content'] = this.content;
    return data;
  }
}

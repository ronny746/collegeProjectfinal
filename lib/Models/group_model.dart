class GroupModel {
  int? id;
  String? title;
  String? body;
  String? image;
  String? branch;
  String? year;
  String? public;
  String? admin;
  String? token;
  String? createdAt;
  String? updatedAt;

  GroupModel(
      {this.id,
        this.title,
        this.body,
        this.image,
        this.branch,
        this.year,
        this.public,
        this.admin,
        this.token,
        this.createdAt,
        this.updatedAt});

  GroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    branch = json['branch'];
    year = json['year'];
    public = json['public'];
    admin = json['admin'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['branch'] = this.branch;
    data['year'] = this.year;
    data['public'] = this.public;
    data['admin'] = this.admin;
    data['token'] = this.token;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

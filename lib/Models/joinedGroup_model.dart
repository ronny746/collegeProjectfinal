class JoinedGroupModel {
  int? group_id;

  JoinedGroupModel(
  {this.group_id});

  JoinedGroupModel.fromJson(Map<String, dynamic> json){
    group_id = json["group_id"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.group_id;
    return data;
  }
}

class GroupMessage {
  int? id;
  String? groupId;
  String? userId;
  String? userName;
  String? userProfile;
  String? userBranch;
  String? userYear;
  String? userRole;
  String? message;
  String? file;
  String? createdAt;
  String? updatedAt;

  GroupMessage(
      {this.id,
      this.groupId,
      this.userId,
      this.userName,
      this.userProfile,
      this.userBranch,
      this.userYear,
      this.userRole,
      this.message,
      this.file,
      this.createdAt,
      this.updatedAt});

  GroupMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupId = json['group_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userProfile = json['user_profile'];
    userBranch = json['user_branch'];
    userYear = json['user_year'];
    userRole = json['user_role'];
    message = json['message'];
    file = json['file'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_id'] = this.groupId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_profile'] = this.userProfile;
    data['user_branch'] = this.userBranch;
    data['user_year'] = this.userYear;
    data['user_role'] = this.userRole;
    data['message'] = this.message;
    data['file'] = this.file;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

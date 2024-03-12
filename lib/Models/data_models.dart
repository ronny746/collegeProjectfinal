class DataModel {
  int? id;
  String? fName;
  String? lName;
  String? profile;
  String? rollNumber;
  String? email;
  String? mobile;
  String? branch;
  String? year;
  String? token;
  String? specification;
  String? role;
  Null? emailVerifiedAt;
  String? password;
  Null? rememberToken;
  String? createdAt;
  String? updatedAt;

  DataModel(
      {this.id,
      this.fName,
      this.lName,
      this.profile,
      this.rollNumber,
      this.email,
      this.mobile,
      this.branch,
      this.year,
      this.token,
      this.specification,
      this.role,
      this.emailVerifiedAt,
      this.password,
      this.rememberToken,
      this.createdAt,
      this.updatedAt});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    profile = json['profile'];
    rollNumber = json['roll_number'];
    email = json['email'];
    mobile = json['mobile'];
    branch = json['branch'];
    year = json['year'];
    token = json['token'];
    specification = json['specification'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    password = json['password'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['profile'] = this.profile;
    data['roll_number'] = this.rollNumber;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['branch'] = this.branch;
    data['year'] = this.year;
    data['token'] = this.token;
    data['specification'] = this.specification;
    data['role'] = this.role;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['password'] = this.password;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
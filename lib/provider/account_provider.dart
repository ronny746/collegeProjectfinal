import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:clg_content_sharing/Models/data_models.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';

final accountProvider = ChangeNotifierProvider((ref) => AccountProvider());

class AccountProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  Color AdminColor = Colors.transparent;
  Color TeacherColor = Colors.transparent;
  Color StudentColor = Colors.transparent;
  Color StaffColor = Colors.transparent;

  Color get setAdminColor => Colors.green;

  void changeColor(String role) {
    if (role == "admin") {
      AdminColor = Colors.green;
      notifyListeners();
    }
  }

  DataModel AlluserData = DataModel();
  late DataModel allData;
  var password;
  List<DataModel> classmates = [];
  List<DataModel> teachers = [];
  List<DataModel> staff = [];
  List<DataModel> allStudents = [];
  List<DataModel> allTeachers = [];
  List<DataModel> allStff = [];
  Future<String> registerUser({
    required String fname,
    required String lname,
    required String email,
    required String roll_number,
    required String phone,
    required String branch,
    required String year,
    required String role,
    required String specification,
    required String pass,
    File? photo,
  }) async {
    notifyListeners();
    // AlluserData.clear();
    String result = Constants.SUCCESS;
    Uri uri = Uri.parse("${Constants.baseUrl}/register");

    var body = {
      'f_name': fname,
      'l_name': lname,
      'roll_number': roll_number,
      'email': email,
      'mobile': phone,
      'year': year,
      'branch': branch,
      'specification': specification,
      'role': role,
      'password': pass,
    };

    try {
      var request = new http.MultipartRequest("POST", uri);
      request.fields['f_name'] = fname;
      request.fields['l_name'] = lname;
      request.fields['roll_number'] = roll_number;
      request.fields['email'] = email;
      request.fields['mobile'] = phone;
      request.fields['year'] = year;
       request.fields['token'] = token;
      request.fields['branch'] = branch;
      request.fields['specification'] = specification;
      request.fields['role'] = role;
      request.fields['password'] = pass;
      print(request.fields);

      if (photo != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile',
          photo.path,
          contentType: MediaType('profile', 'jpeg'),
        ));
      }
      request.send().then((response) async {
        print("object");
        print(response.statusCode);
        if (response.statusCode == 200) {
          var resulthttp = await http.Response.fromStream(response);
          var decodedData = JSON.jsonDecode(resulthttp.body);
          AlluserData = DataModel.fromJson(decodedData["result"]);

          print(decodedData);
          if (decodedData["Result"] == "success") {
            result = Constants.SUCCESS;
            print(result);
          }
        } else {
          result = Constants.FAILED;
        }
      });
    } catch (e) {
      print(e.toString());
      result = Constants.FAILED;
    }

    notifyListeners();
    return result;
  }

  Future<String> login(
      {required String credential, required String pass, context}) async {
    notifyListeners();

    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/login");
     print(pass);

    var body;
    // if (role == 'teacher') {
    //   body = {"email": credential, "role": role, "password": pass};
    // } else if (role == 'student') {
    //   body = {"roll_number": credential, "role": role, "password": pass};
    // } else {

    body = {"mobile": credential, "password": pass};
    // }
    //print(body);
    try {
      var response = await http.post(uri, body: body);
      // if (response.statusCode == 502) {
      //   Toast.show("Please Connect College Wifi!");
      // }
      if (response.statusCode == 200) {
        var decodedData = JSON.jsonDecode(response.body);
        print(decodedData);
        AlluserData = DataModel.fromJson(decodedData["result"]);
        password = decodedData['password'];
        var username = AlluserData.mobile;

        await storage.write(key: "username", value: username);
        await storage.write(key: "pass", value: password.toString());
        notifyListeners();
        result = Constants.SUCCESS;

        print(AlluserData);
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    notifyListeners();

    return result;
  }

  Future<String> changePass(
      {required String credential, required String pass, context}) async {
    notifyListeners();

    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/forgot-pass");

    var body;
    // if (role == 'teacher') {
    //   body = {"email": credential, "role": role, "password": pass};
    // } else if (role == 'student') {
    //   body = {"roll_number": credential, "role": role, "password": pass};
    // } else {

    body = {"mobile": credential, "password": pass};
    // }
    //print(body);
    try {
      var response = await http.post(uri, body: body);
      // if (response.statusCode == 502) {
      //   Toast.show("Please Connect College Wifi!");
      // }
      if (response.statusCode == 200) {
        notifyListeners();
         await storage.write(key: "pass", value: pass.toString());
        result = Constants.SUCCESS;
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    notifyListeners();

    return result;
  }

  Future<String> updateProfile({
    required String fname,
    required String lname,
    required String roll_number,
    required String phone,
    required String branch,
    required String year,
    required String role,
    required String profile,
    File? photo,
  }) async {
    notifyListeners();
    String result = Constants.SUCCESS;
    Uri uri = Uri.parse("${Constants.baseUrl}/update");
    print(fname.toString());
    try {
      var request = http.MultipartRequest("POST", uri);
      request.fields.addAll({
        'f_name': fname == "" ? AlluserData.fName.toString() : fname,
        'l_name': lname == "" ? AlluserData.lName.toString() : lname,
        'branch': branch == "" ? AlluserData.branch.toString() : branch,
        'year': year == "" ? AlluserData.year.toString() : year,
        'token': token,
        'role': role == "" ? AlluserData.role.toString() : role,
        'roll_number':
            roll_number == "" ? AlluserData.rollNumber.toString() : roll_number,
        'password': password.toString(),
        'mobile': phone == "" ? AlluserData.mobile.toString() : phone,
      });
      print(request.fields);

      if (photo != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile',
          photo.path,
          contentType: MediaType('profile', 'jpeg'),
        ));
      } else {
        request.fields['profile'] = profile;
      }
      request.send().then((response) async {
        print("object");
        print(response.statusCode);
        if (response.statusCode == 200) {
          var resulthttp = await http.Response.fromStream(response);
          var decodedData = JSON.jsonDecode(resulthttp.body);
          AlluserData = DataModel.fromJson(decodedData["result"]);

          print(decodedData);
          if (decodedData["Result"] == "success") {
            result = Constants.SUCCESS;
            print(result);
          }
        } else {
          result = Constants.FAILED;
        }
      });
    } catch (e) {
      print(e.toString());
      result = Constants.FAILED;
    }

    notifyListeners();
    return result;
  }

  Future<String> getStudents() async {
    notifyListeners();
    classmates.clear();
    allStudents.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/students");

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          allStudents.add(DataModel.fromJson(decodedData["Result"][i]));
        }
        for (int i = 0; i < decodedData["Result"].length; i++) {
          if (AlluserData.branch == decodedData['Result'][i]['branch'] &&
              AlluserData.year == decodedData['Result'][i]['year']) {
            classmates.add(DataModel.fromJson(decodedData["Result"][i]));
          }
        }

        notifyListeners();
        result = Constants.SUCCESS;
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    notifyListeners();

    return result;
  }

  Future<String> getTeachers() async {
    notifyListeners();
    teachers.clear();
    allTeachers.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/teachers");

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          allTeachers.add(DataModel.fromJson(decodedData["Result"][i]));
        }
        for (int i = 0; i < decodedData["Result"].length; i++) {
          if (AlluserData.branch == decodedData['Result'][i]['branch']) {
            teachers.add(DataModel.fromJson(decodedData["Result"][i]));
          }
        }

        notifyListeners();
        result = Constants.SUCCESS;
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    notifyListeners();

    return result;
  }

  Future<String> getstaff() async {
    notifyListeners();
    staff.clear();
    allStff.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/staff");

    try {
      var response = await http.get(uri);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          allStff.add(DataModel.fromJson(decodedData["Result"][i]));
        }
        print(decodedData);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          staff.add(DataModel.fromJson(decodedData["Result"][i]));
        }

        notifyListeners();
        result = Constants.SUCCESS;
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    notifyListeners();

    return result;
  }

  Future<String> sendFeedback(
      {required String name,
      required String email,
      required String description}) async {
    notifyListeners();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/send-feedback");
    var body = {"name": name, "email": email, "description": description};

    try {
      var response = await http.post(uri, body: body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        notifyListeners();
        result = Constants.SUCCESS;
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    notifyListeners();

    return result;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:clg_content_sharing/Models/group_messageModel.dart';
import 'package:clg_content_sharing/Models/group_model.dart';
import 'package:clg_content_sharing/Models/joinedGroup_model.dart';
import 'package:flutter/material.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import 'package:http_parser/http_parser.dart';

final groupProvider = ChangeNotifierProvider((ref) => GroupProvider());

class GroupProvider extends ChangeNotifier {
  List<GroupModel> myGroupData = [];
  List<GroupModel> MyJoinGroup = [];
  List<GroupMessage> groupUsers = [];

  Future<String> myGroups({required String adminId}) async {
    myGroupData.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/my-group");

    var body;
    body = {"admin": adminId};

    try {
      var response = await http.post(uri, body: body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print(decodedData);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          myGroupData.add(GroupModel.fromJson(decodedData["Result"][i]));
        }
        print("kkkk");
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

  List<JoinedGroupModel> joinedGroupId = [];
  Future<String> joinedGroups({required String userId}) async {
    notifyListeners();
    joinedGroupId.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/joinmy-group");

    var body;
    body = {"user_id": userId};

    try {
      var response = await http.post(uri, body: body);

     
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print(decodedData);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          var data = JoinedGroupModel.fromJson(decodedData["Result"][i]);
          if (joinedGroupId.contains(data)) {
            null;
          } else {
            joinedGroupId
                .add(JoinedGroupModel.fromJson(decodedData["Result"][i]));
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

  Future<String> joinedGroupDetail({required String groupId}) async {
    notifyListeners();
    MyJoinGroup.clear();
    String result = Constants.SUCCESS;

    for (var i = 0; i < joinedGroupId.length; i++) {
      Uri uri = Uri.parse(
          "${Constants.baseUrl}/groupbyId/${joinedGroupId[i].group_id.toString()}");

      try {
        var response = await http.get(uri);

        print(response.statusCode);
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          print(decodedData);
          print("Rananan");
          for (int i = 0; i < decodedData["Result"].length; i++) {
            MyJoinGroup.add(GroupModel.fromJson(decodedData["Result"][i]));
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
    }
    return result;
  }

  Future<String> createGroup({
    required String public,
    required String title,
    required String description,
    required String year,
    required String branch,
    required String adminId,
    File? image,
  }) async {
    notifyListeners();

    String result = Constants.SUCCESS;
    Uri uri = Uri.parse("${Constants.baseUrl}/createGroup");

    try {
      var request = http.MultipartRequest('POST', uri);
      request.fields['title'] = title;
      request.fields['body'] = description;
      request.fields['year'] = year;
      request.fields['branch'] = branch;
      request.fields['token'] = token;
      request.fields['public'] = public;
      request.fields['admin'] = adminId;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('profile', 'jpeg'),
        ));
      }
      request.send().then((response) async {
        print(response.statusCode);
        if (response.statusCode == 200) {
          var resulthttp = await http.Response.fromStream(response);
          var decodedData = JSON.jsonDecode(resulthttp.body);

          if (decodedData["Result"] == "Group Created!") {
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

  List<GroupModel> searchedGroup = [];
  Future<String> searchGroup({required String groupName}) async {
    notifyListeners();

    searchedGroup.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/get-communit/${groupName}");

    try {
      var response = await http.get(uri);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print(decodedData);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          searchedGroup.add(GroupModel.fromJson(decodedData["Result"][i]));
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

  List<GroupModel> allGroup = [];
  Future<String> allGroupList() async {
    notifyListeners();

    allGroup.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/allgroup");

    try {
      var response = await http.get(uri);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print(decodedData);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          allGroup.add(GroupModel.fromJson(decodedData["Result"][i]));
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

  Future<String> joinGroupByUser(
      {required String user_id, required String group_id}) async {
    notifyListeners();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/join-create");

    var body;
    body = {'user_id': user_id, 'group_id': group_id};

    try {
      var response = await http.post(uri, body: body);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);

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

  Future<String> getgroupUsers({required String group_id}) async {
    groupUsers.clear();
    notifyListeners();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/get-group-message/${group_id}");

    try {
      var response = await http.get(uri);

      print(response.statusCode);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          groupUsers.add(GroupMessage.fromJson(decodedData["Result"][i]));
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
}
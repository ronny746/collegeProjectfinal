import 'dart:convert';
import 'dart:io';

import 'package:clg_content_sharing/Models/group_messageModel.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as JSON;

final chatProvider = ChangeNotifierProvider((ref) => ChatProvider());

class ChatProvider extends ChangeNotifier {
  bool temp = true;
  bool req = true;
  getTempFalse() {
    temp = false;
    notifyListeners();
  }

  getTemptrue() {
    temp = true;
    notifyListeners();
  }

  getRquestTrue() {
    req = true;
    notifyListeners();
  }
   getRquestFalse() {
    req = false;
    notifyListeners();
  }

  List<GroupMessage> groupMessages = [];
  Future<String> sendMessage({
    required String message,
    required String user_id,
    required String group_id,
    File? file,
  }) async {
    notifyListeners();

    String result = Constants.SUCCESS;
    Uri uri = Uri.parse("${Constants.baseUrl}/send-group-message");

    try {
      var request = http.MultipartRequest('POST', uri);
      request.fields['message'] = message;
      request.fields['user_id'] = user_id;
      request.fields['group_id'] = group_id;

      if (file != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('file', 'jpeg'),
        ));
      }
      request.send().then((response) async {
        print(response.statusCode);
        if (response.statusCode == 200) {
          var resulthttp = await http.Response.fromStream(response);
          var decodedData = JSON.jsonDecode(resulthttp.body);

          if (decodedData["Result"] == "Message Send!") {
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

  Future<String> getMessage(String id) async {
    notifyListeners();
    groupMessages.clear();
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/get-group-message/${id}");
    print(id);
    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print(decodedData);
        for (int i = 0; i < decodedData["Result"].length; i++) {
          groupMessages.add(GroupMessage.fromJson(decodedData["Result"][i]));
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

  Future<String> deleteGroupMessage(String id) async {
    notifyListeners();

    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/delete-message/${id}");

    try {
      var response = await http.delete(uri);

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

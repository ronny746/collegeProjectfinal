import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as JSON;

import '../utils/app_constant.dart';

class ApiCalls {
  Future<String> termCondition() async {
    String result;

    Uri uri = Uri.parse("${Constants.baseUrl}/term-condition");

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var decodeData = JSON.jsonDecode(response.body);
      result = decodeData["content"];
    } else {
      print(response.reasonPhrase);
      result = "Error while loading";
    }
    return result;
  }

  Future<String> privacyPolicy() async {
    String result;

    Uri uri = Uri.parse("${Constants.baseUrl}/privacy-policy");

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var decodeData = JSON.jsonDecode(response.body);
      result = decodeData["content"];
    } else {
      print(response.reasonPhrase);
      result = "Error while loading";
    }
    return result;
  }

  Future<String> contactUs() async {
    String result;

    Uri uri = Uri.parse("${Constants.baseUrl}/contact-us");

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var decodeData = JSON.jsonDecode(response.body);
      result = decodeData["content"];
    } else {
      print(response.reasonPhrase);
      result = "Error while loading";
    }
    return result;
  }

  Future<String> aboutUs() async {
    String result;

    Uri uri = Uri.parse("${Constants.baseUrl}/about-us");

    var response = await http.get(uri);
    if (response.statusCode == 200) {
      var decodeData = JSON.jsonDecode(response.body);
      result = decodeData["content"];
    } else {
      print(response.reasonPhrase);
      result = "Error while loading";
    }
    return result;
  }
}

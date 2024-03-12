import 'dart:convert';

import 'package:clg_content_sharing/Common_Components/common_button.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

final TextEditingController _controllerTitle = TextEditingController();
var viewUserData;

class _CommunityPageState extends ConsumerState<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    viewUserData = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Constants.App_bar_blue,
                  Constants.App_bar_light,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.mirror),
          ),
        ),
        title: const Text(
          "Request Community",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Image.asset("assets/groupReq.png"),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 1),
                    ),
                    hintText: "Title"
                    // border: BorderSide(color: Colors.black,width: 1),
                    ),
                controller: _controllerTitle,
                textAlign: TextAlign.start,
                validator: (value) {
                  if (value == null) {
                    return "Please Enter Title";
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              child: CommonFatButton(
                text: 'Send',
                onPressed: () async {
                  await sendCommunityRequest();
                },
              ),
            )
          ]),
    );
  }

  Future sendCommunityRequest() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAER4FHa0:APA91bHlTmKsnQRujW0mGxZOsV0SXt07wtdWRPMgEPqH610Y5wo6EViBpA1Q6iwcWfUvnjWXPe44_XzqSN8OI_tE4U4jQJY_ivW4qdOKq_t-PH6kbYVOy3NeZwYsDbQ2qa8J0Q-NY8-l'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "registration_ids": [
        "cOWV56ZWSBSyO2qN7QwXsC:APA91bH-L2lk3ynLgrquKP5QhZwcJivvVu9cFFlX4YWH4l_yYZexJjOoUfgYwwYi4GcIKmcMolYQ23BfpBXJOyh6f9HKHmyMU04V-D9r9q6umf56zZo7AlaQSK4KIIrOigsI6FKPFnn9"
      ],
      "notification": {
        "title":
            '${viewUserData.AlluserData.fName} ${viewUserData.AlluserData.lName}',
        "body": "Recieved new Request for ${_controllerTitle.text}!",
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //_controllerTitle.clear();
      sendRequestCommutydb();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green, content: Text("Request Sent!")));
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  sendRequestCommutydb() async {
    var headersList = {'Accept': '/', 'Content-Type': 'application/json'};
    var url = Uri.parse("${Constants.baseUrl}/send_request");

    var body = {
      "title": _controllerTitle.text,
      "user_id": viewUserData.AlluserData.id,
      "token": token
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      _controllerTitle.clear();
    } else {
      print(res.reasonPhrase);
    }
  }
}

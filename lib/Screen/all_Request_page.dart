import 'dart:convert';

import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class AllRequestView extends StatefulWidget {
  const AllRequestView({super.key});

  @override
  State<AllRequestView> createState() => _AllRequestViewState();
}

class _AllRequestViewState extends State<AllRequestView> {
  var allRequest = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("All Requests"),
          // leading: IconButton(
          //   onPressed: (){
          //     Navigator.pop(context);
          //   },
          //   icon: const Icon(Icons.arrow_back_ios_new),
          // ),

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
          )),
      body: SafeArea(
          child: ListView.builder(
        itemCount: allRequest.length,
        itemBuilder: (context, index) {
          int inde = index + 1;
          return ListTile(
            horizontalTitleGap: 10,
            title: Text(allRequest[index]['title'] +" Community"),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(inde.toString()),
            ),
            trailing: allRequest[index]['status'] == "false"
                ? Container(
                    height: 50,
                    width: 200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                updateRequest(
                                    allRequest[index]['title'],
                                    allRequest[index]['user_id'],
                                    allRequest[index]['token']);
                              },
                              child: const Text("Approve")),
                          TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Cancle",
                                style: TextStyle(color: Colors.red),
                              )),
                        ]),
                  )
                : Icon(Icons.done),
          );
        },
      )),
    );
  }

  Future getRequests() async {
    allRequest.clear();
    Uri uri = Uri.parse("${Constants.baseUrl}/get-requests");

    try {
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        allRequest.addAll(decodedData['result']);
        setState(() {});
        print(allRequest.length);
      } else {}
    } catch (e) {}
  }

  Future approved(token) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAER4FHa0:APA91bHlTmKsnQRujW0mGxZOsV0SXt07wtdWRPMgEPqH610Y5wo6EViBpA1Q6iwcWfUvnjWXPe44_XzqSN8OI_tE4U4jQJY_ivW4qdOKq_t-PH6kbYVOy3NeZwYsDbQ2qa8J0Q-NY8-l'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "registration_ids": [token],
      "notification": {
        "title": 'Congratulations!!',
        "body": "Your Request Approved By Admin.",
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    getRequests();

    if (response.statusCode == 200) {
    } else {
      print(response.reasonPhrase);
    }
  }

  updateRequest(title, user_id, token) async {
    var headersList = {'Accept': '/', 'Content-Type': 'application/json'};
    var url = Uri.parse("${Constants.baseUrl}/update-request");

    var body = {
      "title": title,
      "user_id": user_id,
      "token": token,
      "status": "true"
    };
    print(body.entries);

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();
    approved(token);

    if (res.statusCode >= 200 && res.statusCode < 300) {
    } else {
      print(res.reasonPhrase);
    }
  }
}

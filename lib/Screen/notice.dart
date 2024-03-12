import 'dart:convert';

import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class NoticeView extends StatefulWidget {
  const NoticeView({super.key});

  @override
  State<NoticeView> createState() => _NoticeViewState();
}

class _NoticeViewState extends State<NoticeView> {
  
final TextEditingController _controllerTitle = TextEditingController();

final TextEditingController _controllerdesc = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getalluserrr();
  }
  @override
  Widget build(BuildContext context) {

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
          "Notice",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: TextFormField(controller: _controllerTitle,
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
              
                textAlign: TextAlign.start,
                validator: (value) {
                  if (value == null) {
                    return "Please Enter Title";
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
              child: TextFormField(controller: _controllerdesc,
                decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.black87, width: 1),
                    ),
                    hintText: "Description"
                    // border: BorderSide(color: Colors.black,width: 1),
                    ),
              
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
            ElevatedButton(
              child: const Text("SEND"),
              onPressed: () async {
              await sendNotificUser();
              },
            ),
          ]),
    );
  }
  sendNotificUser()async{
    print("object");
     var headersList = {
      'Accept': '/',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse("${Constants.baseUrl}/send-public-notification");

    var body = {
      "title": _controllerTitle.text,
      "desc": _controllerdesc.text,
      "public":"true",
      "group_id": "1"
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      sendCommunityRequest();
      print(resBody);
      
    } else {
      print(res.reasonPhrase);
    }
  }
   var alluser = [];
  Future getalluserrr() async {
    alluser.clear();
    Uri uri = Uri.parse("${Constants.baseUrl}/alluser");

    try {
      var response = await http.get(uri);
      print(response.statusCode);
      var decodedData = jsonDecode(response.body);
      alluser.addAll(decodedData['Result']);
      print(alluser.length);
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }
Future sendCommunityRequest() async {
    for (var i = 0; i < alluser.length; i++) {
     
      var headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAER4FHa0:APA91bHlTmKsnQRujW0mGxZOsV0SXt07wtdWRPMgEPqH610Y5wo6EViBpA1Q6iwcWfUvnjWXPe44_XzqSN8OI_tE4U4jQJY_ivW4qdOKq_t-PH6kbYVOy3NeZwYsDbQ2qa8J0Q-NY8-l'
      };
      var request = http.Request(
          'POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

      request.body = json.encode({
        "registration_ids": ["${alluser[i]['token']}"],
        "notification": {
          "title": '${_controllerTitle.text} New Notice!',
          "body":
              "${_controllerdesc.text}",
        }
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //_controllerTitle.clear();

        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    }
    _controllerTitle.clear();
    _controllerdesc.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green, content: Text("Notice Sent For Group Users!")));
  }

}
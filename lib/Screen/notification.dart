import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import '../utils/app_constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotificatio();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        flexibleSpace:Container(
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
        title: const Text("Notification"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("All Notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.settings_outlined))
                ],
              ),
            ),
            Container(height: allImpo.length>2?200:80,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allImpo.length,
                  itemBuilder: (BuildContext context, int index){
                    return Material(
                      color: const Color(0xFFD8E9FC),
                      child: ListTile(
                        shape: const Border(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                        leading: Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 35,
                          width: 35,
                          decoration: const BoxDecoration(
                              color: Color(0xFFCFCFD0)
                          ),
                        ),
                        trailing: const Icon(Icons.more_horiz,
                          color: Colors.black,),
                        subtitle:  Text(allImpo[index]['descr'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),),
                        title: Text(allImpo[index]['title']+"  "+allnoti[index]['created_at'],
                            style: const TextStyle(
                              fontSize: 11,
                            )),
                      ),
                    );
                  }
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("All Important Group Notifications!",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),),
                  IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.settings_outlined))
                ],
              ),
            ),
            Container(height: groupNot.length>4?350:200,
              child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: groupNot.length,
                    itemBuilder: (BuildContext context, int index){
                      return Material(
                        color: const Color(0xFFD8E9FC),
                        child: ListTile(
                          shape: const Border(
                            bottom: BorderSide(color: Colors.grey),
                          ),
                          leading: Container(
                            margin: const EdgeInsets.only(top: 5),
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                                color: Color(0xFFCFCFD0)
                            ),
                          ),
                          trailing: const Icon(Icons.more_horiz,
                            color: Colors.black,),
                          subtitle:  Text(groupNot[index]['descr'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),),
                          title:  Text(groupNot[index]['title']+"  "+groupNot[index]['created_at'],
                              style: const TextStyle(
                                fontSize: 11,
                              )),
                        ),
                      );
                    }
                ),
            ),
          ],
        ),
      ),
    );
  }
  var allnoti = [];
  var allImpo =[];
  var groupNot =[];
  Future getAllNotificatio() async {
    Uri uri = Uri.parse("${Constants.baseUrl}/get-allnotification");

    try {
      var response = await http.get(uri);
     
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
      allnoti.addAll(decodedData['result']);
      for (var i = 0; i < allnoti.length; i++) {
       
        if(allnoti[i]['public'] == "true"){
          allImpo.add(allnoti[i]);
        }else{
          groupNot.add(allnoti[i]);
        }
      }
      setState(() {
        
      });
      } else {}
    } catch (e) {

    }
  }
}

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_content_sharing/Screen/HostScreen.dart';
import 'package:clg_content_sharing/Screen/home.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/provider/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../utils/app_constant.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _controllerTitle = TextEditingController();
  final TextEditingController _controllerBody = TextEditingController();
  File? image;
  String? imagePath;
  final GlobalKey<FormState> _keyy = GlobalKey<FormState>();
  String year = "1";
  String branch = "CSE";
  var loading = false;
  ScrollController scrollController = ScrollController();
  var years = ['All', '1', '2', '3', '4'];
  var branches = ['All', 'CSE', 'EE', 'EL'];
  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(img!.path);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequests();
  }

  var allRequest = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, w) {
      return Scaffold(
        appBar: AppBar(
            title: const Text("Create New Group"),
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
        body: Form(
          key: _keyy,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: image != null
                          ? FileImage(image!)
                          : const NetworkImage(
                          "https://www.kindpng.com/picc/m/30-302589_blue-community-icon-hd-png-download.png")
                      as ImageProvider,
                    ),
                    Positioned(
                      bottom: 5,
                      right: 2,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                30,
                              ),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(2, 4),
                                color: Colors.black.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 3,
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 20,
                            ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin:
                  const EdgeInsets.only(right: 20, left: 20, bottom: 10),
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Colors.grey.shade200,
                      child: DropdownButton(
                        dropdownColor: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        value: year,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: years.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            year = value!;
                          });
                        },
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade200,
                      child: DropdownButton(
                        dropdownColor: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                        value: branch,
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        items: branches.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                            alignment: Alignment.center,
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            branch = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin:
                  const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                  child: TextFormField(
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
                    controller: _controllerBody,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    child: loading == true
                        ? const Text("Waiting",
                        style: TextStyle(fontSize: 18,color: Colors.white))
                        : const Text("Create",
                        style: TextStyle(fontSize: 18,color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if(_controllerBody.text.isEmpty || _controllerTitle.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                    "Invalid data")));
                      }else{
                      loading = false;
                      var result;
                      AwesomeDialog(
                        btnOkText: "Yes",
                        btnCancelColor: Colors.red,
                        btnOkColor: Colors.green,
                        btnCancelText: "No",
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.rightSlide,
                        title: 'Do You want to make the community private?',
                        desc:
                        "In private community you have to accept user's request, so that they can join the community!",
                        btnCancelOnPress: () async {
                          result = await ref.read(groupProvider).createGroup(
                              public: "false",
                              title: _controllerTitle.text,
                              description: _controllerBody.text,
                              branch: branch,
                              year: year,
                              adminId: ref
                                  .read(accountProvider)
                                  .AlluserData
                                  .id
                                  .toString(),
                              image: image);

                          if (result == Constants.SUCCESS) {
                            const CircularProgressIndicator();
                            Timer(const Duration(seconds: 5), () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: HomePage(),
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            });
                            for (var i = 0; i < allRequest.length; i++) {
                              if (allRequest[i]['title'] ==
                                  _controllerTitle.text) {
                                sendCommunityRequest(allRequest[i]['token']);
                                deletReq(allRequest[i]['id']);
                                //print(allRequest[i]['token']);
                              }
                            }
                          }
                        },
                        btnOkOnPress: () async {
                          result = await ref.read(groupProvider).createGroup(
                              public: "true",
                              title: _controllerTitle.text,
                              description: _controllerBody.text,
                              branch: branch,
                              year: year,
                              adminId: ref
                                  .read(accountProvider)
                                  .AlluserData
                                  .id
                                  .toString(),
                              image: image);

                          if (result == Constants.SUCCESS) {
                            const CircularProgressIndicator();
                            Timer(const Duration(seconds: 6), () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: HomePage(),
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            });
                            for (var i = 0; i < allRequest.length; i++) {
                              if (allRequest[i]['title'] ==
                                  _controllerTitle.text) {
                                sendCommunityRequest(allRequest[i]['token']);
                                deletReq(allRequest[i]['id']);
                                //print(allRequest[i]['token']);
                              }
                            }
                          }
                        },
                      ).show();
                    }},
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future getRequests() async {
    Uri uri = Uri.parse("${Constants.baseUrl}/get-requests");

    try {
      var response = await http.get(uri);
      var decodedData = jsonDecode(response.body);
      allRequest.addAll(decodedData['result']);
      print(allRequest.length);
      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  Future sendCommunityRequest(token) async {
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
        "title": '${_controllerTitle.text} Community Available',
        "body": "Requested community Created in ${branch} ${year} Year.",
      }
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //deletReq(id);
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<String> deletReq(id) async {
    String result = Constants.SUCCESS;

    Uri uri = Uri.parse("${Constants.baseUrl}/delete-request/$id");

    try {
      var response = await http.delete(uri);

      if (response.statusCode == 200) {
        result = Constants.SUCCESS;
      } else {
        result = Constants.FAILED;
      }
    } catch (e) {
      result = Constants.FAILED;
    }

    return result;
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:clg_content_sharing/Screen/group_detail_page.dart';
import 'package:clg_content_sharing/Screen/heroimageopen.dart';
import 'package:clg_content_sharing/Screen/pdfViewr.dart';
import 'package:encryptor/encryptor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/provider/chatProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../Models/group_messageModel.dart';
import '../utils/app_constant.dart';

class GroupChat extends ConsumerStatefulWidget {
  String groupname;
  String image;
  String id;
  String admin;
  GroupChat(
      {Key? key,
        required this.groupname,
        required this.admin,
        required this.image,
        required this.id})
      : super(key: key);

  @override
  ConsumerState<GroupChat> createState() => _GroupDetailState();
}

class _GroupDetailState extends ConsumerState<GroupChat> {
  TextEditingController messageController = TextEditingController();
  bool _switchValue = false;
  String mesHint = "message";
  String? username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _groupMessage();
    getalluserrr();
  }

  _groupMessage() async {
    var viewChatData = ref.read(chatProvider);
    await viewChatData.getMessage(widget.id);
  }

  List<GroupMessage> groupalllM = [];

  final ScrollController _controller = ScrollController();
  String? messageId;
  @override
  Widget build(BuildContext context) {
    var viewChatData = ref.watch(chatProvider);
    var readData = ref.read(chatProvider);
    var viewUserData = ref.watch(accountProvider);
    // var string = 'http://172.16.224.97/content-sharing/public/GroupImage/flutter_tutorial.pdf';
    // var newString = string.substring(-3);
    // print("rna");
    //  print(newString);
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 50,
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              finduniq();
              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AlertDialog(
              //       title: const Text("Send Request For All Users"),
              //       content: TextField(
              //         controller: messageController,
              //         decoration: const InputDecoration(hintText: "Message"),
              //       ),
              //       actions: [
              //         TextButton(
              //           child: const Text("Done"),
              //           onPressed: () {
              //             Navigator.of(context).pop();
              //           },
              //         ),
              //         CupertinoSwitch(
              //           value: _switchValue,
              //           onChanged: (value) {
              //             setState(() {
              //               _switchValue = value;
              //             });
              //           },
              //         ),
              //       ],
              //     );
              //   },
              // );
            },
            child: CupertinoSwitch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => GroupDetailsPage(
                        admin: widget.admin,
                        groupname: widget.groupname,
                        id: widget.id,
                        image: widget.image,
                      ))));
            },
            child: AppBar(
              leading: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 4,
                  ),
                  ClipOval(
                    child: Image.network(
                      '${Constants.GroupImage}/${widget.image}',
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              actions: [
                viewChatData.temp
                    ? const Text("")
                    : InkWell(
                    onTap: () async {
                      viewChatData.deleteGroupMessage(messageId.toString());
                      viewChatData.getTemptrue();
                      await _groupMessage();
                      _groupMessage();
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 28,
                    )),
                viewChatData.req
                    ? const Text("")
                    : InkWell(
                    onTap: () async {
                      viewChatData.getRquestTrue();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Request Sent Succesfully!")));
                    },
                    child: const Center(
                        child: Text("Request",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)))),
                const SizedBox(
                  width: 20,
                )
              ],
              centerTitle: true,
              title: Text(widget.groupname),
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
            ),
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.builder(
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: readData.groupMessages
                                        .toSet()
                                        .toList()
                                        .length,
                                    itemBuilder: ((context, index) {
                                      groupalllM = readData.groupMessages;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: viewChatData
                                              .groupMessages[index]
                                              .userId ==
                                              "${viewUserData.AlluserData.id}"
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            viewChatData.groupMessages[index]
                                                .userId ==
                                                "${viewUserData.AlluserData.id}"
                                                ? InkWell(
                                              onDoubleTap: () {
                                                viewChatData
                                                    .getRquestFalse();
                                              },
                                              onLongPress: () {
                                                viewChatData
                                                    .getTempFalse();
                                                messageId = viewChatData
                                                    .groupMessages[index]
                                                    .id
                                                    .toString();
                                              },
                                              child: Container(
                                                  constraints:
                                                  const BoxConstraints(
                                                      maxHeight: double
                                                          .infinity,
                                                      minWidth: 120,
                                                      maxWidth: 250),
                                                  decoration:
                                                  BoxDecoration(
                                                    // color: Constants
                                                    //     .CHAT_BOX_MINE,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .end,
                                                    children: [
                                                      Text(
                                                        " ${viewChatData.groupMessages[index].userName}     ",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18),
                                                      ),
                                                      "${viewChatData.groupMessages[index].message}" ==
                                                          "null"
                                                          ? const Text("")
                                                          :
                                                      // : Text(
                                                      //     " ${viewChatData.groupMessages[index].message}",
                                                      //     style: const TextStyle(
                                                      //         fontSize:
                                                      //             16),
                                                      //   ),
                                                      BubbleSpecialThree(
                                                        text: Encryptor
                                                            .decrypt(
                                                            "rana",
                                                            "${viewChatData.groupMessages[index].message}"),
                                                        color: const Color(
                                                            0xFF1B97F3),
                                                        tail: true,
                                                        textStyle: const TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize:
                                                            16),
                                                      ),
                                                      viewChatData
                                                          .groupMessages[
                                                      index]
                                                          .file ==
                                                          ""
                                                          ? const Text("")
                                                          : Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            left:
                                                            200),
                                                        child:
                                                        SizedBox(
                                                          height:
                                                          100,
                                                          width:
                                                          200,
                                                          child:
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (_) {
                                                                    return HeroImageOpen(
                                                                      url: '${Constants.GroupMessageImage}/${viewChatData.groupMessages[index].file}',
                                                                    );
                                                                  }));
                                                            },
                                                            child:
                                                            Hero(
                                                              tag:
                                                              'rana',
                                                              child:
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                "${Constants.GroupMessageImage}/${viewChatData.groupMessages[index].file}",
                                                                placeholder: (context, url) =>
                                                                const Center(child: CircularProgressIndicator()),
                                                                errorWidget: (context, url, error) =>
                                                                    InkWell(
                                                                      onTap: () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => PDFViewrwe(
                                                                                  url: "${Constants.GroupMessageImage}/${viewChatData.groupMessages[index].file}",
                                                                                )));
                                                                      },
                                                                      child: Image.asset("assets/pdd.png"),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 140,
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        // right: 10,
                                                        child: Text(
                                                          "${DateFormat('hh:mm a').format(DateTime.parse(viewChatData.groupMessages[index].createdAt.toString()).toLocal())}     ",
                                                          style:
                                                          const TextStyle(
                                                              fontSize:
                                                              10),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            )
                                                : ClipOval(
                                              child: Image.network(
                                                '${Constants.imageUrl}/${viewChatData.groupMessages[index].userProfile}',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            viewChatData.groupMessages[index]
                                                .userId ==
                                                "${viewUserData.AlluserData.id}"
                                                ? ClipOval(
                                              child: Image.network(
                                                '${Constants.imageUrl}/${viewChatData.groupMessages[index].userProfile}',
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                                : InkWell(
                                              onLongPress: () {
                                                viewChatData
                                                    .getTempFalse();
                                                messageId = viewChatData
                                                    .groupMessages[index]
                                                    .id
                                                    .toString();
                                              },
                                              child: Container(
                                                  constraints:
                                                  const BoxConstraints(
                                                      maxHeight: double
                                                          .infinity,
                                                      minWidth: 150,
                                                      maxWidth: 250),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                  child: Column(
                                                    mainAxisSize:
                                                    MainAxisSize.min,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        " ${viewChatData.groupMessages[index].userName}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 18),
                                                      ),
                                                      BubbleSpecialThree(
                                                        text: Encryptor.decrypt(
                                                            "rana",
                                                            viewChatData
                                                                .groupMessages[
                                                            index]
                                                                .message!),
                                                        color: const Color(
                                                            0xFF1B97F3),
                                                        tail: true,
                                                        isSender: false,
                                                        textStyle:
                                                        const TextStyle(
                                                            color:
                                                            Colors
                                                                .white,
                                                            fontSize:
                                                            16),
                                                      ),
                                                      viewChatData
                                                          .groupMessages[
                                                      index]
                                                          .file ==
                                                          ""
                                                          ? const Text("")
                                                          : Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                            right:
                                                            200),
                                                        child:
                                                        SizedBox(
                                                          height:
                                                          100,
                                                          width:
                                                          200,
                                                          child:
                                                          InkWell(
                                                            onTap:
                                                                () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(builder: (_) {
                                                                    return HeroImageOpen(
                                                                      url: '${Constants.GroupMessageImage}/${viewChatData.groupMessages[index].file}',
                                                                    );
                                                                  }));
                                                            },
                                                            child:
                                                            Hero(
                                                              tag:
                                                              'rana',
                                                              child:
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                "${Constants.GroupMessageImage}/${viewChatData.groupMessages[index].file}",
                                                                placeholder: (context, url) =>
                                                                const Center(child: CircularProgressIndicator()),
                                                                errorWidget: (context, url, error) =>
                                                                    InkWell(
                                                                      onTap: () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) => PDFViewrwe(
                                                                                  url: "${Constants.GroupMessageImage}/${viewChatData.groupMessages[index].file}",
                                                                                )));
                                                                      },
                                                                      child: Image.asset("assets/pdd.png"),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 0),
                                                        child: Text(
                                                          DateFormat('hh:mm a').format(DateTime.parse(viewChatData
                                                              .groupMessages[
                                                          index]
                                                              .createdAt
                                                              .toString())
                                                              .toLocal()),
                                                          style:
                                                          const TextStyle(
                                                              fontSize:
                                                              10),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      );
                                    })),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.09,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                // image: DecorationImage(
                //   image: AssetImage('')
                // ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: TextField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            disabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                            hintStyle: const TextStyle(color: Colors.black),
                            border: InputBorder.none,
                            suffixIcon: InkWell(
                              onTap: () async {
                                username = viewUserData.AlluserData.fName!
                                    .toUpperCase()
                                    .toString();
                                final result = await viewChatData.sendMessage(
                                    file: file,
                                    message: Encryptor.encrypt(
                                        'rana', messageController.text),
                                    user_id: viewUserData.AlluserData.id.toString(),
                                    group_id: widget.id);

                                messageController.clear();

                                await _groupMessage();
                                // ignore: use_build_context_synchronously
                                _groupMessage();
                                _switchValue
                                    ? sendCommunityRequest(
                                    viewUserData.AlluserData.fName)
                                    : Text("");
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.black,
                              ),
                            ),
                            prefixIcon: InkWell(
                              onTap: () async {
                                FilePickerResult? result =
                                await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  setState(() {
                                    file = File(result.files.single.path!);
                                    picked = true;
                                  });
                                  // ignore: use_build_context_synchronously
                                  picked
                                  // ignore: use_build_context_synchronously
                                      ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("File"),
                                        content: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20)),
                                          height: 300,
                                          child: Column(
                                            children: [
                                              Image.asset("assets/ima.png"),
                                              SizedBox(height: 20,),
                                              TextField(
                                                controller: messageController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                    "Enter Message.."),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Icon(Icons.send,size: 35,),
                                            onPressed: () async {
                                              final result = await viewChatData
                                                  .sendMessage(
                                                  file: file,
                                                  message:
                                                  Encryptor.encrypt(
                                                      'rana',
                                                      messageController
                                                          .text),
                                                  user_id: viewUserData
                                                      .AlluserData.id
                                                      .toString(),
                                                  group_id: widget.id);

                                              messageController.clear();
                                             

                                              await _groupMessage();
                                              // ignore: use_build_context_synchronously
                                              _groupMessage();
                                              _switchValue
                                                  ? sendCommunityRequest(
                                                  viewUserData
                                                      .AlluserData.fName)
                                                  : Text("");
                                                   Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  )
                                      : Text("data");
                                } else {
                                  // User canceled the picker
                                }
                              },
                              child: const Icon(
                                Icons.file_copy_outlined,
                                color: Colors.black,
                              ),
                            ),
                            hintText: _switchValue ? "Requesting.." : mesHint),
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  File? file;
  // String? imagePath;
  // Future getImage() async {
  //   final ImagePicker _picker = ImagePicker();

  //   final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     image = File(img!.path);
  //   });
  // }
  bool picked = false;
  Future pickedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        picked = true;
      });
      // ignore: use_build_context_synchronously
      picked
          ? showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("File"),
            content: Column(
              children: [Image.asset("assets/ima.png")],
            ),
            actions: [
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      )
          : Text("data");
    } else {
      // User canceled the picker
    }
  }

  Future sendCommunityRequest(user) async {
    sendNotificUser();
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
          "title": '${widget.groupname} Community!',
          "body": "${username} requested for ${messageController.text}",
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Request Sent For Group Users!")));
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

  finduniq() {
    print("object");
    var distinct = groupalllM.forEach((element) {
      print(groupalllM);
    });
  }

  sendNotificUser() async {
    var headersList = {'Accept': '/', 'Content-Type': 'application/json'};
    var url = Uri.parse("${Constants.baseUrl}/send-public-notification");

    var body = {
      "title": widget.groupname,
      "desc": messageController.text,
      "public": "false",
      "group_id": widget.id
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
}
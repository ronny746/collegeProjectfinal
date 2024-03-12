import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import '../utils/app_constant.dart';

class GroupChannelView extends StatefulWidget {
  final GroupChannel groupChannel;
  const GroupChannelView({Key? key, required this.groupChannel})
      : super(key: key);

  @override
  _GroupChannelViewState createState() => _GroupChannelViewState();
}

class _GroupChannelViewState extends State<GroupChannelView>
    with ChannelEventHandler {
  List<BaseMessage> _messages = [];
  var mess;
  var mainuser;
  var sendUser;
  var messagetoken;
  @override
  void initState() {
    super.initState();
    getMessages(widget.groupChannel);
    SendbirdSdk().addChannelEventHandler(widget.groupChannel.channelUrl, this);
    getalluserrr();
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler(widget.groupChannel.channelUrl);
    super.dispose();
  }

  @override
  onMessageReceived(channel, message) {
    setState(() {
      _messages.add(message);
    });
  }

  Future<void> getMessages(GroupChannel channel) async {
    try {
      List<BaseMessage> messages = await channel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('group_channel_view.dart: getMessages: ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: navigationBar(widget.groupChannel),
          preferredSize: const Size.fromHeight(60)),
      body: body(context),
    );
  }

  var chatname;
  Widget navigationBar(GroupChannel channel) {
    User? user = SendbirdSdk().currentUser;
    mainuser = user!.nickname;
    var friend = [for (final member in channel.members) member.nickname].first;
    if (friend == user.nickname) {
      chatname = [for (final member in channel.members) member.nickname].last;
    } else {
      chatname = [for (final member in channel.members) member.nickname].first;
    }

    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: false,
      leading: BackButton(color:Colors.black),
      title: Container(
        width: 250,
        child: Text(
          chatname,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    ChatUser user = asDashChatUser(SendbirdSdk().currentUser!);
    return Padding(
      // A little breathing room for devices with no home button.

      padding: const EdgeInsets.fromLTRB(8, 8, 8, 40),
      child: DashChat(
        dateFormat: DateFormat("E, MMM d"),
        timeFormat: DateFormat.jm(),
        showUserAvatar: true,
        key: Key(widget.groupChannel.channelUrl),
        onSend: (ChatMessage message) async {
          var sentMessage =
              widget.groupChannel.sendUserMessageWithText(message.text!);
          setState(() {
            _messages.add(sentMessage);
            mess = message.text;
            sendNotif();
          });
        },
        sendOnEnter: true,
        textInputAction: TextInputAction.send,
        user: user,
        messages: asDashChatMessages(_messages),
        inputDecoration:
            const InputDecoration.collapsed(hintText: "Type a message here..."),
        messageDecorationBuilder: (ChatMessage msg, bool? isUser) {
          return BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: isUser!
                ? Theme.of(context).primaryColor
                : Colors.grey[200], // example
          );
        },
      ),
    );
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    // BaseMessage is a Sendbird class
    // ChatMessage is a DashChat class
    List<ChatMessage> result = [];
    if (messages != null) {
      messages.forEach((message) {
        User user = message.sender!;
        sendUser = user.nickname;
        if (user == null) {
          return;
        }
        result.add(
          ChatMessage(
            createdAt: DateTime.fromMillisecondsSinceEpoch(message.createdAt),
            text: message.message,
            user: asDashChatUser(user),
          ),
        );
      });
    }
    return result;
  }

  ChatUser asDashChatUser(User user) {
    
    return ChatUser(
      name: user.nickname,
      uid: user.userId,
      avatar: user.profileUrl,
    );
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
        getToken();
      } else {}
    } catch (e) {}
  }

  sendNotif() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAER4FHa0:APA91bHlTmKsnQRujW0mGxZOsV0SXt07wtdWRPMgEPqH610Y5wo6EViBpA1Q6iwcWfUvnjWXPe44_XzqSN8OI_tE4U4jQJY_ivW4qdOKq_t-PH6kbYVOy3NeZwYsDbQ2qa8J0Q-NY8-l'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));

    request.body = json.encode({
      "registration_ids": ["$messagetoken"],
      "notification": {
        "title": '$mainuser',
        "body": "$mess",
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

  getToken() {
    for (var i = 0; i < alluser.length; i++) {
      if (alluser[i]['f_name'] == chatname) {
        messagetoken = alluser[i]['token'];
        print(alluser[i]['token']);
        
         print(alluser[i]['f_name']);
        setState(() {});
      }
    }
  }
}

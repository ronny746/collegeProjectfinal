import 'package:clg_content_sharing/personal_chat/create_channel_view.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'group_channel.dart';


class ChannelListView extends StatefulWidget {
  @override
  _ChannelListViewState createState() => _ChannelListViewState();
}

class _ChannelListViewState extends State<ChannelListView>
    with ChannelEventHandler {
  Future<List<GroupChannel>> getGroupChannels() async {
    try {
      final query = GroupChannelListQuery()
        ..includeEmptyChannel = true
        ..order = GroupChannelListOrder.latestLastMessage
        ..limit = 15;
      return await query.loadNext();
    } catch (e) {
      print('channel_list_view: getGroupChannel: ERROR: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    SendbirdSdk().addChannelEventHandler('channel_list_view', this);
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler("channel_list_view");
    super.dispose();
  }

  @override
  void onChannelChanged(BaseChannel channel) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onChannelDeleted(String channelUrl, ChannelType channelType) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserJoined(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
  }

  @override
  void onUserLeaved(GroupChannel channel, User user) {
    setState(() {
      // Force the list future builder to rebuild.
    });
    super.onUserLeaved(channel, user);
  }

  var chatname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 60,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: TextButton(
            onPressed: () {
              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  CreateChannelView()),
                  );
            },
            child: Image.asset("assets/staff.png")),
      ),
      appBar: PreferredSize(child: navigationBar(), preferredSize: Size.fromHeight(60)),
      body: body(context),
    );
  }

  Widget navigationBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: BackButton(color: Theme.of(context).primaryColor),
      title: const Text(
        'Chat',
        style: TextStyle(color: Colors.black),
      ),
      actions: [],
    );
  }

  var profile;

  Widget body(BuildContext context) {
    User? user = SendbirdSdk().currentUser;

    return FutureBuilder(
      future: getGroupChannels(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false || snapshot.data == null) {
          // Nothing to display yet - good place for a loading indicator
          return Container();
        }
        List<GroupChannel> channels = snapshot.data as List<GroupChannel>;
        return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              GroupChannel channel = channels[index];
              
              var date = DateTime.fromMillisecondsSinceEpoch(
                  channel.lastMessage!.createdAt);
              var d12 =
                  DateFormat('hh:mm a').format(date); // 12/31/2000, 10:00 PM
              var friend =
                  [for (final member in channel.members) member.nickname].first;
              if (friend == user!.nickname) {
                chatname = [
                  for (final member in channel.members) member.nickname
                ].last;
              } else {
                chatname = [
                  for (final member in channel.members) member.nickname
                ].first;
              }

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                child: ListTile(contentPadding: const EdgeInsets.only(right: 30),
                
                  horizontalTitleGap: 0,
                  leading: const CircleAvatar(
                    radius: 48, // Image radius
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/premium-vector/flat-dog-avatar-illustration-cute-dog_677161-59.jpg?w=2000'),
                  ),
                  // leading: ClipRRect(
                  //   borderRadius: BorderRadius.circular(8.0),
                  //   child: Image.network(
                  //     "https://img.freepik.com/premium-vector/flat-dog-avatar-illustration-cute-dog_677161-59.jpg?w=2000",
                  //     height: 100.0,
                  //     width: 100.0,
                  //   ),
                  // ),
                  trailing: Text(d12),
                  // Display all channel members as the title
                  title: Text(
                    chatname,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  // Display the last message presented
                  subtitle: Text(" ${channel.lastMessage?.message}"  '',style: const TextStyle(fontSize: 15),),
                  onTap: () {
                   gotoChannel(channel.channelUrl);
                  //channel.deleteMessage(channel.lastMessage.messageId);
                  },
                ),
              );
            });
      },
    );
  }

  void gotoChannel(String channelUrl) {
    GroupChannel.getChannel(channelUrl).then((channel) {
     
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupChannelView(groupChannel: channel),
        ),
      );
    }).catchError((e) {
      //handle error
      print('channel_list_view: gotoChannel: ERROR: $e');
    });
  }
}

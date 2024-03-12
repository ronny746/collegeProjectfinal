import 'dart:convert';

import 'package:clg_content_sharing/Screen/HostScreen.dart';
import 'package:clg_content_sharing/Screen/community.dart';
import 'package:clg_content_sharing/Screen/groupChat.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/provider/group_provider.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class GroupList extends ConsumerStatefulWidget {
  int? id;
  String? title, body, branch, year, admin, public;
  String? image;
  bool? temp;
  int index;
  bool? maingroup;

  GroupList(
      {required this.id,
      required this.title,
      required this.body,
      required this.branch,
      required this.year,
      required this.admin,
      required this.maingroup,
      this.image,
      this.temp,
      required this.public,
      required this.index});

  @override
  ConsumerState<GroupList> createState() => _GroupListState();
}

class _GroupListState extends ConsumerState<GroupList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewChatData = ref.read(accountProvider);
    var viewUserData = ref.watch(accountProvider);
    var joingroup = ref.read(groupProvider);
    var contain =
        joingroup.MyJoinGroup.where((element) => element.id == widget.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      color: Constants.Icon_shadow,
      child: ListTile(
        trailing: widget.admin.toString() == "${viewChatData.AlluserData.id}"
            ? widget.temp == true
                ? const Text("")
                : const Icon(
                    Icons.shield_sharp,
                    color: Colors.blue,
                  )
            : widget.temp == true
                ? const Text("")
                : InkWell(
                    onTap: () async {},
                    // ignore: unrelated_type_equality_checks
                    child: contain.isNotEmpty
                        ? const Text("")
                        : Container(
                            decoration: const BoxDecoration(color: Colors.blue),
                            height: 30,
                            width: 100,
                            child: Center(
                                child: widget.public == 'false'
                                    ? InkWell(
                                        onTap: () async {
                                          await joingroup.joinGroupByUser(
                                              user_id: viewChatData
                                                  .AlluserData.id
                                                  .toString(),
                                              group_id: widget.id.toString());
                                          // ignore: use_build_context_synchronously
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: const HostScreen(),
                                            withNavBar: false,
                                          );
                                        },
                                        child: const Text(
                                          "Join Now",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          sendRequesttoAdmin(
                                              widget.admin,
                                              viewUserData.AlluserData.id,
                                              widget.id);
                                          PersistentNavBarNavigator
                                              .pushNewScreen(
                                            context,
                                            screen: const HostScreen(),
                                            withNavBar: false,
                                          );
                                        },
                                        child: const Text(
                                          "Request",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ))),
                  ),
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: GroupChat(
              admin: widget.admin.toString(),
              id: widget.id.toString(),
              groupname: widget.title.toString(),
              image: widget.image.toString(),
            ),
            withNavBar: false,
          );
        },
        title: Text(widget.title!),
        subtitle: Text(widget.body!),
        leading: SizedBox(
          height: 40,
          width: 40,
          child: CachedNetworkImage(
            imageUrl: "${Constants.GroupImage}/${widget.image!}",
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  sendRequesttoAdmin(admin, user, group) async {
    var headersList = {'Accept': '/', 'Content-Type': 'application/json'};
    var url = Uri.parse("${Constants.baseUrl}/request-to-admin");

    var body = {"admin": admin, "user_id": user, "group_id": group};

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green, content: Text("Request Sent!")));
      print(resBody);
    } else {
      print(res.reasonPhrase);
    }
  }
}

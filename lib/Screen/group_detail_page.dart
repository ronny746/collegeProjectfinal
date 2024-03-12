import 'package:clg_content_sharing/provider/group_provider.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/chatProvider.dart';

class GroupDetailsPage extends ConsumerStatefulWidget {
  String groupname;
  String image;
  String id;
  String admin;
  GroupDetailsPage(
      {super.key,
      required this.admin,
      required this.groupname,
      required this.image,
      required this.id});

  @override
  ConsumerState<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends ConsumerState<GroupDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _groupUsers();
  }

  _groupUsers() async {
    var viewChatData = ref.read(groupProvider);
    await viewChatData.getgroupUsers(group_id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var viewChatData = ref.read(groupProvider);
    return Scaffold(
      body: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
                fit: BoxFit.cover, "${Constants.GroupImage}/${widget.image}"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(
              widget.groupname,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const Text(
              "Computer science and Engineering",
              style: TextStyle(fontSize: 15),
            ),
            const Text(
              "4 Year",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "43 Participents",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 370,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: 15,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            trailing: index == 0 ? const Text("admin") : const Text(""),
                            title: const Text("User"),
                            leading: ClipOval(
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW2eNGkKRnnhSrjAmESGdbOxsd2IW0fefsuRPIq5pO&s",
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              ),
            ),
            ],),
          )
        ],
      ),
    );
  }
}

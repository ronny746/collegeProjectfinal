import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clg_content_sharing/Common_Components/view_userProfile.dart';
import 'package:clg_content_sharing/Screen/aboutUs.dart';
import 'package:clg_content_sharing/Screen/all_Request_page.dart';
import 'package:clg_content_sharing/Screen/community.dart';
import 'package:clg_content_sharing/Screen/contactUs.dart';
import 'package:clg_content_sharing/Screen/createGroup.dart';
import 'package:clg_content_sharing/Screen/feedBack.dart';
import 'package:clg_content_sharing/Screen/login_page.dart';
import 'package:clg_content_sharing/Screen/notice.dart';
import 'package:clg_content_sharing/Screen/notification.dart';
import 'package:clg_content_sharing/Screen/privactPolicy.dart';
import 'package:clg_content_sharing/Screen/profile.dart';
import 'package:clg_content_sharing/Screen/searchScreen.dart';
import 'package:clg_content_sharing/personal_chat/channel_list.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/provider/group_provider.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:sendbird_sdk/core/models/user.dart';
import 'package:sendbird_sdk/sdk/sendbird_sdk_api.dart';

import 'groupList.dart';
import 'members.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  File? image;
  File? adharImage;
  String? imagePath;

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _payoutController = TextEditingController();
  final TextEditingController _addMobilenumber = TextEditingController();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _myGroup();
  }

  _myGroup() async {
    var viewUserData = ref.read(accountProvider);
    var myGroups = await ref
        .read(groupProvider)
        .myGroups(adminId: viewUserData.AlluserData.id.toString());
    var joinedGroupId = await ref
        .read(groupProvider)
        .joinedGroups(userId: viewUserData.AlluserData.id.toString());
    var readGroupData = ref.read(groupProvider);
    for (int i = 0; i < readGroupData.joinedGroupId.length; i++) {
      var joinedGroupDetail = await readGroupData.joinedGroupDetail(
          groupId: readGroupData.joinedGroupId[i].group_id.toString());
    }
  }

  final GlobalKey<FormState> _keyy = GlobalKey<FormState>();

  String? name;
  String? email;
  String? profile;
  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<User> connect(String appId, String userId) async {
    // Init Sendbird SDK and connect with current user id
    try {
      final sendbird = SendbirdSdk(appId: appId);
      final user = await sendbird.connect(userId);
      return user;
    } catch (e) {
      print('login_view: connect: ERROR: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, w) {
      var viewUserData = ref.watch(accountProvider);
      var readUserData = ref.read(accountProvider);

      var viewGroupData = ref.watch(groupProvider);
      var readGroupData = ref.read(groupProvider);

      sendBirdUserID = viewUserData.AlluserData.mobile.toString();
      print("rana");
      print(viewGroupData.MyJoinGroup.length);
      if (sendBirdUserID == "7380535912") {
        sendBirdUserID = "738053";
      } else if (sendBirdUserID == "6386037892") {
        sendBirdUserID = "63860";
      } else if (sendBirdUserID == "7379287141") {
        sendBirdUserID = "737928";
      } else {
        sendBirdUserID = "705242";
      }
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
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()));
              },
            ),
          ],
          title: const Text(
            "ShareHere",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                // margin: const EdgeInsets.only(bottom: 30.0),
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "${Constants.imageUrl}/${viewUserData.AlluserData.profile}"))),
                ),
                accountName: Text(
                  '${viewUserData.AlluserData.fName} ${viewUserData.AlluserData.lName}',
                  style: const TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  '${viewUserData.AlluserData.mobile}',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("All Users"),
                onTap: () {
                  connect("AABF9F15-06A9-46F2-A28F-4EDBD6504554",
                          sendBirdUserID.toString())
                      .then((user) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChannelListView()),
                    );
                  }).catchError((error) {
                    print('login_view: _signInButton: ERROR: $error');
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text("All Community"),
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: SearchScreen(),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_box_rounded),
                title: const Text("Profile"),
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    withNavBar: true,
                    screen: ProfileScreen(),
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_moderator),
                title: const Text("Add Community"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGroup()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.schedule_send),
                title: const Text("Request Community"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CommunityPage()));
                },
              ),
              viewUserData.AlluserData.role == "admin"
                  ? ListTile(
                      leading: const Icon(Icons.request_page),
                      title: const Text("All Requests"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AllRequestView()));
                      },
                    )
                  : SizedBox(),
              viewUserData.AlluserData.role == "admin"
                  ? ListTile(
                      leading: const Icon(Icons.send_sharp),
                      title: const Text("Notice"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NoticeView()));
                      },
                    )
                  : SizedBox(),
              const Divider(),
              ListTile(
                title: const Text("Contact Us"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactUs()));
                },
              ),
              ListTile(
                title: const Text("About Us"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AboutUs()));
                },
              ),
              ListTile(
                title: const Text("Give Feedback"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => fdback()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Log Out"),
                onTap: () async {
                  const storage = FlutterSecureStorage();
                  await storage.write(key: "username", value: "false");
                  await storage.write(key: "pass", value: "false");
                  viewGroupData.MyJoinGroup.clear();
                  viewGroupData.groupUsers.clear();
                  viewGroupData.joinedGroupId.clear();
                  viewGroupData.myGroupData.clear();
                  viewGroupData.searchedGroup.clear();
                  viewUserData.allTeachers.clear();
                  viewUserData.allStudents.clear();
                  viewUserData.classmates.clear();

                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const Login_page(),
                    withNavBar: false,
                  );
                },
              )
            ],
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              readUserData.AlluserData;
              readGroupData.myGroupData;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // give the tab bar a height [can change hheight to preferred height]
                  Container(
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: Constants.App_bar_blue,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          text: 'My Groups',
                        ),

                        // second tab [you can add an icon using the icon property]
                        Tab(
                          text: 'Joined Groups',
                        ),
                      ],
                    ),
                  ),
                  // tab bar view here
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewGroupData.myGroupData.length,
                            itemBuilder: ((context, index) {
                              return GroupList(
                                maingroup: true,
                                temp: false,
                                index: index,
                                id: viewGroupData.myGroupData[index].id,
                                title: viewGroupData.myGroupData[index].title,
                                body: viewGroupData.myGroupData[index].body,
                                image: viewGroupData.myGroupData[index].image,
                                branch: viewGroupData.myGroupData[index].branch,
                                public: viewGroupData.myGroupData[index].public,
                                year: viewGroupData.myGroupData[index].year,
                                admin: viewGroupData.myGroupData[index].admin,
                              );
                            })),

                        // second tab bar view widget

                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewGroupData.MyJoinGroup.length,
                            itemBuilder: ((context, index) {
                              // return Text(viewGroupData.myGroupData.length.toString());
                              return GroupList(
                                maingroup: true,
                                temp: true,
                                index: index,
                                id: viewGroupData.MyJoinGroup[index].id,
                                title: viewGroupData.MyJoinGroup[index].title,
                                body: viewGroupData.MyJoinGroup[index].body,
                                image: viewGroupData.MyJoinGroup[index].image,
                                branch: viewGroupData.MyJoinGroup[index].branch,
                                year: viewGroupData.MyJoinGroup[index].year,
                                public: viewGroupData.MyJoinGroup[index].public,
                                admin: viewGroupData.MyJoinGroup[index].admin,
                              );
                            })),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // child: SingleChildScrollView(
            //   physics: const AlwaysScrollableScrollPhysics(),
            //   child: Padding(
            //     padding: const EdgeInsets.all(12),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         ListView.builder(
            //             shrinkWrap: true,
            //             physics: const NeverScrollableScrollPhysics(),
            //             itemCount: viewGroupData.myGroupData.length,
            //             itemBuilder: ((context, index) {
            //               return GroupList(
            //                 id: viewGroupData.myGroupData[index].id,
            //                 title: viewGroupData.myGroupData[index].title,
            //                 body: viewGroupData.myGroupData[index].body,
            //                 image: viewGroupData.myGroupData[index].image,
            //                 branch: viewGroupData.myGroupData[index].branch,
            //                 year: viewGroupData.myGroupData[index].year,
            //                 admin: viewGroupData.myGroupData[index].admin,
            //               );
            //             })),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AwesomeDialog(
                btnOkText: "Add",
                btnCancelColor: Colors.blue,
                btnOkColor: Colors.green,
                btnCancelText: "Request",
                context: context,
                dialogType: DialogType.question,
                animType: AnimType.rightSlide,
                title: 'Add/Request',
                desc:
                    "Add: Create new community as admin\nRequest: If you don't want to create new community, make request and when that group will be available in future you will be notified",
                btnCancelOnPress: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CommunityPage()));
                },
                btnOkOnPress: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateGroup()));
                }).show();
          },
          child: const Icon(Icons.group_add_outlined),
        ),
      );
    });
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        // setState(() {
        //   _searchIndexList = [];
        //   for (int i = 0; i < newsHeadlines.length; i++) {
        //     if (newsHeadlines[i].title.contains(s)) {
        //       _searchIndexList.add(i);
        //     }
        //   }
        // });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction:
          TextInputAction.search, //Specify the action button on the keyboard
      decoration: const InputDecoration(
        //Style of TextField
        enabledBorder: UnderlineInputBorder(
            //Default TextField border
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: UnderlineInputBorder(
            //Borders when a TextField is in focus
            borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search', //Text that is displayed when nothing is entered.
        hintStyle: TextStyle(
          //Style of hintText
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:clg_content_sharing/Screen/HostScreen.dart';
import 'package:clg_content_sharing/Screen/editProfile.dart';
import 'package:clg_content_sharing/Screen/home.dart';
import 'package:flutter/material.dart';
import 'package:clg_content_sharing/Common_Components/view_userProfile.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../provider/group_provider.dart';
import 'changePassPage.dart';
import 'forgotPass.dart';
import 'login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScrollController scrollController = ScrollController();
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, w) {

      var viewData = ref.watch(accountProvider);
      var viewGroupData = ref.watch(groupProvider);
      var readData = ref.read(accountProvider);
      String role = viewData.AlluserData.role.toString();
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfile(role: role)));
                  },
                  icon: const Icon(Icons.edit))
            ],
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
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: () async {
              await readData.AlluserData;
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                              color: Constants.Icon_shadow,
                              offset: Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            )
                          ],
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                                MediaQuery.of(context).size.width, 90.0),
                          ),
                          gradient: const LinearGradient(
                              colors: [
                                Constants.App_bar_blue,
                                Constants.App_bar_light,
                              ],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.mirror),
                        ),
                        // child:
                      ),
                      Center(
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            "${Constants.imageUrl}/${viewData.AlluserData.profile}")),
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${viewData.AlluserData.fName}',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Role',
                              hintText: "${role}",
                              labelStyle: const TextStyle(fontSize: 20.0),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        (role == "student" || role == "teacher")
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 50,
                                    width: Get.width*0.3,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0,),
                                    child: TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: 'Branch',
                                        hintText:
                                            "${viewData.AlluserData.branch}",
                                        labelStyle:
                                            const TextStyle(fontSize: 20.0),
                                        border: const OutlineInputBorder(),
                                        focusedBorder:
                                            const OutlineInputBorder(),
                                        alignLabelWithHint: true,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                      ),
                                    ),
                                  ),
                                  (role == "student")
                                      ? Container(
                                          alignment: Alignment.centerRight,
                                          height: 50,
                                    width: Get.width*0.3,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: TextField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              labelText: 'Year',
                                              hintText:
                                                  "${viewData.AlluserData.year}",
                                              labelStyle: const TextStyle(
                                                  fontSize: 20.0),
                                              border:
                                                  const OutlineInputBorder(),
                                              focusedBorder:
                                                  const OutlineInputBorder(),
                                              alignLabelWithHint: true,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 5,
                                        )
                                ],
                              )
                            : const SizedBox(),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Mobile',
                              hintText: "${viewData.AlluserData.mobile}",
                              labelStyle: const TextStyle(fontSize: 20.0),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0),
                          child: TextField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Roll Number',
                              hintText: "${viewData.AlluserData.rollNumber}",
                              labelStyle: const TextStyle(fontSize: 20.0),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(),
                              alignLabelWithHint: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: Text("Change Password"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) =>
                                    ChangePassPage(mobile: viewData.AlluserData.mobile,)),);
                          },
                        ),
                        SizedBox(height: 10,),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          trailing: const Icon(Icons.logout_rounded),
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
                            viewData.allTeachers.clear();
                            viewData.allStudents.clear();
                            viewData.classmates.clear();

                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const Login_page(),
                              withNavBar: false,
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _sizedBox() {
    return const SizedBox(
      height: 20,
    );
  }
}

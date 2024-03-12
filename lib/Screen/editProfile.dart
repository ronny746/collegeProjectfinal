import 'dart:async';
import 'dart:io';
import 'package:clg_content_sharing/Screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/account_provider.dart';
import 'package:get/get.dart';

import '../utils/app_constant.dart';

class EditProfile extends StatefulWidget {
  var role;
  EditProfile({required this.role});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();

  final TextEditingController _rollNoController = TextEditingController();

  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _specificatoinController =
      TextEditingController();
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> _keyy = GlobalKey<FormState>();
  File? image;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Edit Profile"),
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
        child: Consumer(builder: (context, ref, w) {
          var viewData = ref.watch(accountProvider);
          var readData = ref.read(accountProvider);

          // _specificatoinController.text = "${viewData.AlluserData.s}"
          return SingleChildScrollView(
            // physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: image != null
                              ? FileImage(image!)
                              : NetworkImage(
                                      "${Constants.imageUrl}/${viewData.AlluserData.profile}")
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
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "First Name",
                    style: TextStyle(
                        fontFamily: 'Rokkitt',
                        color: Colors.black,
                        fontSize: 17),
                  ),
                  TextField(
                    controller: _fnameController,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontFamily: 'Rokkitt',
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor("D9D9D9"), width: 1)),
                      // errorText: "jnnkn",

                      hintText: "${viewData.AlluserData.fName}",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Last Name",
                    style: TextStyle(
                        fontFamily: 'Rokkitt',
                        color: Colors.black,
                        fontSize: 17),
                  ),
                  TextField(
                    controller: _lnameController,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontFamily: 'Rokkitt',
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor("D9D9D9"), width: 1)),
                      // errorText: "jnnkn",

                      hintText: "${viewData.AlluserData.lName}",
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Mobile",
                    style: TextStyle(
                        fontFamily: 'Rokkitt',
                        color: Colors.black,
                        fontSize: 17),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: HexColor("D9D9D9"))),
                    height: 50,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                Text(
                                  "${viewData.AlluserData.mobile}",
                                  style: const TextStyle(
                                      fontFamily: 'Rokkitt',
                                      color: Colors.black,
                                      fontSize: 18),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.green,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                   const SizedBox(height: 10),
                  const Text(
                    "Roll Number",
                    style: TextStyle(
                        fontFamily: 'Rokkitt',
                        color: Colors.black,
                        fontSize: 17),
                  ),
                  TextField(
                    controller: _rollNoController,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontFamily: 'Rokkitt',
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor("D9D9D9"), width: 1)),
                      // errorText: "jnnkn",

                      hintText: "${viewData.AlluserData.rollNumber}",
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Branch",
                    style: TextStyle(
                        fontFamily: 'Rokkitt',
                        color: Colors.black,
                        fontSize: 17),
                  ),
                  TextField(
                    controller: _branchController,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontFamily: 'Rokkitt',
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor("D9D9D9"), width: 1)),
                      // errorText: "jnnkn",

                      hintText: "${viewData.AlluserData.branch}",
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Year",
                    style: TextStyle(
                        fontFamily: 'Rokkitt',
                        color: Colors.black,
                        fontSize: 17),
                  ),
                  TextField(
                    controller: _yearController,
                    showCursor: true,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        fontFamily: 'Rokkitt',
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: HexColor("D9D9D9"), width: 1)),
                      // errorText: "jnnkn",

                      hintText: "${viewData.AlluserData.year}",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 110, right: 100, top: 10),
                    child: ElevatedButton(
                        onPressed: () async {
                          var result = await ref
                              .read(accountProvider)
                              .updateProfile(
                                  fname: _fnameController.text,
                                  lname: _lnameController.text,
                                  photo: image ??= null,
                                  roll_number: _rollNoController.text,
                                  phone: _mobileController.text,
                                  branch: _branchController.text,
                                  year: _yearController.text,
                                  role: widget.role,
                                  profile: "${viewData.AlluserData.profile}");

                          if (result == Constants.SUCCESS) {
                            // ignore: use_build_context_synchronously
                            const CircularProgressIndicator();
                            Timer(const Duration(seconds: 5), () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileScreen()));
                            });
                          }
                        },
                        style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all(
                                Constants.App_bar_light),
                            elevation: MaterialStateProperty.all(5)
                            // backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                            ),
                        child: const Text("Update")),
                  ),
                  SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

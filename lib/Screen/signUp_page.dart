import 'dart:async';
import 'dart:io';

import 'package:clg_content_sharing/Screen/HostScreen.dart';
import 'package:clg_content_sharing/Screen/home.dart';
import 'package:clg_content_sharing/Screen/privactPolicy.dart';
import 'package:clg_content_sharing/Screen/termCondition.dart';
import 'package:encryptor/encryptor.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

import '../Common_Components/common_Textfield.dart';
import '../Common_Components/common_button.dart';
import '../provider/account_provider.dart';
import '../utils/app_constant.dart';

class Registration extends StatefulWidget {
  var role;
  Registration({required this.role});
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _height = Get.height;

  final _textTheme = Get.textTheme;

  ScrollController scrollController = ScrollController();

  File? image;
  File? adharFrontImage, adharBackImage;
  String? imagePath;
  bool temp = true;

  final TextEditingController _fNameController = TextEditingController();

  final TextEditingController _lNameController = TextEditingController();

  String _branchController = 'CSE';
  final List<String> branch = ['CSE','EE','EL'];

  final TextEditingController _rollnumController = TextEditingController();

  final TextEditingController _yearController = TextEditingController();

  final TextEditingController _specificationController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();

  bool passVisible = false;
  bool cpassVisible = false;

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = File(img!.path);
    });
  }

  final GlobalKey<FormState> _keyy = GlobalKey<FormState>();

  //contrller for Google map

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _keyy,
        child: Consumer(builder: (context, ref, w) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: image != null
                            ? FileImage(image!)
                            : const AssetImage("assets/faceIcon.png")as ImageProvider,
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
                  _buildSizedBox(),
                  CommonTextField(
                    level: "FirstName",
                    controller: _fNameController,
                    hintText: 'FirstName',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value!.trim().length < 3) {
                        return "Name is too short";
                      }
                    },
                  ),
                  _buildSizedBox(),
                  CommonTextField(
                    level: "LastName",
                    controller: _lNameController,
                    hintText: 'LastName',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value!.trim().length < 1) {
                        return "Last name cannot be empty";
                      }
                    },
                  ),

                  widget.role == 'student'
                      ? _buildSizedBox()
                      : const SizedBox(),
                  widget.role == 'student'
                      ? CommonTextField(
                          level: "RollNumber",
                          controller: _rollnumController,
                          hintText: 'RollNumber',
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().length < 1) {
                              return "Cannot be empty";
                            }
                          },
                        )
                      : const SizedBox(),
                  _buildSizedBox(),
                  CommonTextField(
                    level: "Mobile",
                    controller: _mobileController,
                    hintText: 'Mobile',
                    textInputType: TextInputType.text,
                    validator: (value) {
                      if (value!.trim().length < 10) {
                        return "Enter valid mobile no.";
                      }
                    },
                  ),
                  widget.role == 'student' || widget.role == 'teacher'
                      ? _buildSizedBox()
                      : const SizedBox(),
                  widget.role == 'student' || widget.role == 'teacher'
                      ? Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Constants.CHAT_BOX,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                        child: DropdownButtonFormField(
                        items: branch.map((String val) {
                          return new DropdownMenuItem<String>(
                            value: val,
                            child: new Text(val),
                          );
                        }).toList(),
                        dropdownColor: Constants.CHAT_BOX,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                          border: InputBorder.none,
                        ),
                        hint: const Text("Department"),
                        onChanged: (newVal) {
                          _branchController = newVal.toString();
                        }),
                      )
                      : const SizedBox(),
                  widget.role == 'student'
                      ? _buildSizedBox()
                      : const SizedBox(),
                  widget.role == 'student'
                      ? CommonTextField(
                          level: "Year",
                          controller: _yearController,
                          hintText: 'Year',
                          textInputType: TextInputType.text,
                          validator: (value) {
                            
                          },
                        )
                      : const SizedBox(),
                  widget.role == 'staff' ? _buildSizedBox() : const SizedBox(),
                  widget.role == 'staff'
                      ? CommonTextField(
                          level: "Specification",
                          controller: _specificationController,
                          hintText: 'Specification',
                          textInputType: TextInputType.text,
                          validator: (value) {
                            if (value!.trim().length < 1) {
                              return "Cannot be empty";
                            }
                          },
                        )
                      : const SizedBox(),
                  _buildSizedBox(),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Constants.CHAT_BOX,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: TextField(
                      obscureText: !passVisible,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  passVisible = !passVisible;
                                });
                              },
                              icon:passVisible?const Icon(Icons.visibility):const Icon(Icons.visibility_off)
                          ),
                          hintText: "Password",
                          labelText: "Password",
                        contentPadding: const EdgeInsets.only(left: 12),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.2))
                      ),
                      cursorColor: Constants.PRIMARY_COLOR,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  _buildSizedBox(),

                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Constants.CHAT_BOX,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: TextField(
                      obscureText: !cpassVisible,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  cpassVisible = !cpassVisible;
                                });
                              },
                              icon:cpassVisible?const Icon(Icons.visibility):const Icon(Icons.visibility_off)
                          ),
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          contentPadding: const EdgeInsets.only(left: 12),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.2))
                      ),
                      cursorColor: Constants.PRIMARY_COLOR,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _confirmPasswordController,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  _buildSizedBox(),
                  _buildSizedBox(),
                  _buildSizedBox(),
                  _buildSizedBox(),
                  const Text(
                    "By creating account, you accept\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TermCondition()));
                          },
                          child: const Text(
                            "Terms and Conditions",
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          )),
                      const Text("And"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PrivacyPolicy()));
                          },
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          )),
                    ],
                  ),
                  // RichText(
                  //   textAlign:TextAlign.center ,
                  //   text: const TextSpan(
                  //       text: 'By creating account, you accept\n ',
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 18,
                  //       ),
                  //       children: [
                  //         TextSpan(
                  //             text: 'Terms of Service',
                  //             style:
                  //             TextStyle(fontWeight: FontWeight.bold)),
                  //         TextSpan(text: ' and '),
                  //         TextSpan(
                  //             text: 'Privacy Policy',
                  //             style: TextStyle(fontWeight: FontWeight.bold))
                  //       ]),
                  // ),
                  _buildSizedBox(),
                  _buildSizedBox(),
                  CommonFatButton(
                      text: temp == true ? "Register" : "Waiting",
                      onPressed: () async {
                        if(_keyy.currentState?.validate() == true){
                        if(_passwordController.text == _confirmPasswordController.text){
                          temp == false;
                          setState(() {});
                          var result = await ref
                              .read(accountProvider)
                              .registerUser(
                              pass: Encryptor.encrypt(
                                  "rana", _confirmPasswordController.text),
                              roll_number: _rollnumController.text,
                              photo: image,
                              fname: _fNameController.text,
                              lname: _lNameController.text,
                              email: _emailController.text,
                              phone: _mobileController.text,
                              year: _yearController.text,
                              branch: _branchController,
                              specification: _specificationController.text,
                              role: widget.role.toString());

                          if (result == Constants.SUCCESS) {
                            // ignore: use_build_context_synchronously
                            const CircularProgressIndicator();
                            Timer(const Duration(seconds: 6), () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HostScreen()));
                            });
                          }
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                      "password does not match")));
                        }}}),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSizedBox() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
  }
}
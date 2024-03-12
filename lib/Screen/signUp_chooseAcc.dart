import 'package:clg_content_sharing/Screen/signUp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_constant.dart';

class chooseAccount extends StatefulWidget {
  const chooseAccount({Key? key}) : super(key: key);

  @override
  State<chooseAccount> createState() => _chooseAccountState();
}

class _chooseAccountState extends State<chooseAccount> {
  var selectAdminColor = Colors.transparent;
  var selectTeacherColor = Colors.transparent;
  var selectStudentColor = Colors.transparent;
  var selectStaffColor = Colors.transparent;
  var accountType = 0;
  var accountRole = 'none';

  selectState(value) {
    if (value == 2) {
      accountRole = 'teacher';
      selectAdminColor = Colors.transparent;
      selectStaffColor = Colors.transparent;
      selectStudentColor = Colors.transparent;
      selectTeacherColor = Color(0xFFAA3ED4);
    } else if (value == 3) {
      accountRole = 'student';
      selectAdminColor = Colors.transparent;
      selectTeacherColor = Colors.transparent;
      selectStaffColor = Colors.transparent;
      selectStudentColor = Color(0xFF36A23B);
    } else if (value == 4) {
      accountRole = 'staff';
      selectStaffColor = Color(0xFF35A3CB);
      selectAdminColor = Colors.transparent;
      selectTeacherColor = Colors.transparent;
      selectStudentColor = Colors.transparent;
    } else {
      accountRole = 'none';
      selectAdminColor = Colors.transparent;
      selectTeacherColor = Colors.transparent;
      selectStaffColor = Colors.transparent;
      selectStudentColor = Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 40, top: 80),
              child: Text(
                'Select Account Type',
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: Get.height*0.6,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left:0,
                    child:  Container(
                      height: Get.width*0.5,
                    width: Get.width*0.45,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    color: selectTeacherColor,),
                    child: Column(
                      children: [
                        Container(
                          height: Get.width*0.4,
                          width: Get.width*0.45,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  accountType = 2;
                                  selectState(accountType);
                                });
                              },
                              icon: Image.asset('assets/teaching.png')),
                        ),
                        Text("Faculty",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),),
                  Positioned(
                    top: Get.width*0.33,
                    right: 0,
                    child:  Container(
                      height: Get.width*0.5,
                      width: Get.width*0.45,   decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    color: selectStudentColor,),
                    child: Column(
                      children: [
                        Container(
                          height: Get.width*0.4,
                          width: Get.width*0.45,
                          child:IconButton(
                            onPressed: () {
                              setState(() {
                                accountType = 3;
                                selectState(accountType);
                              });
                            },
                            icon: Image.asset('assets/studentLogin.png')),),
                        Text("Student",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),),
                  Positioned(top: Get.width*0.68,
                      left: 0,
                      child:  Container(
                        height: Get.width*0.5,
                        width: Get.width*0.45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                    color: selectStaffColor,),
                    child: Column(
                      children: [
                        Container(
                          height: Get.width*0.4,
                          width: Get.width*0.45,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  accountType = 4;
                                  selectState(accountType);
                                });
                              },
                              icon: Image.asset('assets/staffPng.png')),
                        ),
                        Text("Staff",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: Get.width*0.9,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    if(accountRole == 'none'){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                  "Please select account type")));
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Registration(role: accountRole)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.PRIMARY_COLOR,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text('Select',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}

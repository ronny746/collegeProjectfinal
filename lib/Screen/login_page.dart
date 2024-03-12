import 'package:clg_content_sharing/Screen/forgotPass.dart';
import 'package:clg_content_sharing/Screen/home.dart';
import 'package:clg_content_sharing/Screen/privactPolicy.dart';
import 'package:clg_content_sharing/Screen/signUp_chooseAcc.dart';
import 'package:clg_content_sharing/Screen/termCondition.dart';
import 'package:encryptor/encryptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:toast/toast.dart';

import '../provider/account_provider.dart';
import '../provider/group_provider.dart';
import 'HostScreen.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final TextEditingController _controllerCredential = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  bool passVisible = false;
  bool checkValue = true;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, w) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height*0.1,),
                  // Container(
                  //   height: 130,
                  //   width: 130,
                  //   decoration: const BoxDecoration(
                  //       image: DecorationImage(
                  //           image: AssetImage("assets/HereLogo.png"), fit: BoxFit.fill),
                  //       shape: BoxShape.circle),
                  // ),
                  Container(
                    height: 250,
                    width: 250,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/ShareHereLogo.png"), fit: BoxFit.fill),
                    ),
                  ),
                  // SizedBox(height: Get.height*0.1,),
                  Container(
                    margin: const EdgeInsets.only(
                        right: 20, left: 20, bottom: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black87, width: 1),
                          ),
                          hintText: "Mobile Number"
                          // border: BorderSide(color: Colors.black,width: 1),
                          ),
                      keyboardType: TextInputType.number,
                      controller: _controllerCredential,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    child: TextField(
                      obscureText: !passVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              passVisible = !passVisible;
                            });
                          },
                          icon:passVisible?Icon(Icons.visibility):Icon(Icons.visibility_off)
                        ),
                          prefixIcon: const Icon(Icons.lock),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 1),
                          ),
                          hintText: "Password"
                          // border: BorderSide(color: Colors.black,width: 1),

                          ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _controllerPass,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        onPressed: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassPage()),
                        );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.roboto(
                            // color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                  SizedBox(height: Get.height*0.05,),
                  Center(
                    child: Container(
                      height: 50,
                        margin: const EdgeInsets.only(right: 120, left: 120),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.black87.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                side: const BorderSide(
                                    color: Colors.white, width: 1)),
                            onPressed: () async {
                              var result =
                                  await ref.read(accountProvider).login(
                                        context: context,
                                        credential:
                                            _controllerCredential.text.trim(),
                                        // pass:_controllerPass.text.trim()
                                        pass: Encryptor.encrypt("rana", _controllerPass.text.trim()),
                                        // role: accountRole.toString()
                                      );

                              if (result == 'success') {
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HostScreen()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content:
                                            Text("Welcome To ShareHere")));
                              } else {
                                // ignore: use_build_context_synchronously

                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                            "Invalid Credentials, User not Found!!")));
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )))),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.roboto(
                      // color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const chooseAccount()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.roboto(
                          decoration: TextDecoration.underline,
                          // color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
  llll(){
    showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Send Request For All Users"),
                    content: const TextField(
                      
                      decoration: InputDecoration(hintText: "Message"),
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Done"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      
                      
                    ],
                  );
                },
              );
  }
}

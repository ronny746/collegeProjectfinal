import 'dart:convert';

import 'package:clg_content_sharing/Common_Components/common_button.dart';
import 'package:clg_content_sharing/Screen/login_page.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:encryptor/encryptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class ForgotPassPage extends ConsumerStatefulWidget {
  const ForgotPassPage({super.key});

  @override
  ConsumerState<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends ConsumerState<ForgotPassPage> {
  final TextEditingController _controllerCredential = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final TextEditingController _controllerPassConfirm = TextEditingController();
  bool passVisible = false;
  bool cpassVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
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
        title: const Text(
          "Forgot Password",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: Get.height*0.1,),
            Container(
              child: Image.asset("assets/peopleKey.png"),
            ),
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
              margin: const EdgeInsets.only(right: 20, left: 20,bottom: 10),
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
              margin: const EdgeInsets.only(right: 20, left: 20),
              child: TextField(
                obscureText: !cpassVisible,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            cpassVisible = !cpassVisible;
                          });
                        },
                        icon:cpassVisible?Icon(Icons.visibility):Icon(Icons.visibility_off)
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black, width: 1),
                    ),
                    hintText: "Confirm Password"
                  // border: BorderSide(color: Colors.black,width: 1),
                ),
                keyboardType: TextInputType.visiblePassword,
                controller: _controllerPassConfirm,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 200,
              child: CommonFatButton(text: 'Done',
                onPressed: () async {
                if(_controllerPass.text == _controllerPassConfirm.text){
                  var result =
                  await ref.read(accountProvider).changePass(
                    context: context,
                    credential:
                    _controllerCredential.text.trim(),
                    pass: Encryptor.encrypt("rana", _controllerPass.text.trim()),
                  );
                  if (result == 'success') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const Login_page()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content:
                            Text("Password changes successfully")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                                "Invalid Mobile No.,User not Found!!")));
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              "Password does not match")));
                }
                },),
            )
          ]),
    );
  }
}

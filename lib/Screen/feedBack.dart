import 'package:clg_content_sharing/Common_Components/common_button.dart';
import 'package:clg_content_sharing/provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../utils/app_constant.dart';

class fdback extends ConsumerStatefulWidget {
  @override
  ConsumerState<fdback> createState() => _fdbackState();
}

class _fdbackState extends ConsumerState<fdback> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.15,
                width: double.infinity,
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
                ), // ignore: prefer_const_constructors
                child: Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Write Us",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 34),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 5,
                          width: 90,
                          color: const Color.fromARGB(255, 239, 217, 17),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Feel free  to write us . We will get back to you as soon we can ",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    )),
              ),
              Container(
                height: Get.height * 0.7,
                padding: const EdgeInsets.only(left: 20, right: 20,top: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 20,
                      child: Container(
                        height: Get.height * 0.3,
                        width: Get.width,
                        alignment: Alignment.center,
                        child: Image.asset("assets/feedback.png"),
                      ),
                    ),
                    Positioned(
                      // top: Get.height*0.25,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                hintText: "Full Name"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                hintText: "E-Mail"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            maxLines: 5,
                            controller: descriptionController,
                            decoration: InputDecoration(
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                hintText: "Description"),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                        child: CommonFatButton(
                      text: "Send",
                      onPressed: () async {
                        var viewChatData = ref.read(accountProvider);
                        var result = await viewChatData.sendFeedback(
                            name: nameController.text,
                            email: emailController.text,
                            description: descriptionController.text);
                        if (result == "success") {
                          nameController.clear();
                          emailController.clear();
                          descriptionController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Feedback Send!")));
                        }
                      },
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

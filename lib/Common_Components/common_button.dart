
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonFatButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Function() onPressed;
  const CommonFatButton({super.key, required this.text, this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Get.textTheme;
    final height = Get.height;
    return Container(
      height: 50,
      width: Get.width*0.9,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              backgroundColor: Constants.PRIMARY_COLOR,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: Text(text,
              style: TextStyle(fontSize: 18,color: Colors.white))),
    );
  }
}

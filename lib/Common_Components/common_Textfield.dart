
// ignore_for_file: must_be_immutable

import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final TextInputType textInputType;
  final String? level;
  final Key? key;
  String? Function(String?)? validator;
  CommonTextField(
      {required this.controller,
      required this.hintText,
      this.obsecureText: false,
      required this.textInputType,
      required this.validator,
      this.level,
      this.key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Constants.CHAT_BOX,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: TextFormField(
            maxLines: 7,
            minLines: 1,
            validator: validator,
            cursorColor: Constants.PRIMARY_COLOR,
            keyboardType: textInputType,
            controller: controller,
            decoration: InputDecoration(

                label: Text("${level}"),
                contentPadding: const EdgeInsets.only(left: 12),
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)))));
  }
}

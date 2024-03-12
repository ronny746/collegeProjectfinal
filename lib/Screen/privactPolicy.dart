import 'package:clg_content_sharing/Function/apiCalls.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String content = "Loading...";
  @override
  void initState() {
    privacy_policy();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Text(content),
      ),
    );
  }

  privacy_policy() async{
    var result = await ApiCalls().privacyPolicy();
    setState(() {
      content = result;
    });
  }
}

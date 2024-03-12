import 'package:clg_content_sharing/Function/apiCalls.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String content = "Loading...";

  @override
  void initState() {
    contact_us();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Text(content),
      ),
    );
  }

  contact_us() async{
    var result = await ApiCalls().contactUs();
    setState(() {
      content = result;
    });
  }
}

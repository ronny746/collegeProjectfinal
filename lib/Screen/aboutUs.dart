import 'package:clg_content_sharing/Function/apiCalls.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String content = "Loading...";

  @override
  void initState() {
    about_us();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Text(content),
      ),
    );
  }

  about_us() async{
    var result = await ApiCalls().termCondition();
    setState(() {
      content = result;
    });
  }
}

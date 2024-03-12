import 'package:clg_content_sharing/Function/apiCalls.dart';
import 'package:flutter/material.dart';


class TermCondition extends StatefulWidget {
  const TermCondition({Key? key}) : super(key: key);

  @override
  State<TermCondition> createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  String content = "Loading...";

  @override
  void initState() {
    term_condition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and Conditions"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        child: Text(content),
      ),
    );
  }

  term_condition() async{
    var result = await ApiCalls().termCondition();
    setState(() {
      content = result;
    });
  }
}

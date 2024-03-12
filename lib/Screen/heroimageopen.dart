import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HeroImageOpen extends StatefulWidget {
  var url;
  HeroImageOpen({super.key, this.url});

  @override
  State<HeroImageOpen> createState() => _HeroImageOpenState();
}

class _HeroImageOpenState extends State<HeroImageOpen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'rana',
            child: Image.network(
              widget.url.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
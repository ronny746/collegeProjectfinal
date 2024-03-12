import 'dart:io';
import 'dart:typed_data';

import 'package:clg_content_sharing/Models/data_models.dart';
import 'package:clg_content_sharing/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../provider/account_provider.dart';

class UserDeatails extends StatefulWidget {
  String fname, lname, email, profile, phone, role, branch, year, specification;
  bool temp = false;
  DataModel user;

  int index;

  UserDeatails(
      {required this.fname,
      required this.lname,
      required this.phone,
      required this.email,
      required this.user,
      required this.temp,
      required this.profile,
      required this.year,
      required this.branch,
      required this.role,
      required this.specification,
      required this.index});

  @override
  State<UserDeatails> createState() => _UserDeatailsState();
}

class _UserDeatailsState extends State<UserDeatails> {
  final _height = Get.height;

  final _textTheme = Get.textTheme;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, w) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Constants.LIGHT_GREEN,
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Profile",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    //
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.tealAccent,
                                    content: Container(
                                      height: 150,
                                      width: 100,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "${Constants.imageUrl}${widget.user.profile}"),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }));
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "${Constants.imageUrl}${widget.user.profile}"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('FirstName : ${widget.user.fName}',
                        style: _textTheme.bodyLarge),
                    Text('LastName : ${widget.user.lName}',
                        style: _textTheme.bodyLarge),

                    Text('Email: ${widget.user.email}',
                        style: _textTheme.bodyLarge),
                    Text('Mobile : ${widget.user.mobile}',
                        style: _textTheme.bodyLarge),
                    Text('RollNumber: ${widget.user.rollNumber}',
                        style: _textTheme.bodyLarge),

                    Text('Branch : ${widget.user.branch}',
                        style: _textTheme.bodyLarge),

                    Text('Year: ${widget.user.year}',
                        style: _textTheme.bodyLarge),
                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Text('Role:'),
                        Text(widget.user.role.toString(),
                            style: _textTheme.bodyLarge)
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // ignore: prefer_const_literals_to_create_immutables
                  ])),
        ],
      );
    });
  }
}


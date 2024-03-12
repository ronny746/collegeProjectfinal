import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var token;
var sendBirdUserID ='';

class Constants {
  
  static String baseUrl = "http://192.168.17.124/content-sharing/public/api";
  static String imageUrl =
      "http://192.168.17.124/content-sharing/public/Profileimage";
  static String GroupImage =
      "http://192.168.17.124/content-sharing/public/GroupImage";
       static String GroupMessageImage =
      "http://192.168.17.124/content-sharing/public/GroupImagefile";
  static String SUCCESS = "success";
  static String FAILED = "failed";
  static const Color PRIMARY_COLOR = Color(0xff08C35F);
  static const Color ORANGE_COLOR = Color(0xffFFAA00);
  static const Color WHITE_COLOR = Color(0xffF5F5F5);
  static const Color LIGHT_GREEN = Color(0xffA8EAC7);
  static const Color App_bar_blue = Color(0xff507be8);
  static const Color App_bar_light = Color(0xFF6AD2EC);
  static const Color LINK_BLUE = Color(0xff0e3eb6);
  static const Color CHAT_BOX = Color(0xFFCDF0F8);
  static const Color CHAT_BOX_MINE = Color(0xFFE1CAF6);
  static const Color Icon_shadow = Color(0xF2D5EFF6);
}

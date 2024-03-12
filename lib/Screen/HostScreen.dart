import 'package:clg_content_sharing/Screen/members.dart';
import 'package:clg_content_sharing/Screen/profile.dart';
import 'package:clg_content_sharing/Screen/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../utils/app_constant.dart';
import 'home.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({Key? key}) : super(key: key);

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor:  Constants.LIGHT_GREEN,
            // Default is Colors.white.
            handleAndroidBackButtonPress: true,
            // Default is true.
            resizeToAvoidBottomInset: true,
            // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
            stateManagement: true,
            // Default is true.
            hideNavigationBarWhenKeyboardShows: true,
            // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
            decoration: const NavBarDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              colorBehindNavBar: Constants.LIGHT_GREEN,
            ),
            popAllScreensOnTapOfSelectedTab: true,
            popActionScreens: PopActionScreensType.all,
            itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
            navBarStyle: NavBarStyle.style19, // Choose the nav bar style with this property.
          );
  }
}

List<Widget> _buildScreens() {
  return [
    const HomePage(),
    const SearchScreen(),
    const ProfileScreen()
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.groups),
      title: ("Community"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary:Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search_rounded),
      title: ("Search"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary:Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.account_circle),
      title: ("Account"),
      activeColorPrimary: Colors.blue,
      inactiveColorPrimary: Colors.grey,
    ),
  ];
}
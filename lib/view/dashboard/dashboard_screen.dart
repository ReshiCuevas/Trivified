import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:tech_media/res/color.dart';
import 'package:tech_media/view/dashboard/profile/profile_screen.dart';
import 'package:tech_media/view/dashboard/user/user_screen.dart';
import '../quizview/pages/home.dart';
import 'Home/HomeScreen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final controller = PersistentTabController(initialIndex: 0);

  /// List of screens
  List<Widget> _screens() {
    return [
      HomePage(),
      // const AllUserScreen(),
      const ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navbarItem() {
    return [
      PersistentBottomNavBarItem(
          icon: const FaIcon(
            FontAwesomeIcons.solidLightbulb,
          ),
          activeColorPrimary: AppColors.whiteColor,
          inactiveIcon:
              const FaIcon(FontAwesomeIcons.lightbulb, color: Colors.white)),
      PersistentBottomNavBarItem(
          icon: const FaIcon(FontAwesomeIcons.userTie, size: 22),
          activeColorPrimary: AppColors.whiteColor,
          inactiveIcon: const FaIcon(FontAwesomeIcons.user,
              size: 20, color: Colors.white)),
    ];
  }

  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_canExit) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Press back again to exit',
                style: TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.indigoAccent,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.all(20),
          ));
          _canExit = true;
          Timer(const Duration(seconds: 2), () {
            _canExit = false;
          });
          return false;
        }
      },
      child: PersistentTabView(
        context,
        screens: _screens(),
        items: _navbarItem(),
        padding: const NavBarPadding.only(top: 20, bottom: 8),
        backgroundColor: Colors.indigo,
        controller: controller,
        navBarStyle: NavBarStyle.style14,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        stateManagement: true,
        navBarHeight: 70,
      ),
    );
  }
}

// Scaffold(
// appBar: AppBar(elevation: 1,
// actions: [
// IconButton(icon: Icon(Icons.logout),
// onPressed: () {
// SessionController().userId = '';
// Navigator.pushNamed(context, RouteName.loginView);
// },),
// SizedBox(height: 10),
// ],
// ),
// body: Column(children: [],),
// );

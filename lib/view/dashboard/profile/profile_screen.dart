import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:tech_media/ViewModel/profile/profile_controller.dart';
import 'package:tech_media/ViewModel/services/session_manager.dart';
import 'package:tech_media/res/color.dart';
import 'package:tech_media/utils/routes/route_name.dart';
import 'package:tech_media/view/login/login_screen.dart';
import 'package:tech_media/widgets/RoundButton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ref = FirebaseDatabase.instance.ref('user');
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration: const BoxDecoration(color: Colors.indigo),
                height: 300,
              ),
            ),
            ChangeNotifierProvider(
              create: (_) => ProfileController(),
              child: Consumer<ProfileController>(
                builder: (context, provider, child) {
                  return SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StreamBuilder(
                          stream: ref
                              .child(SessionController().userId.toString())
                              .onValue,
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (!snapshot.hasData) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 140, vertical: 300),
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              Map<dynamic, dynamic> map =
                                  snapshot.data!.snapshot.value;
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: () {
                                      provider.pickImage(context);
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 130,
                                            width: 130,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                border: Border.all(
                                                    color: AppColors.whiteColor,
                                                    width: 5)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: provider.image == null
                                                    ? map['profile']
                                                                .toString() ==
                                                            ""
                                                        ? const Icon(
                                                            Icons.person,
                                                            size: 60,
                                                          )
                                                        : Image.network(
                                                            map['profile']
                                                                        .toString() ==
                                                                    ''
                                                                ? map['profile']
                                                                : map['profile']
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                          )
                                                    : Stack(
                                                        children: [
                                                          Image.file(
                                                              fit: BoxFit.cover,
                                                              File(provider
                                                                  .image!
                                                                  .path)),
                                                          const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        ],
                                                      )),
                                          ),
                                        ),
                                        const Positioned(
                                          top: 112,
                                          child: InkWell(
                                            // onTap: () {
                                            //
                                            // },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  AppColors.whiteColor,
                                              radius: 14,
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 100,
                                    child: RoundButton(
                                        color: Colors.white,
                                        textColor: Colors.indigo,
                                        btntxt: 'Edit Info',
                                        ontap: () {
                                          provider.showDialogEditProfile(
                                              context,
                                              map['username'],
                                              map['phoneNumber'].toString());
                                        }),
                                  ),
                                  const SizedBox(height: 20),
                                  const SizedBox(height: 2),
                                  ReuseRow(
                                    title: 'Username',
                                    value: map['username'].toString() == ''
                                        ? 'username'
                                        : map['username'],
                                    iconData: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 20),
                                  ReuseRow(
                                    title: 'Email',
                                    value: map['email'].toString() == ''
                                        ? 'abc@gmail.com'
                                        : map['email'],
                                    iconData: Icons.email_outlined,
                                  ),
                                  // SizedBox(height: 20),
                                  // ReuseRow(
                                  //   title: 'User ID',
                                  //   value: map['onlineStatus'],
                                  //   iconData: Icons.verified_user_outlined,
                                  // ),
                                  const SizedBox(height: 20),
                                  ReuseRow(
                                    title: 'Phone',
                                    value: map['phoneNumber'].toString() == ''
                                        ? 'xxx-xxx-xxx'
                                        : map['phoneNumber'].toString(),
                                    iconData: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 20),
                                  RoundButton(
                                    btntxt: 'Log Out',
                                    ontap: _onWillPop,
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text('Something went wrong!'),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: const Text("Are you sure you want to Log Out?"),
            title: const Text("Warning!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Yes"),
                onPressed: () async {
                  final auth = FirebaseAuth.instance;
                  signOutFromGoogle();
                  await auth.signOut().then((value) =>
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: const LoginScreen(), withNavBar: false));
                },
              ),
              TextButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return resp ?? false;
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}

class ReuseRow extends StatelessWidget {
  const ReuseRow(
      {Key? key,
      required this.value,
      required this.iconData,
      required this.title})
      : super(key: key);

  final IconData iconData;
  final String title;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(iconData),
          title: Text(
            title,
          ),
          trailing: Text(value, overflow: TextOverflow.ellipsis),
        ),
        const Divider(
          color: AppColors.dividedColor,
        )
      ],
    );
  }
}

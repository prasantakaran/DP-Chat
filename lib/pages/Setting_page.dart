// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/AuthenticatedUser/AuthUser_Profile.dart';

// import 'package:flutter_application_2/pages/Your_Own_profile.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_application_2/widgets/loadingdialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  Details detailsobj;
  SettingPage(this.detailsobj);
  @override
  State<SettingPage> createState() => _SettingPageState(detailsobj);
}

class _SettingPageState extends State<SettingPage> {
  Details detailsobj;
  _SettingPageState(this.detailsobj);
  String url = '';
  late SharedPreferences sp;

  @override
  Widget build(BuildContext context) {
    ProfileController _profileController = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appColor,
        title: Text(
          "Setting",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IndividualUserProfile(detailsobj),
                  ),
                ).then((value) {
                  setState(() {});
                });
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: detailsobj.photo!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: detailsobj.photo!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageBuilder: (context, imageProvider) {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(image: imageProvider),
                                ),
                              ),
                            );
                          },
                        )
                      : Icon(Icons.person),
                ),
                trailing: IconButton(
                  onPressed: () {
                    _profileController.getCurrentUser();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              IndividualUserProfile(detailsobj)),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_outlined,
                    size: 30,
                  ),
                  // color: Colors.green,
                ),
                title: AutoSizeText(
                  detailsobj.name.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: 0.4),
                ),
                subtitle: Text(
                  detailsobj.phone!,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.2),
                ),
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          Get.defaultDialog(
            // barrierDismissible: false,
            actions: [
              Lottie.asset("assets/animations/logout.json",
                  width: 250,
                  height: 200,
                  // fit: BoxFit.cover,
                  alignment: Alignment.topCenter)
            ],
            title: 'Are You Sure!.',
            content: Text("Do You Wanna LOGOUT.?"),
            textConfirm: 'Confirm',

            onConfirm: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const LoadingDialog();
                  });
              Timer(const Duration(seconds: 2), () async {
                sp = await SharedPreferences.getInstance();
                sp.clear();
                _profileController.logoutUser();
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => MyForm()),
                //     (Route<dynamic> route) => false);
              });
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            buttonColor: Colors.red,
            textCancel: 'Cencel',
            onCancel: () {
              // Navigator.pop(context);
            },
          );
        },
        label: Text(
          "LOGOUT",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Colors.white),
        ),
        icon: Icon(
          color: Colors.white,
          Icons.logout_outlined,
          size: 25,
        ),
      ),
    );
  }
}

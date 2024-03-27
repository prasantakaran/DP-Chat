import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/Account_delete.dart';
import 'package:flutter_application_2/pages/Individual_Profile_Details.dart';

// import 'package:flutter_application_2/pages/Your_Own_profile.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/form.dart';
import 'package:flutter_application_2/pages/loadingdialog.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 24, 182, 161),
        title: Text("Setting"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 158, 178, 174),
          child: ListView(children: [
            Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            IndividualProfileDetails(detailsobj)),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: ListTile(
                  leading: detailsobj.photo != ""
                      ? CircleAvatar(
                          radius: 30,
                          child: CachedNetworkImage(
                            imageUrl: Myurl.fullurl +
                                Myurl.imageurl +
                                detailsobj.photo,
                            // placeholder: (context, url) =>
                            //     const CircularProgressIndicator(),

                            imageBuilder: (context, imageProvider) {
                              return Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    image:
                                        DecorationImage(image: imageProvider),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          radius: 30,
                          child: Text(
                            detailsobj.name[0].toUpperCase(),
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ),
                  // detailsobj.photo != ""
                  //     ? CircleAvatar(
                  //         radius: 30,
                  //         backgroundImage: NetworkImage(
                  //           Myurl.fullurl + Myurl.imageurl + detailsobj.photo,
                  //         ),
                  //       )
                  //     : CircleAvatar(
                  //         radius: 30,
                  //         child: Text(
                  //           detailsobj.name[0].toUpperCase(),
                  //           style: TextStyle(fontSize: 30),
                  //         ),
                  //       ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IndividualProfileDetails(detailsobj)),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward_outlined,
                      size: 30,
                    ),
                    // color: Colors.green,
                  ),
                  title: Text(
                    detailsobj.name.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.4),
                  ),
                  subtitle: Text(
                    detailsobj.phone,
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2),
                  ),
                ),
              ),
            ),
            Container(
              child: Divider(thickness: 1.5),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => AccountDelete()));
            //     },
            //     child: ListTile(
            //       leading: Icon(
            //         Icons.delete_outlined,
            //         size: 30,
            //       ),
            //       trailing: Icon(
            //         Icons.arrow_forward_outlined,
            //         size: 30,
            //       ),
            //       title: Text(
            //         "Account Delete",
            //         style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Divider(thickness: 1.5),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListTile(
                  // title: TextButton.icon(
                  //   onPressed: () async {
                  //     return showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) => AlertDialog(
                  //         title: const Text('Are You Sure?'),
                  //         content: const Text('Do you wanna Log Out?'),
                  //         actions: [
                  //           TextButton(
                  //             onPressed: () {
                  //               Navigator.pop(context);
                  //             },
                  //             child: const Text('Cancel'),
                  //           ),
                  //           TextButton(
                  //             onPressed: () async {
                  //               showDialog(
                  //                   context: context,
                  //                   builder: (context) {
                  //                     return const LoadingDialog();
                  //                   });
                  //               Timer(const Duration(seconds: 2), () async {
                  //                 sp = await SharedPreferences.getInstance();
                  //                 sp.clear();
                  //                 Navigator.pushAndRemoveUntil(
                  //                     context,
                  //                     MaterialPageRoute(
                  //                         builder: (context) => MyForm()),
                  //                     (Route<dynamic> route) => false);
                  //               });
                  //             },
                  //             child: Text("OK"),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  //   icon: Icon(
                  //     Icons.logout,
                  //     size: 30,
                  //     color: Colors.red,
                  //   ),
                  //   label: Text(
                  //     'LOGOUT',
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.red),
                  //   ),
                  // ),
                  ),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyForm()),
                    (Route<dynamic> route) => false);
              });
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            buttonColor: Colors.red,
            textCancel: 'Cencel',
            onCancel: () {
              // Navigator.pop(context);
            },
          );

          // return showDialog(
          //   context: context,
          //   builder: (BuildContext context) => AlertDialog(
          //     title: const Text('Are You Sure?'),
          //     content: const Text('Do you wanna LogOut?'),
          //     actions: [
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //         child: const Text(
          //           'Cancel',
          //           style: TextStyle(
          //               color: Colors.green,
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () async {
          //           showDialog(
          //               context: context,
          //               builder: (context) {
          //                 return const LoadingDialog();
          //               });
          //           Timer(const Duration(seconds: 2), () async {
          //             sp = await SharedPreferences.getInstance();
          //             sp.clear();
          //             Navigator.pushAndRemoveUntil(
          //                 context,
          //                 MaterialPageRoute(builder: (context) => MyForm()),
          //                 (Route<dynamic> route) => false);
          //           });
          //         },
          //         child: Text(
          //           "OK",
          //           style: TextStyle(
          //               color: Colors.red,
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ],
          //   ),
          // );
        },
        label: Text(
          "LogOut",
          style: TextStyle(fontSize: 16, letterSpacing: 2),
        ),
        icon: Icon(Icons.logout_outlined),
      ),
    );
  }
}

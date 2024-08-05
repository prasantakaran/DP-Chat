// ignore_for_file: avoid_print, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, implementation_imports, unnecessary_import, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:flutter_application_2/Controller/StatusController.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/AuthenticatedUser/AuthUser_Profile.dart';
import 'package:flutter_application_2/pages/Setting_page.dart';
import 'package:flutter_application_2/pages/Dashboard/Conversactions_Tabs.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/ChatController.dart';
import '../../Controller/Contact_Controller.dart';
import '../../Controller/NotificationController.dart';

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with WidgetsBindingObserver {
  String name = '', email = '', bio = '', photo = '', phone = '', id = '';
  late SharedPreferences sp;
  late Details detailsobj = Details(
      name: name, bio: bio, email: email, phone: phone, photo: photo, uid: id);
  final MessageController _chatControler = Get.put(MessageController());
  final NotificationController _notificationController =
      Get.put(NotificationController());

  // _DashBoardState(this.detailsobj);
  List<Widget> tablist = [];
  Future getUserDetails() async {
    sp = await SharedPreferences.getInstance();

    name = sp.getString("name") ?? '';
    email = sp.getString("email") ?? '';
    bio = sp.getString("bio") ?? '';
    photo = sp.getString("photo") ?? '';
    phone = sp.getString("phone") ?? '';
    id = sp.getString("uid") ?? '';
  }

  Widget tabWidget(String name, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getUserDetails().whenComplete(() {
      setState(() {
        detailsobj = Details(
          name: name,
          bio: bio,
          email: email,
          phone: phone,
          photo: photo,
          uid: id,
        );
      });
      _notificationController.getNotificationToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    StatusController statusController = Get.put(StatusController());
    ProfileController _controller = Get.put(ProfileController());
    final ContactController _contactController = Get.put(ContactController());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leading: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IndividualUserProfile(detailsobj),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 8),
                child: CircleAvatar(
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
                      : Icon(
                          Icons.person,
                          size: 26,
                        ),
                ),
              ),
            ),
            backgroundColor: appColor,
            title: Text(
              "DP Chat",
              style: TextStyle(
                letterSpacing: 0.4,
                fontSize: 20,
                fontFamily: 'PangolinRegular',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    _chatControler.getCurrentChatsRoom();
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
              PopupMenuButton<String>(
                iconColor: Colors.white,
                onSelected: (Value) {
                  print(Value);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      // padding:
                      //     EdgeInsets.only(top: 3, bottom: 3, left: 3, right: 3),
                      child: Center(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SettingPage(detailsobj)));
                          },
                          icon: Icon(Icons.settings),
                          label: Text(
                            'Setting',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 1,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  children: <Widget>[
                    AutoSizeText(
                      "Conversations",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                // height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                    color: appColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
              ),
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      Conversactions_Tabs(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

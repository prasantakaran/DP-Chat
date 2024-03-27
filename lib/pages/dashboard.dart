import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/Contact_Access.dart';
import 'package:flutter_application_2/pages/Group_page.dart';
import 'package:flutter_application_2/pages/Individual_Profile_Details.dart';
import 'package:flutter_application_2/pages/Setting_page.dart';
import 'package:flutter_application_2/pages/Status_page.dart';
import 'package:flutter_application_2/pages/ConversationList.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/form.dart';
import 'package:flutter_application_2/pages/varified_chat.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  // Details detailsobj;
  // DashBoard(this.detailsobj);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String name = '', email = '', bio = '', photo = '', phone = '', id = '';
  late SharedPreferences sp;
  late Details detailsobj = Details(name, email, bio, photo, phone, id);

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
    tablist.add(tabWidget("CHAT", Icons.chat));
    // tablist.add(tabWidget("Group", Icons.group));
    // tablist.add(tabWidget("Status", Icons.branding_watermark));
    getUserDetails().whenComplete(() {
      setState(() {
        detailsobj = Details(name, email, bio, photo, phone, id);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 1,
        child: Scaffold(
          // appBar: AppBar(
          //   leading: InkWell(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) =>
          //                   IndividualProfileDetails(detailsobj)));
          //     },
          //     child: Container(
          //       margin: EdgeInsets.only(left: 8),
          //       child: detailsobj.photo != ""
          //           ? CircleAvatar(
          //               radius: 30,
          //               child: CachedNetworkImage(
          //                 imageUrl:
          //                     Myurl.fullurl + Myurl.imageurl + detailsobj.photo,
          //                 // placeholder: (context, url) =>
          //                 //     const CircularProgressIndicator(),
          //                 imageBuilder: (context, imageProvider) {
          //                   return Padding(
          //                     padding: const EdgeInsets.all(4),
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         shape: BoxShape.circle,
          //                         color: Colors.white,
          //                         image: DecorationImage(image: imageProvider),
          //                       ),
          //                     ),
          //                   );
          //                 },
          //               ),
          //             )
          //           : CircleAvatar(
          //               backgroundColor: Colors.blueGrey,
          //               radius: 30,
          //               child: Icon(Icons.person),
          //             ),
          //     ),
          //   ),
          //   backgroundColor: Color.fromARGB(255, 24, 182, 161),
          //   title: Text(
          //     "DP Chat",
          //     style: TextStyle(
          //       letterSpacing: 0.6,
          //       fontSize: 24,
          //       fontFamily: 'PangolinRegular',
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   elevation: 0,
          //   actions: [
          //     IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          //     PopupMenuButton<String>(
          //       onSelected: (Value) {
          //         print(Value);
          //       },
          //       itemBuilder: (BuildContext context) {
          //         return [
          //           // PopupMenuItem(
          //           //   child: Center(
          //           //     child: TextButton.icon(
          //           //         onPressed: () {},
          //           //         icon: Icon(Icons.group),
          //           //         label: Text('NewGroup')),
          //           //   ),
          //           // ),
          //           PopupMenuItem(
          //             padding:
          //                 EdgeInsets.only(top: 3, bottom: 3, left: 3, right: 3),
          //             child: Center(
          //               child: TextButton.icon(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                     Navigator.push(
          //                         context,
          //                         MaterialPageRoute(
          //                             builder: (context) =>
          //                                 SettingPage(detailsobj)));
          //                   },
          //                   icon: Icon(Icons.settings),
          //                   label: Text(
          //                     'Setting',
          //                     style: TextStyle(fontSize: 17),
          //                   )),
          //             ),
          //           ),
          //         ];
          //       },
          //     ),
          //   ],
          //   bottom: PreferredSize(
          //     child: TabBar(
          //       tabs: tablist,
          //       dividerColor: Colors.greenAccent,
          //       indicatorColor: Color.fromARGB(255, 143, 228, 220),
          //       unselectedLabelColor: Colors.blueGrey,
          //       // indicatorWeight: 5,
          //       labelStyle: TextStyle(fontWeight: FontWeight.bold),
          //       splashFactory: NoSplash.splashFactory,
          //     ),
          //     preferredSize: Size.fromHeight(50),
          //   ),
          // ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "DP Chat",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            letterSpacing: 0.6,
                            fontSize: 24,
                            fontFamily: 'PangolinRegular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          // radius: 27,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          IndividualProfileDetails(
                                              detailsobj)));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: detailsobj.photo != ""
                                  ? CircleAvatar(
                                      radius: 27,
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
                                                image: DecorationImage(
                                                    image: imageProvider),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blueGrey,
                                      radius: 27,
                                      child: Icon(Icons.person),
                                    ),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (Value) {
                            print(Value);
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                padding: EdgeInsets.only(
                                    top: 3, bottom: 3, left: 3, right: 3),
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
                                        style: TextStyle(fontSize: 17),
                                      )),
                                ),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      "Chats",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 24, 182, 161),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45))),
              ),
              // Container(
              //   padding: EdgeInsets.all(15),
              //   child: TextField(
              //     onChanged: (value) {},
              //     decoration: InputDecoration(
              //         hintText: 'Search',
              //         suffixIcon: Icon(Icons.search),
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(20),
              //             borderSide: BorderSide()),
              //         contentPadding:
              //             EdgeInsets.symmetric(vertical: 10, horizontal: 10)),
              //   ),
              // ),
              Flexible(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(children: [ChattingListPage()])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

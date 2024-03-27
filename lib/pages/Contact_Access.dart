import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/Individual_Chat_Page.dart';
import 'package:flutter_application_2/pages/ProfileShow.dart';
import 'package:flutter_application_2/pages/Show_Contact_image.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactAccess extends StatefulWidget {
  const ContactAccess({super.key});

  @override
  State<ContactAccess> createState() => _ContactAccessState();
}

class _ContactAccessState extends State<ContactAccess> {
  Icon searchicon = Icon(Icons.search);
  List<Details> searchname = [];
  Widget appbartitle = Column(
    children: [
      Text("Contacts"),
      // Text("235contacts"),
    ],
  );
  List<Contact> contacts = []; //for storing All Contact
  List<String> phno = []; //for storing PhoneNumber
  List<String> contactname = []; //for storing Name
  List<Details> userlist = []; //for storing All UserDetails
  bool permissionDenied = false;
  final String apidata = "All_Data_fetch.php";
  bool open = false;
  bool notopen = false;

  Future getUserDetails() async {
    try {
      var response =
          await http.get(Uri.http(Myurl.mainurl, Myurl.suburl + apidata));
      var jsondata = jsonDecode(response.body.toString());
      // String filecatch = "";
      // var dir = getTemporaryDirectory();
      // File file = new File(dir);
      if (jsondata['status'] == true) {
        userlist.clear();
        searchname.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          String phone = jsondata['data'][i]['phone'];
          int index = phno.indexOf(phone);
          if (index != -1) {
            Details userdata = Details(
                contactname[index],
                jsondata['data'][i]['email'],
                jsondata['data'][i]['ubio'],
                jsondata['data'][i]['uphoto'],
                jsondata['data'][i]['phone'],
                jsondata['data'][i]['uid']);

            setState(() {
              userlist.add(userdata);
              searchname.add(userdata);
            });
          }
        }
      } else {
        Fluttertoast.showToast(msg: jsondata["msg"]);
      }
      return userlist;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _filterItems(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchname.clear();
        searchname = userlist;
      });
    } else {
      setState(() {
        searchname = userlist
            .where((item) =>
                item.name.toLowerCase().contains(query) ||
                item.phone.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact().whenComplete(() {
      setState(() {
        getUserDetails();
      });
    });
  }

  Future getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isEmpty ||
            contacts[i].phones[0].normalizedNumber.length < 10) continue;
        //print(contacts[i]);
        phno.add(contacts[i].phones[0].normalizedNumber.substring(3));
        contactname.add(contacts[i].displayName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            appbartitle,
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    if (this.searchicon.icon == Icons.search) {
                      this.searchicon = Icon(Icons.cancel);
                      this.appbartitle = TextField(
                        onChanged: (value) {
                          setState(() {
                            open = true;
                            notopen = true;
                          });
                          _filterItems(value);
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search name or number..."),
                        style: TextStyle(color: Colors.white, fontSize: 17.0),
                      );
                    } else {
                      this.searchicon = Icon(
                        Icons.search,
                        // size: 5,
                      );
                      this.appbartitle = Text(
                        "Contacts",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 0.6),
                      );
                    }
                  });
                },
                icon: searchicon),
          )
        ],
        elevation: 0,
      ),
      body: Column(children: [
        if (notopen == false)
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromARGB(255, 60, 72, 79),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: userlist.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            UserProflieShow(userlist[index]));
                                  },
                                  child: userlist[index].photo != ""
                                      ? CircleAvatar(
                                          radius: 28,
                                          child: CachedNetworkImage(
                                            imageUrl: Myurl.fullurl +
                                                Myurl.imageurl +
                                                userlist[index].photo,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                          image:
                                                              imageProvider)),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 28,
                                          child: Text(
                                            userlist[index]
                                                .name[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualChatPage(
                                                      userlist[index])));
                                    },
                                    title: Text(
                                      userlist[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.3,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      userlist[index].phone,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: userlist.length,
                      )
                    : Center(
                        child: SpinKitSpinningLines(
                        color: Colors.blue,
                      ))),
          ),
        if (open == true)
          Expanded(
            child: Container(
                width: MediaQuery.of(context).size.width,
                color: Color.fromARGB(255, 60, 72, 79),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: searchname.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.all(6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            UserProflieShow(searchname[index]));
                                  },
                                  child: searchname[index].photo != ""
                                      ? CircleAvatar(
                                          radius: 28,
                                          child: CachedNetworkImage(
                                            imageUrl: Myurl.fullurl +
                                                Myurl.imageurl +
                                                searchname[index].photo,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                          image:
                                                              imageProvider)),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 28,
                                          child: Text(
                                            searchname[index]
                                                .name[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualChatPage(
                                                      searchname[index])));
                                    },
                                    title: Text(
                                      searchname[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.3,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                    subtitle: Text(
                                      searchname[index].phone,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: searchname.length,
                      )
                    : Center(
                        child: Text(
                          'Not Found',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )),
          ),
      ]),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Controller/ChatController.dart';
import 'package:flutter_application_2/Controller/Contact_Controller.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/ChatsPages/Individual_Chat_Page.dart';
import 'package:flutter_application_2/pages/ProfileShow.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ContactAccess extends StatefulWidget {
  const ContactAccess({super.key});

  @override
  State<ContactAccess> createState() => _ContactAccessState();
}

class _ContactAccessState extends State<ContactAccess> {
  // List<Details> userlist = [];
  List<Details> filtedContacts = [];
  final _searchController = TextEditingController();
  bool isSearch = false;
  final ContactController _contactController = Get.put(ContactController());
  MessageController msgControler = Get.put(MessageController());

  // Future<List<Details>> getUserDetails() async {
  //   try {
  //     // Reference to Firestore
  //     var firestore = FirebaseFirestore.instance;
  //     // Fetching user data from the 'users' collection
  //     var snapshot = await firestore.collection('users').get();
  //     var docs = snapshot.docs;

  //     if (docs.isNotEmpty) {
  //       userlist.clear();

  //       for (var doc in docs) {
  //         var data = doc.data();
  //         String phone = data['phone'] ?? ''; // Ensure phone is not null
  //         int index = _contactController.phno.indexOf(phone);

  //         if (index != -1) {
  //           Details userdata = Details(
  //             name: _contactController.contactname[index].toString(),
  //             email: data['email'], // Handle null value
  //             bio: data['bio'], // Handle null value
  //             photo: data['photo'], // Handle null value
  //             phone: data['phone'], // Handle null value
  //             uid: data['uid'], // Handle null value
  //           );

  //           setState(() {
  //             userlist.add(userdata);
  //           });
  //         }
  //       }
  //     } else {
  //       Fluttertoast.showToast(msg: "No data found");
  //     }
  //     return userlist;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //     return [];
  //   }
  // }

  void _filterItems(String query) {
    query = query.toLowerCase();
    setState(() {
      filtedContacts.clear();
    });
    if (query.isEmpty) {
      setState(() {
        _contactController.userlist;
      });
    } else {
      List<Details> filteredList = [];
      filteredList.addAll(
        _contactController.userlist.where(
          (item) =>
              item.name!.toLowerCase().contains(query.toLowerCase()) ||
              item.phone!.contains(query),
        ),
      );
      setState(() {
        filtedContacts = filteredList;
      });
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _contactController.getContact().whenComplete(() {
  //     setState(() {
  //       _contactController.getUserDetails();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appColor,
        title: Text(
          'Contacts select',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchController.text = value;
                isSearch = !isSearch;
              });
              _filterItems(value.trim());
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              hintText: 'Search contact',
              hintStyle: TextStyle(
                fontSize: 15,
                color: appColor.withOpacity(0.8),
              ),
              suffixIcon: _searchController.text.isEmpty
                  ? SizedBox()
                  : IconButton(
                      onPressed: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(Icons.close),
                    ),
              prefixIcon: Icon(Icons.search),

              // suffixIcon: Icon(Icons.close),
            ),
          ),
        ),
        Expanded(
          child: Obx(
            () => Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _contactController.userlist.isNotEmpty
                  ? _searchController.text.isNotEmpty && filtedContacts.isEmpty
                      ? Center(
                          child: Text(
                            'No contact found for "${_searchController.text}"',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchController.text.isEmpty
                              ? _contactController.userlist.length
                              : filtedContacts.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (_contactController.userlist.isEmpty) {
                              return Center(
                                child: Text('No User Found'),
                              );
                            }
                            final contacts = _searchController.text.isEmpty
                                ? _contactController.userlist[index]
                                : filtedContacts[index];
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
                                            UserProflieShow(contacts),
                                      );
                                    },
                                    child: contacts.photo!.isNotEmpty
                                        ? CircleAvatar(
                                            radius: 28,
                                            child: CachedNetworkImage(
                                              imageUrl: contacts.photo!,
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
                                                          image: imageProvider),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 25,
                                            child: Icon(Icons.person),
                                          ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      onTap: () {
                                        String? roomId = msgControler
                                            .getRoomId(contacts.uid!);

                                        Get.off(
                                            () => IndividualChatPage(contacts));
                                      },
                                      title: Row(
                                        children: [
                                          Text(
                                            contacts.name!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 17),
                                          ),
                                          Spacer(),
                                          contacts.uid ==
                                                  msgControler
                                                      .auth.currentUser!.uid
                                              ? AutoSizeText(
                                                  'You',
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: appColor),
                                                )
                                              : AutoSizeText(''),
                                        ],
                                      ),
                                      subtitle: contacts.uid ==
                                              msgControler.auth.currentUser!.uid
                                          ? AutoSizeText(
                                              'Message yourself',
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 8,
                                              ),
                                            )
                                          : AutoSizeText(
                                              contacts.phone!,
                                              style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitSpinningLines(
                          lineWidth: 3,
                          color: appColor,
                          size: 50,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Please wait...',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ]),
    );
  }
}

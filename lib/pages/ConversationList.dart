import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/Contact_Access.dart';
import 'package:flutter_application_2/pages/Individual_Chat_Page.dart';
import 'package:flutter_application_2/pages/ProfileShow.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/chatcontroler.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'loadingdialog.dart';
import 'messageDetails.dart';

class ChattingListPage extends StatefulWidget {
  const ChattingListPage({super.key});

  @override
  State<ChattingListPage> createState() => _ChattingListPageState();
}

class _ChattingListPageState extends State<ChattingListPage> {
  List<Contact> contacts = []; //for storing All Contact
  List<String> phno = []; //for storing PhoneNumber
  List<String> contactname = []; //for storing Name
  List<Details> userlist = []; //for storing All UserDetails
  final String apidata = "All_Data_fetch.php";
  // List<Details> currentmsg_user = [];
  List<MessageDetails> last_current_msg = [];
  List timemsg = [];
  CurrentMessageUser currentmsg_user = Get.put(CurrentMessageUser());
  List<Details> _allItem = [];

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

  Future getUserDetails() async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) {
    //     return const LoadingDialog();
    //   },
    // );
    try {
      var response =
          await http.get(Uri.http(Myurl.mainurl, Myurl.suburl + apidata));
      var jsondata = jsonDecode(response.body.toString());

      if (jsondata['status'] == true) {
        // Navigator.pop(context);
        userlist.clear();
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

  late SharedPreferences sp;
  String send_id = '';
  Future getSenderid() async {
    sp = await SharedPreferences.getInstance();
    send_id = sp.getString('uid') ?? "";
  }

  Future getCurrentUserId(String currentuser_id) async {
    try {
      var data = {'user_id': currentuser_id};
      var res = await http.post(
          Uri.http(Myurl.mainurl, Myurl.suburl + 'current_message.php'),
          body: data);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        // print(jsondata);
        currentmsg_user.currentUser.clear();
        last_current_msg.clear();
        _allItem.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          if (jsondata['data'][i]['sender_id'] == currentuser_id) {
            for (int j = 0; j < userlist.length; j++) {
              if (jsondata['data'][i]['receiver_id'] == userlist[j].uid &&
                  !currentmsg_user.currentUser.contains(userlist[j])) {
                currentmsg_user.currentUser.add(userlist[j]);
                _allItem.add(userlist[j]);
                MessageDetails currentdata = MessageDetails(
                    msg: jsondata['data'][i]['content'].toString(),
                    id: jsondata['data'][i]['id'].toString());
                last_current_msg.add(currentdata);
                // print(searchItem);

                break;
              }
            }
          } else {
            for (int j = 0; j < userlist.length; j++) {
              if (jsondata['data'][i]['sender_id'] == userlist[j].uid &&
                  !currentmsg_user.currentUser.contains(userlist[j])) {
                // print(userlist[j].uid);
                currentmsg_user.currentUser.add(userlist[j]);
                _allItem.add(userlist[j]);
                MessageDetails currentdata = MessageDetails(
                    msg: jsondata['data'][i]['content'],
                    id: jsondata['data'][i]['id']);
                last_current_msg.add(currentdata);
                // print(searchItem);

                break;
              }
            }
          }
          // print(searchItem);

          setState(() {});
        }
      } else {
        print('not send');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
  }

  bool isShowSearchItem = false;
  bool onlyCurrentItem = true;
  List<Details> searchItem = [];
  void _filterItems(String query) {
    query = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        // _allItem.clear();
        searchItem.clear();
        searchItem = _allItem;
      });
    } else {
      setState(() {
        searchItem = _allItem
            .where((item) =>
                item.name.toLowerCase().contains(query) ||
                item.phone.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  late IO.Socket socket;
  void connect() {
    socket = IO.io("http://192.168.25.187:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    socket.connect();
    socket.emit("dashboard", send_id);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message-recived", (data) async {
        print("Received");
        await getCurrentUserId(send_id);
        // messagesobj.chatmessage.add(Message.fromJosn(data["message"]));
        // scrollToEnd();
      });
    });
    print(socket.connected);
    socket.onDisconnect((_) {
      print("Disconnected Successfull");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContact().whenComplete(() {
      setState(() {
        getUserDetails().whenComplete(() {
          getSenderid().whenComplete(() {
            // connect();
            getCurrentUserId(send_id);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          child: TextField(
            onChanged: (value) {
              _filterItems(value);
            },
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide()),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // if (onlyCurrentItem == true)
          Expanded(
            child: Container(
                color: Colors.white70,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                    itemCount: currentmsg_user.currentUser.length,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        color: Colors.white70,
                        semanticContainer: true,
                        shadowColor: Colors.lightBlueAccent,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50))),
                        // color: Colors.grey,
                        child: Obx(
                          () => ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualChatPage(
                                      currentmsg_user.currentUser[index]),
                                ),
                              ).then((value) {
                                getContact().whenComplete(() {
                                  setState(() {
                                    getUserDetails().whenComplete(() {
                                      getSenderid().whenComplete(() {
                                        getCurrentUserId(send_id);
                                      });
                                    });
                                  });
                                });
                              });
                              ;
                            },
                            leading: currentmsg_user.currentUser[index].photo !=
                                    ''
                                ? InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => UserProflieShow(
                                              currentmsg_user
                                                  .currentUser[index]));
                                    },
                                    child: CircleAvatar(
                                      radius: 28,
                                      child: CachedNetworkImage(
                                        imageUrl: Myurl.fullurl +
                                            Myurl.imageurl +
                                            currentmsg_user
                                                .currentUser[index].photo,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        imageBuilder: (context, imageProvider) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  image: DecorationImage(
                                                      image: imageProvider)),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => UserProflieShow(
                                          currentmsg_user.currentUser[index],
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 28,
                                      child: Text(
                                        currentmsg_user
                                            .currentUser[index].name[0]
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                  ),
                            title: Text(
                              currentmsg_user.currentUser[index].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.3,
                                  fontSize: 18),
                            ),
                            // subtitle: Text(last_current_msg[index].msg,
                            //     maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      );
                    })),
          ),
          // if (isShowSearchItem == true)
          //   Expanded(
          //     child: Container(
          //       color: Colors.white70,
          //       padding: EdgeInsets.symmetric(vertical: 10),
          //       child: searchItem.isNotEmpty
          //           ? ListView.builder(
          //               itemCount: searchItem.length,
          //               itemBuilder: (BuildContext context, index) {
          //                 return Card(
          //                   color: Colors.white70,
          //                   semanticContainer: true,
          //                   shadowColor: Colors.lightBlueAccent,
          //                   margin: EdgeInsets.symmetric(
          //                       vertical: 8, horizontal: 12),
          //                   elevation: 10,
          //                   shape: const RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.only(
          //                           topLeft: Radius.circular(50),
          //                           bottomRight: Radius.circular(50))),
          //                   // color: Colors.grey,
          //                   child: Obx(
          //                     () => ListTile(
          //                       onTap: () {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                             builder: (context) =>
          //                                 IndividualChatPage(searchItem[index]),
          //                           ),
          //                         ).then((value) {
          //                           getContact().whenComplete(() {
          //                             setState(() {
          //                               getUserDetails().whenComplete(() {
          //                                 getSenderid().whenComplete(() {
          //                                   getCurrentUserId(send_id);
          //                                 });
          //                               });
          //                             });
          //                           });
          //                         });
          //                         ;
          //                       },
          //                       leading: searchItem[index].photo != ''
          //                           ? InkWell(
          //                               onTap: () {
          //                                 showDialog(
          //                                     context: context,
          //                                     builder: (context) =>
          //                                         UserProflieShow(
          //                                             searchItem[index]));
          //                               },
          //                               child: CircleAvatar(
          //                                 radius: 28,
          //                                 child: CachedNetworkImage(
          //                                   imageUrl: Myurl.fullurl +
          //                                       Myurl.imageurl +
          //                                       searchItem[index].photo,
          //                                   placeholder: (context, url) =>
          //                                       const CircularProgressIndicator(),
          //                                   imageBuilder:
          //                                       (context, imageProvider) {
          //                                     return Padding(
          //                                       padding:
          //                                           const EdgeInsets.all(4),
          //                                       child: Container(
          //                                         decoration: BoxDecoration(
          //                                             shape: BoxShape.circle,
          //                                             color: Colors.white,
          //                                             image: DecorationImage(
          //                                                 image:
          //                                                     imageProvider)),
          //                                       ),
          //                                     );
          //                                   },
          //                                 ),
          //                               ),
          //                             )
          //                           : InkWell(
          //                               onTap: () {
          //                                 showDialog(
          //                                     context: context,
          //                                     builder: (context) =>
          //                                         UserProflieShow(
          //                                             searchItem[index]));
          //                               },
          //                               child: CircleAvatar(
          //                                 radius: 28,
          //                                 child: Text(
          //                                   searchItem[index]
          //                                       .name[0]
          //                                       .toUpperCase(),
          //                                   style: TextStyle(fontSize: 22),
          //                                 ),
          //                               ),
          //                             ),
          //                       title: Text(
          //                         searchItem[index].name,
          //                         style: TextStyle(
          //                             fontWeight: FontWeight.w500,
          //                             letterSpacing: 0.3,
          //                             fontSize: 18),
          //                       ),
          //                       subtitle: Text(last_current_msg[index].msg,
          //                           maxLines: 1,
          //                           overflow: TextOverflow.ellipsis),
          //                     ),
          //                   ),
          //                 );
          //               })
          //           : Container(
          //               child: Text("not"),
          //             ),
          //     ),
          //   ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.message_outlined,
        ),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactAccess()))
              .whenComplete(() {
            setState(() {
              getContact().whenComplete(() {
                setState(() {
                  getUserDetails().whenComplete(() {
                    getSenderid().whenComplete(() {
                      getCurrentUserId(send_id);
                    });
                  });
                });
              });
            });
          });
        },
        elevation: 10,
        highlightElevation: 100,
        foregroundColor: Colors.grey,
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}

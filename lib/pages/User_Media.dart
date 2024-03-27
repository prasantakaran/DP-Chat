import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/View_Media.dart';
import 'package:flutter_application_2/pages/chat_information.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserMedia extends StatefulWidget {
  // const UserMedia({super.key});
  Details userobj;
  UserMedia(this.userobj);

  @override
  State<UserMedia> createState() => _UserMediaState(userobj);
}

class _UserMediaState extends State<UserMedia> {
  Details userobj;
  _UserMediaState(this.userobj);
  List<Attachment> imageslist = [];
  late SharedPreferences sp;
  Future getAttachment(String sender_id, String receiver_id) async {
    Map data = {'sender_id': sender_id, 'receiver_id': receiver_id};
    try {
      // print(data);
      var response = await http.post(
          Uri.http(Myurl.mainurl, Myurl.suburl + "All_Chat_image.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        imageslist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Attachment img =
              Attachment(attach: jsondata['data'][i]['attachment']);
          imageslist.add(img);
          // print(jsondata['data'][i]['attachment']);
        }
      }
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSender().whenComplete(() {
      getAttachment(sender_id, userobj.uid);
    });
  }

  String sender_id = '';
  Future getSender() async {
    sp = await SharedPreferences.getInstance();
    sender_id = sp.getString('uid') ?? "";
    print(sender_id);
  }

  @override
  Widget build(BuildContext context) {
    // double a = MediaQuery.of(context).size.height * 0.65;
    // double b = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Media"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey)),
          padding: EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: imageslist.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // childAspectRatio: b / a,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 4),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                        ),
                        body: Material(
                          child: SingleChildScrollView(
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl: Myurl.fullurl +
                                    Myurl.msgimageurl +
                                    imageslist[index].attach,
                                height:
                                    MediaQuery.of(context).size.height * 0.9,
                                // height: 100,
                                // width: 200,
                                width: MediaQuery.of(context).size.width,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                imageBuilder: (context, imageProvider) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  constraints: BoxConstraints(),
                  child: CachedNetworkImage(
                    imageUrl: Myurl.fullurl +
                        Myurl.msgimageurl +
                        imageslist[index].attach,
                    width: 150,
                    // height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    imageBuilder: (context, imageProvider) {
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                            // color: Colors.black,
                            image: DecorationImage(
                              image: imageProvider,
                              // fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

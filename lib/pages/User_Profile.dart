// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, must_be_immutable, no_logic_in_create_state, use_key_in_widget_constructors, implementation_imports, unnecessary_import

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  Details user;
  UserProfile(this.user);

  @override
  State<UserProfile> createState() => _UserProfileState(user);
}

class _UserProfileState extends State<UserProfile> {
  Details user;
  _UserProfileState(this.user);
  // List<Attachment> imageslist = [];
  late SharedPreferences sp;
  // Future getAttachment(String sender_id, String receiver_id) async {
  //   Map data = {'sender_id': sender_id, 'receiver_id': receiver_id};
  //   try {
  //     // print(data);
  //     var response = await http.post(
  //         Uri.http(Myurl.mainurl, Myurl.suburl + "All_Chat_image.php"),
  //         body: data);
  //     var jsondata = jsonDecode(response.body.toString());
  //     if (jsondata["status"] == true) {
  //       imageslist.clear();
  //       for (int i = 0; i < jsondata['data'].length; i++) {
  //         Attachment img =
  //             Attachment(attach: jsondata['data'][i]['attachment']);
  //         imageslist.add(img);
  //         // print(jsondata['data'][i]['attachment']);
  //       }
  //       setState(() {});
  //     }
  //     return imageslist;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //     print(e.toString());
  //   }
  // }

  String sender_id = '';
  Future getSender() async {
    sp = await SharedPreferences.getInstance();
    sender_id = sp.getString('uid') ?? "";
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getSender().whenComplete(() {
  //     getAttachment(sender_id, user.uid!);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          user.name!,
          style: TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                    // color: appColor,
                    gradient: LinearGradient(
                        colors: [appColor.withOpacity(0.5), appColor],
                        begin: FractionalOffset(0.0, 0.0),
                        end: FractionalOffset(1.0, 0.0),
                        // stops: [0.0, 2.0],
                        tileMode: TileMode.clamp),
                  ),
                ),
                Positioned(
                  bottom: -50.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                              title: Text(
                                user.name!,
                                style: TextStyle(fontSize: 22),
                              ),
                              elevation: 0.5,
                              backgroundColor: Colors.transparent,
                            ),
                            body: SafeArea(
                              child: Material(
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 26,
                                      ),
                                    ),
                                    Container(
                                      child: user.photo!.isNotEmpty
                                          ? Image.network(user.photo!)
                                          : Center(
                                              child: Text(
                                                "No Image",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    letterSpacing: 0.5,
                                                    color: Colors.white54,
                                                    fontSize: 20),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: appColor,
                          child: user.photo!.isNotEmpty
                              ? ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl: user.photo!,
                                    fit: BoxFit.cover,
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
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 75,
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10 * 7,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Text(
                user.phone!,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black26),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.brown,
                        ),
                        title: Text(
                          user.name!,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Icon(
                          Icons.email_outlined,
                          color: Colors.brown,
                        ),
                        title: Text(
                          user.email!,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.brown,
                        ),
                        title: Text(
                          user.bio!,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.4),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50 * 0.6,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Media",
            //         style: TextStyle(
            //             fontSize: 20,
            //             letterSpacing: 0.5,
            //             fontWeight: FontWeight.bold),
            //       ),
            //       IconButton(
            //           onPressed: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => UserMedia(user)));
            //           },
            //           icon: Icon(Icons.arrow_forward))
            //     ],
            //   ),
            // ),
            // Container(
            //   // padding: EdgeInsets.all(5),
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   height: MediaQuery.of(context).size.height * 0.2,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       color: Colors.black26),
            //   child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       return Container(
            //         margin: EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //             border: Border.all(color: Colors.blueGrey)),
            //         child: Image.network(
            //           cacheWidth: 165,
            //           Myurl.fullurl +
            //               Myurl.msgimageurl +
            //               imageslist[index].attach,
            //           width: 150,
            //         ),
            //       );
            //     },
            //     separatorBuilder: (context, index) => SizedBox(
            //       width: 10,
            //     ),
            //     itemCount: imageslist.length,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

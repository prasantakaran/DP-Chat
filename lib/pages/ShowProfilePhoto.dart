// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable, no_logic_in_create_state, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, await_only_futures, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewProfile extends StatefulWidget {
  // const ViewProfile({super.key});
  Details detailobj;
  ViewProfile(this.detailobj);

  @override
  State<ViewProfile> createState() => _ViewProfileState(detailobj);
}

class _ViewProfileState extends State<ViewProfile> {
  Details detailobj;
  _ViewProfileState(this.detailobj);
  late SharedPreferences sp;

  // Future getChangeImg(File uphoto, String id) async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return const LoadingDialog();
  //     },
  //   );

  //   try {
  //     var request = http.MultipartRequest(
  //         "POST", Uri.parse(Myurl.fullurl + "image_change.php"));

  //     request.files.add(await http.MultipartFile.fromBytes(
  //         'image', uphoto.readAsBytesSync(),
  //         filename: uphoto.path.split("/").last));
  //     request.fields['uid'] = id;

  //     var response = await request.send();
  //     var responded = await http.Response.fromStream(response);

  //     var jsondata = jsonDecode(responded.body);
  //     if (jsondata['status'] == 'true') {
  //       sp = await SharedPreferences.getInstance();

  //       detailobj.photo = jsondata['imgtitle'];
  //       sp.setString("photo", detailobj.photo!);

  //       setState(() {});

  //       Navigator.pop(context);

  //       Fluttertoast.showToast(
  //         gravity: ToastGravity.CENTER,
  //         msg: jsondata['msg'],
  //       );
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       Navigator.pop(context);
  //       Fluttertoast.showToast(
  //         gravity: ToastGravity.CENTER,
  //         msg: jsondata['msg'],
  //       );
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     Fluttertoast.showToast(
  //       gravity: ToastGravity.CENTER,
  //       msg: e.toString(),
  //     );
  //   }
  // }

  // Future deleteImage(String uid) async {
  //   Map data = {'uid': uid};
  //   sp = await SharedPreferences.getInstance();
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return const LoadingDialog();
  //     },
  //   );
  //   try {
  //     var res = await http.post(
  //         Uri.http(Myurl.mainurl, Myurl.suburl + "image_delete.php"),
  //         body: data);
  //     var jsondata = jsonDecode(res.body);
  //     if (jsondata['status'] == true) {
  //       Navigator.pop(context);
  //       print("Successfully Remove");
  //       setState(() {
  //         detailobj.photo = jsondata["imgtitle"];
  //         sp.setString("photo", jsondata["imgtitle"]);
  //       });
  //       Navigator.pop(context);
  //     }
  //     setState(() {});
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: e.toString());
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(detailobj.name!),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Color(0xff003049),
                      context: context,
                      builder: (context) => BottonSheet(context));
                },
                icon: Icon(Icons.edit))
          ],
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: detailobj.photo != ""
                ? InteractiveViewer(
                    maxScale: 5.0,
                    minScale: 0.01,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          // borderRadius: BorderRadius.circular(35),
                          image: DecorationImage(
                              image: NetworkImage(
                            detailobj.photo!,
                          )
                              // fit: BoxFit.fill,
                              )),
                    ),
                  )
                : Center(child: Text(detailobj.name!)),
          ),
        ),
      ),
    );
  }

  Widget BottonSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      height: size.height * 0.2,
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: detailobj.photo != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose Profile Image!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: Colors.blueGrey),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // deleteImage(detailobj.uid!);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.blueGrey,
                            size: 30,
                          ),
                        )
                      ],
                    )
                  : Container(
                      child: Text(
                        "Choose Profile Image!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.blueGrey),
                      ),
                    )),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // takephoto(ImageSource.gallery).whenComplete(() {
                  //   getChangeImg(pickedfile!, detailobj.uid!);
                  // });
                },
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.image,
                        color: Colors.purple,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(
                            letterSpacing: 0.4,
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 80.0,
              ),
              InkWell(
                onTap: () {
                  // takephoto(ImageSource.camera).whenComplete(() {
                  //   getChangeImg(pickedfile!, detailobj.uid!);
                  // });
                },
                child: Container(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.camera,
                        color: Colors.deepPurple,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(
                            letterSpacing: 0.4,
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  File? pickedfile;
  Future takephoto(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedfile = tempImage;
      });
      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

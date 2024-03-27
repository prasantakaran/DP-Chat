import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/ShowProfilePhoto.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/loadingdialog.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IndividualProfileDetails extends StatefulWidget {
  // const IndividualProfileDetails({super.key});
  Details detailsobj;
  IndividualProfileDetails(this.detailsobj);

  @override
  State<IndividualProfileDetails> createState() =>
      _IndividualProfileDetailsState(detailsobj);
}

class _IndividualProfileDetailsState extends State<IndividualProfileDetails> {
  Details detailsobj;
  _IndividualProfileDetailsState(this.detailsobj);

  File? pickedfile;

  TextEditingController name = TextEditingController();
  TextEditingController userbio = TextEditingController();
  GlobalKey<FormState> namekey = GlobalKey();
  GlobalKey<FormState> biokey = GlobalKey();
  late SharedPreferences sp;

  // ignore: non_constant_identifier_names
  Future getChangeImg(File uphoto, String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(Myurl.fullurl + "image_change.php"));

      request.files.add(await http.MultipartFile.fromBytes(
          'image', uphoto.readAsBytesSync(),
          filename: uphoto.path.split("/").last));
      request.fields['uid'] = id;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        sp = await SharedPreferences.getInstance();

        detailsobj.photo = jsondata['imgtitle'];
        sp.setString("photo", detailsobj.photo);

        setState(() {});

        Navigator.pop(context);

        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  Future deleteImage(String uid) async {
    Map data = {'uid': uid};
    sp = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var res = await http.post(
          Uri.http(Myurl.mainurl, Myurl.suburl + "image_delete.php"),
          body: data);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        Navigator.pop(context);
        print("Successfully Remove");
        setState(() {
          detailsobj.photo = jsondata["imgtitle"];
          sp.setString("photo", jsondata["imgtitle"]);
        });
      }
      // setState(() {});
      // Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> getNameUpadate(String name) async {
    Map data = {'phone': detailsobj.phone, 'uname': name};
    sp = await SharedPreferences.getInstance();
    if (namekey.currentState!.validate()) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(Myurl.mainurl, Myurl.suburl + "name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sp.setString("name", jsondata["uname"]);
            detailsobj.name = sp.getString('name') ?? '';
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> getBioUpdate(String bio) async {
    Map data = {'phone': detailsobj.phone, 'ubio': bio};
    sp = await SharedPreferences.getInstance();
    if (biokey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(Myurl.mainurl, Myurl.suburl + "Bio_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sp.setString("bio", jsondata["ubio"]);
            detailsobj.bio = jsondata["ubio"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Your Profile",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontStyle: FontStyle.italic),
          ),
          backgroundColor: Color.fromARGB(255, 24, 182, 161),
          // backgroundColor: Color.fromARGB(255, 102, 189, 166),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xff003049),
            padding: EdgeInsets.only(top: 70.0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 80.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ListTile(
                            title: Text(
                              "Name",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              detailsobj.name,
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.black87,
                                  fontSize: 16),
                            ),
                            leading: Icon(
                              Icons.person,
                              color: Colors.black54,
                              size: 35,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                name.text = detailsobj.name;

                                showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return Container(
                                        child: AlertDialog(
                                            title: Text(
                                              "Rename Your Name..",
                                              style:
                                                  TextStyle(letterSpacing: 0.6),
                                            ),
                                            content: Form(
                                                key: namekey,
                                                child: TextFormField(
                                                  validator: (Value) {
                                                    if (Value!.isEmpty) {
                                                      return "required name";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          hintText:
                                                              "Enter your name",
                                                          prefixIcon: Icon(
                                                              Icons.person)),
                                                  controller: name,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                )),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 241, 3, 3)),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    if (namekey.currentState!
                                                        .validate()) {
                                                      getNameUpadate(name.text);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Please Enter Your Name");
                                                    }
                                                  },
                                                  child: Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 21, 133, 31),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                            ]),
                                      );
                                    });
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ListTile(
                            title: const Text(
                              "Email",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              detailsobj.email,
                              style: const TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.black87,
                                  fontSize: 16),
                            ),
                            leading: const Icon(
                              Icons.email_outlined,
                              color: Colors.black54,
                              size: 35,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ListTile(
                            title: const Text(
                              "Number",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              detailsobj.phone,
                              style: const TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.black87,
                                  fontSize: 16),
                            ),
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.black54,
                              size: 35,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ListTile(
                            title: const Text(
                              "Bio",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              detailsobj.bio,
                              style: const TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.black87,
                                  fontSize: 16),
                            ),
                            leading: const Icon(
                              Icons.info_outline,
                              color: Colors.black54,
                              size: 35,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                userbio.text = detailsobj.bio;
                                showDialog(
                                    context: (context),
                                    builder: (context) {
                                      return Container(
                                        child: AlertDialog(
                                            title: Text("Update Your Bio"),
                                            content: Form(
                                              key: biokey,
                                              child: TextFormField(
                                                validator: (Value) {
                                                  if (Value!.isEmpty) {
                                                    return "required bio";
                                                  }
                                                  return null;
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            "update your bio",
                                                        prefixIcon: Icon(Icons
                                                            .info_outline)),
                                                controller: userbio,
                                                keyboardType:
                                                    TextInputType.name,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                // maxLines: 2,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cencel",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 241, 3, 3)),
                                                  )),
                                              TextButton(
                                                onPressed: () {
                                                  if (biokey.currentState!
                                                      .validate()) {
                                                    getBioUpdate(userbio.text);
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please Enter Bio");
                                                  }
                                                },
                                                child: const Text(
                                                  "Update",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 21, 133, 31),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ]),
                                      );
                                    });
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.black,
                              // iconSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (detailsobj.photo.isNotEmpty)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewProfile(detailsobj),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                        },
                        child: Container(
                          child: ClipOval(
                            child: pickedfile != null
                                ? Image.file(
                                    pickedfile!,
                                    width: 170,
                                    height: 170,
                                    fit: BoxFit.cover,
                                  )
                                :
                                // detailsobj.photo != ""
                                //     ? CachedNetworkImage(
                                //         imageUrl: Myurl.fullurl +
                                //             Myurl.imageurl +
                                //             detailsobj.photo,
                                //         width: 160,
                                //         height: 160,
                                //         fit: BoxFit.cover,
                                //         placeholder: (context, url) =>
                                //             const CircularProgressIndicator(),
                                //         imageBuilder: (context, imageProvider) {
                                //           return Padding(
                                //             padding: const EdgeInsets.all(4),
                                //             child: Container(
                                //               decoration: BoxDecoration(
                                //                 shape: BoxShape.circle,
                                //                 color: Colors.white,
                                //                 image: DecorationImage(
                                //                     image: imageProvider),
                                //               ),
                                //             ),
                                //           );
                                //         },
                                //       )
                                //     : CircleAvatar(
                                //         radius: 78,
                                //         child: Text(
                                //           detailsobj.name[0].toUpperCase(),
                                //           style: TextStyle(
                                //             fontSize: 70,
                                //           ),
                                //         ),
                                //       ),
                                detailsobj.photo != ""
                                    ? Image.network(
                                        Myurl.fullurl +
                                            Myurl.imageurl +
                                            detailsobj.photo,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        radius: 78,
                                        child: Text(
                                          detailsobj.name[0].toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 70,
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0.5,
                        right: 15.5,
                        child: Container(
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey, shape: BoxShape.circle),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Color(0xff003049),
                                  context: context,
                                  builder: (context) => BottonSheet(context));
                            },
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              color: Colors.lightBlueAccent,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              child: detailsobj.photo != ''
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
                            Get.defaultDialog(
                              radius: 50,
                              backgroundColor: Color(0xff003049),
                              title: 'Delete Image !',
                              titleStyle: TextStyle(color: Colors.white70),
                              content: const Text(
                                'Do You Wanna Delete Your Profile Image.?',
                                style: TextStyle(color: Colors.white60),
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                // Lottie.asset("assets/animations/delete1.json",
                                //     height: 250,
                                //     width: 250,
                                //     alignment: Alignment.topCenter),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                        Icons.disabled_by_default_outlined),
                                    label: Text("Cencel")),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      deleteImage(detailsobj.uid)
                                          .whenComplete(() {
                                        setState(() {});
                                      });
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text("Delete")),
                              ],
                            );
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
                  takephoto(ImageSource.gallery).whenComplete(() {
                    getChangeImg(pickedfile!, detailsobj.uid);
                  });
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
                  takephoto(ImageSource.camera).whenComplete(() {
                    getChangeImg(pickedfile!, detailsobj.uid);
                  });
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
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

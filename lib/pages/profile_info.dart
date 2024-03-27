import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/dashboard.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/loadingdialog.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetails extends StatefulWidget {
  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late SharedPreferences sp;

  final formkey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  final Ebtn = ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Color.fromARGB(255, 102, 189, 189),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))));

  File? pickedImage;

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future createprofile(
    File? uphoto,
    String uname,
    String email,
    String ubio,
    String phone,
  ) async {
    try {
      var request = http.MultipartRequest(
          "POST", Uri.http(Myurl.mainurl, Myurl.suburl + "update_profile.php"));
      if (uphoto != null)
        request.files.add(await http.MultipartFile.fromBytes(
            'u_image', uphoto!.readAsBytesSync(),
            filename: uphoto.path.split("/").last));

      request.fields['u_name'] = uname;
      request.fields['u_email'] = email;
      request.fields['u_bio'] = ubio;
      request.fields['u_phone'] = phone;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == true) {
        var datafetch = Details(
            jsondata['uid'],
            jsondata['name'],
            jsondata['email'],
            jsondata['bio'],
            jsondata['photo'].toString(),
            jsondata['phone']);
        sp = await SharedPreferences.getInstance();
        sp.setString("uid", jsondata['uid']);
        sp.setString("name", jsondata['name']);
        sp.setString("email", jsondata['email']);
        sp.setString("bio", jsondata['bio']);
        sp.setString("photo", jsondata['photo'].toString());
        sp.setString("phone", jsondata['phone']);
        // print(jsondata["uid"]);

        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
      } else {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      print(e);
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
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
          backgroundColor: Color.fromARGB(255, 102, 189, 166),
          elevation: 0,
          title: const Text(
            "Profile Create",
            style: TextStyle(
              fontSize: 25,
              letterSpacing: 0.6,
              fontWeight: FontWeight.bold,
              wordSpacing: 3,
              color: Color.fromARGB(255, 254, 254, 254),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromARGB(255, 33, 50, 61),
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color(0xFF3ac3cb),
          //       Color(0xFFf85187),
          //     ],
          //   ),
          // ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                          "Please Provide Your Name and Official Details...",
                          textAlign: TextAlign.center,
                          textStyle: const TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic),
                          speed: const Duration(milliseconds: 115)),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100))),
                      child: InkWell(
                        onTap: () {
                          imagePickerOption();
                        },
                        child: ClipOval(
                          child: pickedImage != null
                              ? Image.file(
                                  pickedImage!,
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/image/person.png",
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 13,
                      child: IconButton(
                        onPressed: () {
                          imagePickerOption();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          size: 35,
                          color: Color.fromARGB(255, 33, 142, 243),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(Phone.ph,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        speed: const Duration(milliseconds: 115)),
                  ],
                  repeatForever: false,
                  isRepeatingAnimation: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: t1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Your Name';
                          } else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                            return "Please enter correct name";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 139, 139),
                              width: 2,
                            ),
                          ),
                          labelText: "Enter your name here..",
                          // focusColor: Color.fromARGB(255, 194, 47, 28),
                          labelStyle:
                              TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: t2,
                        validator: (value) {
                          RegExp emailRegExp =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]');
                          if (value == null || value.isEmpty) {
                            return "Enter email id";
                          } else if (!emailRegExp.hasMatch(value)) {
                            return "Please Enter valid email";
                          }
                          return null;
                        },
                        // keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 139, 139),
                              width: 2,
                            ),
                          ),
                          labelText: "Enter your email id here..",
                          // focusColor: Color.fromARGB(255, 194, 47, 28),
                          labelStyle:
                              TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Bio";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: t3,
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 151, 139, 139),
                              width: 2,
                            ),
                          ),
                          labelText: "Enter your Bio..",
                          // focusColor: Color.fromARGB(255, 194, 47, 28),
                          labelStyle:
                              TextStyle(fontSize: 17, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton.icon(
                  style: Ebtn,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => LoadingDialog());

                      createprofile(
                          pickedImage, t1.text, t2.text, t3.text, Phone.ph);
                    }
                  },
                  icon: Center(
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.arrow_forward_sharp),
                    ),
                  ),
                  label: const Text(
                    'Save and Create',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      letterSpacing: 0.5,
                    ),
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

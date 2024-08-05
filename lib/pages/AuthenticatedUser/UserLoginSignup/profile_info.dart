// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/Dashboard/dashboard.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_application_2/widgets/loadingdialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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

  Future<void> createProfile(
    File? uphoto,
    String uname,
    String email,
    String ubio,
    String phone,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: "User not authenticated",
        );
        return;
      }
      String? photoUrl;
      if (uphoto != null) {
        // Upload photo to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('userImages/${user.uid + uphoto.path.split("/").last}');
        final uploadTask = await storageRef.putFile(uphoto);
        photoUrl = await uploadTask.ref.getDownloadURL();
      }

      // Save user data in Firestore
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.set({
        'uid': user.uid,
        'name': uname,
        'email': email,
        'bio': ubio,
        'phone': phone,
        'photo': photoUrl ?? "",
        // Adding status field
      });

      // Store user data in SharedPreferences
      final SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('uid', user.uid);
      sp.setString('name', uname);
      sp.setString('email', email);
      sp.setString('bio', ubio);
      sp.setString(
        'photo',
        photoUrl ?? "",
      );
      sp.setString('phone', phone); // Adding status to SharedPreferences

      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: 'Profile created successfully',
      );

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
      );
    } catch (e) {
      print(e);
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
          backgroundColor: appColor,
          elevation: 0,
          title: const Text(
            "Create profile",
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                alignment: Alignment.center,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      "Please provide your name and official details..",
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        letterSpacing: 0.5,
                        fontSize: 12.5,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      speed: const Duration(milliseconds: 115),
                    ),
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
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                        border: Border.all(color: appColor, width: 3),
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
                                // width: 170,
                                // height: 170,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person_sharp,
                                color: appColor,
                                size: 100,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    // top: 0,
                    left: 130,
                    bottom: 5,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        imagePickerOption();
                      },
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: appColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(Phone.ph,
                      // textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      speed: const Duration(milliseconds: 115)),
                ],
                repeatForever: false,
                isRepeatingAnimation: false,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(25),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.black),
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: appColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 139, 139),
                            width: 1,
                          ),
                        ),
                        prefixIcon: Icon(Icons.person),
                        hintText: "Enter your name here..",
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        label: AutoSizeText('Name'),
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: appColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 139, 139),
                            width: 1,
                          ),
                        ),
                        prefixIcon: Icon(Icons.email_outlined),
                        label: AutoSizeText('Email'),
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),

                        hintText: "Enter your email id here..",
                        // focusColor: Color.fromARGB(255, 194, 47, 28),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Bio";
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: t3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: appColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 151, 139, 139),
                            width: 1,
                          ),
                        ),
                        prefixIcon: Icon(Icons.info_outline_rounded),
                        label: AutoSizeText('About'),
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),

                        hintText: "Enter your Bio..",
                        // focusColor: Color.fromARGB(255, 194, 47, 28),
                        labelStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // ignore: avoid_unnecessary_containers
            Container(
              height: 50,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => LoadingDialog());

                    createProfile(
                        pickedImage, t1.text, t2.text, t3.text, Phone.ph);
                  }
                },
                icon: Icon(
                  Icons.create,
                  color: Colors.white,
                  size: 27,
                ),
                label: const Text(
                  'Create',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

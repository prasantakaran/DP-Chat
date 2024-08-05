// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable, must_be_immutable

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndividualUserProfile extends StatefulWidget {
  Details user;
  IndividualUserProfile(this.user);
  @override
  State<IndividualUserProfile> createState() =>
      _IndividualUserProfileState(user);
}

class _IndividualUserProfileState extends State<IndividualUserProfile> {
  Details user;
  _IndividualUserProfileState(this.user);

  late SharedPreferences sp;
  File? pickedImage;
  final formkey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var aboutController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  Rx<Details> currentUser = Details().obs;
  RxBool isLoading = false.obs;

  final Ebtn = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: Color.fromARGB(255, 102, 189, 189),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    aboutController = TextEditingController(text: user.bio);
  }

  Future<void> updateUserInfo(
    String? name,
    String? about,
    String? email,
    File? image,
  ) async {
    isLoading.value = true;
    if (auth.currentUser == null) {
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: "User not authenticated",
      );
      return;
    }

    var userDoc = await db.collection('users').doc(auth.currentUser!.uid).get();

    if (!userDoc.exists) {
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: "User data not found",
      );
      return;
    }

    var currentData = userDoc.data()!;
    var updatedData = Details.fromJson(currentData);
    List<String> updatedFields = [];
    SharedPreferences sp = await SharedPreferences.getInstance();

    // Check and update fields only if new values are provided
    if (name != null && name.isNotEmpty && currentData['name'] != name) {
      updatedData.name = name;
      setState(() {
        sp.setString('name', updatedData.name!);
        user.name = updatedData.name;
      }); // Update user instance
      updatedFields.add('Name');
    }
    if (about != null && about.isNotEmpty && currentData['bio'] != about) {
      updatedData.bio = about;
      setState(() {
        sp.setString('bio', updatedData.bio!);
        user.bio = updatedData.bio;
      }); // Update user instance
      updatedFields.add('About');
    }
    if (email != null && email.isNotEmpty && currentData['email'] != email) {
      updatedData.email = email;
      setState(() {
        sp.setString('email', updatedData.email!);
        user.email = updatedData.email;
      }); // Update user instance
      updatedFields.add('Email');
    }
    if (image != null) {
      final path = "userImages/${image.path.split("/").last}";
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();
      if (currentData['photo'] != imageUrl) {
        updatedData.photo = imageUrl;
        setState(() {
          sp.setString('photo', updatedData.photo!);
          user.photo = updatedData.photo;
        }); // Update user instance
        updatedFields.add('Image');
      }
      image = null;
    }

    if (updatedFields.isNotEmpty) {
      await db
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update(updatedData.toJson());

      for (var field in updatedFields) {
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: '$field updated successfully',
        );
        isLoading.value = false;
      }
    } else {
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: 'No data to update',
      );
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: appColor,
          elevation: 0,
          title: const Text(
            "Your profile",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  alignment: Alignment.center,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        "Hello ${user.name!.toUpperCase()}, it's your profile.",
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
                height: 25,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 165,
                      width: 165,
                      decoration: BoxDecoration(
                        border: Border.all(color: appColor, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                      child: ClipOval(
                        child: pickedImage != null
                            ? Image.file(
                                pickedImage!,
                                fit: BoxFit.cover,
                              )
                            : user.photo!.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: user.photo!,
                                    placeholder: (context, url) => Center(
                                        child:
                                            const CircularProgressIndicator()),
                                  )
                                : Icon(
                                    Icons.person_sharp,
                                    color: appColor,
                                    size: 100,
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
              Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: nameController,
                        onSaved: (newValue) {
                          user.name = newValue;
                        },
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
                          label: AutoSizeText("Name"),
                          hintText: 'eg. Enter your name',
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 12),
                          labelStyle: TextStyle(
                            fontSize: 14,
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
                        controller: emailController,
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
                          label: AutoSizeText("Email"),
                          hintText: 'Enter you email address',
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 12),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: phoneController,
                        validator: (value) {
                          if (value == null ||
                              !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[(]{0,1}[-\s\./0-9]+$')
                                  .hasMatch(value)) {
                            return 'Please enter your phonenumber.';
                          } else if (value.length != 10) {
                            return "Number must be exactly 10 digits.";
                          }
                          return null;
                        },
                        enabled: false,
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
                          prefixIcon: Icon(Icons.phone),
                          label: AutoSizeText("Phone number"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
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
                        controller: aboutController,
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

                          label: AutoSizeText("About"),
                          hintText: 'eg. Feeling good',
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 12),
                          // focusColor: Color.fromARGB(255, 194, 47, 28),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Container(
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
                        updateUserInfo(
                          nameController.text,
                          aboutController.text,
                          emailController.text,
                          pickedImage,
                        );
                        pickedImage = null;
                      }
                    },
                    icon: isLoading.value
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.save_as_outlined,
                            color: Colors.white,
                            size: 27,
                          ),
                    label: isLoading.value
                        ? Text(
                            ' Saving...',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )
                        : Text(
                            'Save',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
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

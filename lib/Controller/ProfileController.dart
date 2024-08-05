import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_2/pages/form.dart';
import 'package:get/get.dart';

import '../ModelClass/User_Details_Model.dart';

class ProfileController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  Rx<Details> currentUser = Details().obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  void getCurrentUser() async {
    await db.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      currentUser.value = Details.fromJson(value.data()!);
    });
  }

  Future<String> sendImage(String imagePath) async {
    final file = File(imagePath);
    if (imagePath.isNotEmpty) {
      try {
        final ref =
            storage.ref().child("chat_images/${file.uri.pathSegments.last}");
        final uploadTask = await ref.putFile(file);
        final downloadImageUrl = await uploadTask.ref.getDownloadURL();
        print(downloadImageUrl);
        return downloadImageUrl;
      } catch (ex) {
        print(ex);
        return "";
      }
    }
    return "";
  }

  Future<String> uploadGroupImage(String imagePath) async {
    final file = File(imagePath);
    if (imagePath.isNotEmpty) {
      try {
        final ref =
            storage.ref().child("group_images/${file.uri.pathSegments.last}");
        final uploadTask = await ref.putFile(file);
        final downloadImageUrl = await uploadTask.ref.getDownloadURL();
        print(downloadImageUrl);
        return downloadImageUrl;
      } catch (ex) {
        print(ex);
        return "";
      }
    }
    return "";
  }

  Future<void> logoutUser() async {
    await auth.signOut();
    Get.offAll(() => MyForm());
  }
}

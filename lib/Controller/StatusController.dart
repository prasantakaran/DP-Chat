import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:get/get.dart';

class StatusController extends GetxController with WidgetsBindingObserver {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    await db.collection('users').doc(auth.currentUser!.uid).update({
      "Status": "Online",
      'push_token': _profileController.currentUser.value.pushToken,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        "Status": "Offline",
        'LastOnlineStatus': DateTime.now().toIso8601String(),
      });
    } else if (state == AppLifecycleState.resumed) {
      await db.collection('users').doc(auth.currentUser!.uid).update({
        "Status": "Online",
      });
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final ProfileController _profileController = Get.put(ProfileController());
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // @override
  // Future<void> onInit() async {
  //   super.onInit();
  //   await getNotificationToken();
  //   update();
  // }

  // Future<void> getNotificationToken() async {
  //   await firebaseMessaging.requestPermission();

  //   await firebaseMessaging.getToken().then((token) {
  //     if (token != null) _profileController.currentUser.value.pushToken = token;
  //     print('push token $token');
  //   });
  // }

  Future<void> getNotificationToken() async {
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.getToken().then((token) async {
      if (token != null) {
        _profileController.currentUser.value.pushToken = token;
        print('push token $token');

        // Update push_token in Firestore
        await db.collection('users').doc(auth.currentUser!.uid).update({
          'push_token': token,
        });
      }
    });
  }
}

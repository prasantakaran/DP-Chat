// ignore_for_file: prefer_const_constructors, unused_element

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/pages/WpSplashScreen.dart';
import 'package:flutter_application_2/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'Controller/GroupController.dart';

final SnackBarController snackBarController = Get.put(SnackBarController());
final GroupController groupController = Get.put(GroupController());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(GetMaterialApp(
    home: SplashScreen(),
    title: 'DP Chat',
    debugShowCheckedModeBanner: false,
  ));
}

final chatColor = Color.fromARGB(255, 188, 214, 232);
final appColor = Color.fromARGB(255, 23, 98, 148);


// class MyApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     // socketService.connect(); // Connect to Socket.IO when the app starts
//     return GetMaterialApp(
//       title: 'DP Chat',
//       // home: SplashScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

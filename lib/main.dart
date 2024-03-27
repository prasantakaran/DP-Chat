import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/WpSplashScreen.dart';

import 'package:get/get.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      title: 'DP Chat',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

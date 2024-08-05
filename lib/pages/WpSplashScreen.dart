// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, implementation_imports, unnecessary_import, file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/Dashboard/dashboard.dart';
import 'package:flutter_application_2/pages/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String phone = '';
  // late Details details;
  late SharedPreferences sp;
  Future getData() async {
    sp = await SharedPreferences.getInstance();
    phone = sp.getString('phone') ?? "";
  }

  @override
  void initState() {
    getData();
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: Colors.black),
    );
    Timer(const Duration(seconds: 2), () {
      if (phone == "")
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyForm()));
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashBoard()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: appColor.withOpacity(0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              'assets/image/dpsplach.png',
              width: 150,
              height: 150,
            ),
          ),
          Container(
            padding: EdgeInsets.all(3),
            width: double.infinity,
            decoration: BoxDecoration(
              color: appColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            ),
            child: Text(
              "Develop by Prasanta",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

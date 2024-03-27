import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/dashboard.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // String name = '', email = '', bio = '', phone = '', photo = '';
  String phone = '';
  // late Details details;
  late SharedPreferences sp;
  Future getData() async {
    sp = await SharedPreferences.getInstance();
    // name = sp.getString('name') ?? "";
    // email = sp.getString('email') ?? "";
    // bio = sp.getString('bio') ?? "";
    // photo = sp.getString('photo') ?? "";
    phone = sp.getString('phone') ?? "";
  }

  @override
  void initState() {
    getData();
    super.initState();
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
      color: Colors.white12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Image.asset(
            'assets/image/dpsplach.png',
            width: 100,
            height: 100,
          )),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              "Develop By Prasanta",
              style: TextStyle(color: Colors.white60, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}

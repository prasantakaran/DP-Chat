import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/WpSplashScreen.dart';
import 'package:flutter_application_2/pages/first.dart';

class Startinit extends StatefulWidget {
  const Startinit({super.key});

  @override
  State<Startinit> createState() => _StartinitState();
}

class _StartinitState extends State<Startinit> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Myapp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Image.asset(
            'assets/image/wpimg.jpg',
            width: 100,
            height: 100,
          )),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text("Develop By DP"),
          )
        ],
      ),
    );
  }
}

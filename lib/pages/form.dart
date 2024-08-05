// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/AuthenticatedUser/UserLoginSignup/varified_chat.dart';

class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var colors;
  var colorizeTextStyle;
  final ButtonStyle btn = ElevatedButton.styleFrom(
      // primary: Colors.green,
      elevation: 0,
      backgroundColor: appColor,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 50))));
  final ButtonStyle btn2 = ElevatedButton.styleFrom(
      // primary: const Color.fromARGB(255, 255, 7, 7),
      elevation: 0,
      backgroundColor: appColor,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 50))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF111B21),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                // ignore: avoid_unnecessary_containers
                child: Container(
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText("Welcome To DPChat",
                            textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'PangolinRegular'),
                            speed: const Duration(seconds: 1),
                            colors: [
                              // Colors.purple,
                              // Colors.blue,
                              const Color.fromARGB(249, 226, 18, 80),
                              const Color.fromARGB(255, 115, 68, 137),
                              Colors.yellow,
                              Colors.blue,
                              Colors.red,
                              Colors.black
                            ])
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: SizedBox(
                  width: 290,
                  height: 290,
                  child: Image.asset("assets/image/chatimage.png"),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Read our ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(
                          color: appColor,
                        ),
                      ),
                      TextSpan(text: ' Tap "AGREE AND CONTINUE" to accept the'),
                      TextSpan(
                        text: ' Terms of Service',
                        style: TextStyle(color: appColor),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                  width: 220,
                  height: 50,
                ),
                child: ElevatedButton(
                  style: btn,
                  child: Text(
                    'AGREE AND CONTINUE',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerfiedAccount(),
                        ));
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(
                  width: 220,
                  height: 50,
                ),
                child: ElevatedButton(
                  style: btn2,
                  child: const Text(
                    'RESTORE BACKUP',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent),
                  ),
                  onPressed: () {
                    print("Button");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/first.dart';
import 'package:flutter_application_2/pages/login_form.dart';
import 'package:flutter_application_2/pages/varified_chat.dart';

import 'package:flutter_application_2/pages/User_Details_Model.dart';

class MyForm extends StatefulWidget {
  // const MyForm({super.key});
  // Details detailsobj;
  // MyForm(this.detailsobj);

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  // Details detailsobj;
  // _MyFormState(this.detailsobj);
  // ignore: prefer_typing_uninitialized_variables
  var colors;
  var colorizeTextStyle;
  final ButtonStyle btn = ElevatedButton.styleFrom(
      // primary: Colors.green,
      elevation: 0,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 50))));
  final ButtonStyle btn2 = ElevatedButton.styleFrom(
      // primary: const Color.fromARGB(255, 255, 7, 7),
      elevation: 0,
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 50))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
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
                                fontSize: 28,
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
              SizedBox(
                width: 290,
                height: 290,
                child: Image.asset("assets/image/chatimage.png"),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                        text: 'Read our ',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                              text: 'Privacy Policy.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 89, 132, 206))),
                          TextSpan(
                              text: '  Tap "Agree and continue" to accept the'),
                          TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 89, 132, 206)))
                        ])),
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
                  child: const Text(
                    'AGREE AND CONTINUE',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerfiedAccount()));
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
                    style: TextStyle(fontWeight: FontWeight.w800),
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

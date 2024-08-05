// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_application_2/pages/help_dpchat.dart';
import 'package:flutter_application_2/widgets/loadingdialog.dart';
import 'package:flutter_application_2/pages/AuthenticatedUser/UserLoginSignup/otp_screen.dart';

class VerfiedAccount extends StatefulWidget {
  const VerfiedAccount({super.key});

  @override
  State<VerfiedAccount> createState() => _VerfiedAccountState();
}

class _VerfiedAccountState extends State<VerfiedAccount> {
  TextEditingController t1 = TextEditingController();
  final getotp = GlobalKey<FormState>();

  bool isButtonVisible = false;

  @override
  void initState() {
    super.initState();
    t1.addListener(() {
      setState(() {
        isButtonVisible = t1.text.length == 10;
      });
    });
  }

  @override
  void dispose() {
    t1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Enter phone number',
            style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: appColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HelpUser()));
              },
              child: const Text(
                'Help',
                style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              // color: appColor.withOpacity(0.6),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Form(
                  key: getotp,
                  child: Column(
                    children: [
                      Opacity(
                        opacity: 0.7,
                        child: const Image(
                          width: 200,
                          height: 200,
                          image: AssetImage('assets/image/Hey.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: <AnimatedText>[
                            TyperAnimatedText(
                                'DP Chat need to register your phone before getting started !',
                                textAlign: TextAlign.center,
                                textStyle: TextStyle(
                                    fontSize: 12,
                                    color: appColor,
                                    fontWeight: FontWeight.bold),
                                speed: const Duration(milliseconds: 110))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.all(18),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: t1,
                          style: TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[(]{0,1}[-\s\./0-9]+$')
                                    .hasMatch(value)) {
                              return 'Please enter your phonenumber.';
                            } else if (value.length != 10) {
                              return "Number must be exactly 10 digits.";
                            }
                            return null;
                          },
                          showCursor: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide(color: Colors.black)),
                            prefixIcon: Icon(
                              Icons.phone,
                              // color: Colors.white,
                            ),
                            labelText: 'Phone number',
                            labelStyle: TextStyle(
                                color: appColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                            hintText: '+91 4567 9876 456',
                            hintStyle: TextStyle(
                              letterSpacing: 0.5,
                              color: Colors.black54,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w300,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            floatingLabelStyle: TextStyle(
                                color: appColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: isButtonVisible,
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          margin: EdgeInsets.all(18),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (getotp.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) => LoadingDialog(),
                                );
                                Phone(t1.text);
                                // Navigator.pop(context);
                                // Navigator.of(context).pushReplacement(
                                //   MaterialPageRoute(
                                //     builder: (context) => OtpScreen(),
                                //   ),
                                // );
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: '+91' + t1.text,
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException e) {},
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    snackBarController.snackBar(
                                        context, 'Code sent', Colors.green);
                                    VerifiactionOtp.verify = verificationId;
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => OtpScreen(),
                                      ),
                                    );
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {},
                                );
                              } else {
                                // ignore: avoid_print
                                print("Not valid");
                              }
                            },
                            icon: Icon(
                              Icons.arrow_forward_sharp,
                              color: Colors.greenAccent,
                            ),
                            label: Text(
                              'GET OTP',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

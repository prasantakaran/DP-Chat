// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/main.dart';

import 'package:flutter_application_2/pages/Dashboard/dashboard.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';

import 'package:flutter_application_2/pages/AuthenticatedUser/UserLoginSignup/profile_info.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late SharedPreferences sp;
  bool verified = false;
  String code = ''; //smscode
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? userImage;

  Future<void> getDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: Phone.ph)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        Map<String, dynamic> jsonData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          userImage = jsonData['photo'].toString();
        });

        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString("name", jsonData['name']);
        sp.setString("email", jsonData['email']);
        sp.setString("bio", jsonData['bio']);
        sp.setString("photo", userImage!);
        sp.setString("phone", jsonData['phone']);
        sp.setString("uid", userDoc.id);
        // Adding status to SharedPreferences

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(), // Navigate to Home page
          ),
        );
        Fluttertoast.showToast(msg: "Login successful!", fontSize: 15);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileDetails(), // Navigate to registration page
          ),
        );
      }
    } catch (e) {
      setState(() {
        verified = false; // If you have this state variable
      });
      Fluttertoast.showToast(gravity: ToastGravity.CENTER, msg: e.toString());
      Fluttertoast.showToast(gravity: ToastGravity.CENTER, msg: 'error');
    }
  }

  bool isotpenable = false;
  int timecount = 0;
  int otp = 0;
  Timer? timer;
  bool istimetextvisible = true;
  @override
  void initState() {
    super.initState();
    // genrateOtp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (context) {
      //       return PinDialog(otp);
      //     });
      // starttimer();
    });
  }

  // @override
  // void dispose() {
  //   timer!.cancel();
  //   super.dispose();
  // }

  // void starttimer() {
  //   timecount = 30;
  //   istimetextvisible = true;
  //   isotpenable = false;
  //   timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       timecount -= 1;
  //       if (timecount == 0) {
  //         timer.cancel();
  //         istimetextvisible = false;
  //         isotpenable = true;
  //       }
  //     });
  //   });
  // }

  // void genrateOtp() {
  //   Random rnd = Random();
  //   otp = 1000 + rnd.nextInt(9999 - 1000);
  // }

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController t6 = TextEditingController();

  // bool checkOtp(int value) {
  //   // print(value);
  //   if (otp == value) {
  //     return true;
  //   }
  //   return false;
  // }

  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Text(
            'Verify your OTP',
            style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          // ignore: avoid_unnecessary_containers
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/otpimg.png",
                      width: 200,
                      height: 200,
                    ),
                  ],
                ),

                Form(
                  key: formkey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          controller: t1,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          controller: t2,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          controller: t3,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          controller: t4,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          controller: t5,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          controller: t6,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: avoid_unnecessary_containers
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Didn't Recieve OTP?",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: isotpenable
                            ? () {
                                getDetails();
                                // genrateOtp();

                                // showDialog(
                                //     barrierDismissible: false,
                                //     context: context,
                                //     builder: (context) {
                                //       return PinDialog(otp);
                                //     });
                                // starttimer();
                              }
                            : null,
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: istimetextvisible,
                        child: Text(
                          "00:$timecount sec",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: appColor),
              onPressed: verified
                  ? null
                  : () async {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          verified = true;
                        });
                        code = t1.text +
                            t2.text +
                            t3.text +
                            t4.text +
                            t5.text +
                            t6.text;

                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: VerifiactionOtp.verify,
                                  smsCode: code);
                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);
                          getDetails();
                        } catch (e) {
                          setState(() {
                            verified = false;
                          });
                          Fluttertoast.showToast(msg: "Invalid OTP");
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Please enter OTP");
                      }

                      // int entotp = 0;
                      // if (!t1.text.isEmpty &&
                      //     !t2.text.isEmpty &&
                      //     !t3.text.isEmpty &&
                      //     !t4.text.isEmpty) {
                      //   entotp = int.parse(t1.text + t2.text + t3.text + t4.text);
                      // print(entotp);
                      // if (checkOtp(entotp)) {
                      //   getDetails().whenComplete(() => null);
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) => LoadingDialog());
                      // }
                      //  else {
                      //   Fluttertoast.showToast(
                      //       gravity: ToastGravity.CENTER, msg: "Invalid OTP");
                      // }
                      // } else {
                      //   Fluttertoast.showToast(
                      //       gravity: ToastGravity.CENTER, msg: "Enter Valid OTP");
                    },
              // }
              icon: verified
                  ? Icon(null)
                  : Icon(
                      Icons.verified_user_outlined,
                      color: Colors.greenAccent,
                    ),
              label: verified
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Verifying...",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Verify & Proceed",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.greenAccent,
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

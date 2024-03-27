import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_application_2/pages/dashboard.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';

import 'package:flutter_application_2/pages/profile_info.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
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

  Future getDetails() async {
    Map data = {"phone": Phone.ph};
    try {
      var response = await http.post(
          Uri.http(Myurl.mainurl, Myurl.suburl + "check_email.php"),
          body: data);
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata['status'] == true) {
        Details datafatch = Details(
            jsondata['name'],
            jsondata['email'],
            jsondata['bio'],
            jsondata['photo'].toString(),
            jsondata['phone'],
            jsondata['uid']);
        sp = await SharedPreferences.getInstance();
        sp.setString("name", jsondata['name']);
        sp.setString("email", jsondata['email']);
        sp.setString("bio", jsondata['bio']);
        sp.setString("photo", jsondata['photo'].toString());
        sp.setString("phone", jsondata['phone']);
        sp.setString("uid", jsondata['uid']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(),
          ),
        );
        Fluttertoast.showToast(msg: "Login Successful!", fontSize: 18);
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileDetails()));
      }
    } catch (e) {
      setState(() {
        verified = false;
      });
      Fluttertoast.showToast(gravity: ToastGravity.CENTER, msg: e.toString());
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
          backgroundColor: Color.fromARGB(255, 102, 189, 166),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText("Verify Your Number",
                    textStyle: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                    speed: const Duration(seconds: 1),
                    colors: [
                      // Colors.purple,
                      // Colors.blue,
                      Colors.white,
                      const Color.fromARGB(255, 115, 68, 137),
                      Colors.yellow,
                      Colors.blue,
                      Colors.red,
                      Colors.white
                    ])
              ],
              repeatForever: true,
              isRepeatingAnimation: true,
            ),
          ]),
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
                            Navigator.pop(context);
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
                icon:
                    verified ? Icon(null) : Icon(Icons.verified_user_outlined),
                label: verified
                    ? Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Verifying...",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20),
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
                          "Verify",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}

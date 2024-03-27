import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/help_dpchat.dart';
import 'package:flutter_application_2/pages/loadingdialog.dart';
import 'package:flutter_application_2/pages/otp_screen.dart';
import 'package:get/route_manager.dart';
import 'package:validators/validators.dart';

class VerfiedAccount extends StatefulWidget {
  const VerfiedAccount({super.key});

  @override
  State<VerfiedAccount> createState() => _VerfiedAccountState();
}

class _VerfiedAccountState extends State<VerfiedAccount> {
  TextEditingController t1 = TextEditingController();
  final getotp = GlobalKey<FormState>();
  final ButtonStyle btn = ElevatedButton.styleFrom(
    minimumSize: Size(200, 40),
    elevation: 0,
    backgroundColor: Colors.white24,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   t1 = TextEditingController();
  //   t1.addListener(() {
  //     final isenablebtn = t1.text.isEmpty;
  //     // setState(() => this.isenablebtn = false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText("Enter Phone Number",
                    textStyle: TextStyle(
                        fontSize: 22,
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
          backgroundColor: Color.fromARGB(255, 72, 137, 181),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 0, right: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HelpUser()));
                },
                child: const Text(
                  'Help',
                  style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Color.fromARGB(255, 33, 50, 61),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       Color(0xFF3ac3cb),
              //       Color(0xFFf85187),
              //       // Color(0xffebbba7),
              //       // Color(0xffcfc7f8)
              //     ],
              //   ),
              // ),
              child: Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Form(
                  key: getotp,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: const Image(
                          width: 200,
                          height: 200,
                          image: AssetImage('assets/image/Hey.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: <AnimatedText>[
                              TyperAnimatedText(
                                  'DP Chat need to register your phone before getting started !',
                                  textAlign: TextAlign.center,
                                  textStyle: const TextStyle(
                                      fontSize: 13,
                                      // color: Color.fromARGB(255, 114, 108, 108),
                                      color: Colors.white54,
                                      // letterSpacing: 0.3,
                                      fontWeight: FontWeight.bold),
                                  speed: const Duration(milliseconds: 110))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: t1,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[(]{0,1}[-\s\./0-9]+$')
                                    .hasMatch(value)) {
                              return 'Please Enter Your PhoneNumber';
                            } else if (value.length != 10 ||
                                t1.text.length < 10) {
                              return "Number must be at least 10 digits";
                            }

                            return null;
                          },
                          showCursor: true,
                          // enabled: true,
                          decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green)),
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              labelText: 'Phonenumber',
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: '+91 4567 9876 456',
                              hintStyle: TextStyle(
                                letterSpacing: 0.5,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      // color: isPhoneCorrect == false
                                      //     ? Colors.red
                                      //     : Colors.yellow,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(15)),
                              floatingLabelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 60,
                        width: 150,
                        child: ElevatedButton.icon(
                            style: btn,
                            onPressed: () async {
                              if (getotp.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) => LoadingDialog(),
                                );
                                Phone(t1.text);
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: '+91' + t1.text,
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {},
                                  verificationFailed:
                                      (FirebaseAuthException e) {},
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    VerifiactionOtp.verify = verificationId;
                                    Navigator.pop(context);

                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => OtpScreen()));
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
                            ),
                            label: Text(
                              'GET OTP',
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
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

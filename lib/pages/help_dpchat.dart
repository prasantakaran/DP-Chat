import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/main.dart';

class HelpUser extends StatefulWidget {
  const HelpUser({super.key});

  @override
  State<HelpUser> createState() => _HelpUserState();
}

class _HelpUserState extends State<HelpUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Problem Dectected',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: appColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "We didn't detect a valid Phone Number.",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Please go back to the previous screen and enter your valid Phone Number in full international format:',
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 25),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1.Choose your country from country list. This will automatically fill the country code.",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "2.Enter your valid Phone Number.",
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.5,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "For creating an account in DP Chat, you need to varifying your accout through your valid Phone Number.",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.5,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

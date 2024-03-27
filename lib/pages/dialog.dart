import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PinDialog extends StatefulWidget {
  int otp;
  PinDialog(this.otp);

  @override
  State<PinDialog> createState() => _PinDialogState(otp);
}

class _PinDialogState extends State<PinDialog> {
  int otp;
  _PinDialogState(this.otp);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        child: AlertDialog(
          content: Text("Your OTP is $otp"),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))
          ],
          title: Text(
            "OTP",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
          ),
        ));
  }
}

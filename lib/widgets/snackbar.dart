import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarController extends GetxController {
  void snackBar(BuildContext context, String msg, colors) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AutoSizeText(
          msg,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        backgroundColor: colors,
        // behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(8),
            ),
      ),
    );
  }
}

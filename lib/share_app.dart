import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:share_plus/share_plus.dart';

class ShareMyApp extends StatefulWidget {
  const ShareMyApp({super.key});

  @override
  State<ShareMyApp> createState() => _ShareMyAppState();
}

class _ShareMyAppState extends State<ShareMyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton.icon(
              onPressed: () {
                Share.share("com.example.flutter_application_2");
              },
              icon: Icon(Icons.share),
              label: Text("Share DP Chat"))),
    );
  }
}

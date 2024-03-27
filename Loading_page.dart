import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinKitSpinningLines(color: Colors.cyan),
              SizedBox(
                height: 10,
              ),
              Text(
                "Loading....",
                style: TextStyle(fontSize: 8, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

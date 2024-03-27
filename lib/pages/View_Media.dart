import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/pages/chat_information.dart';
import 'package:flutter_application_2/util/myurl.dart';

class View_Media extends StatefulWidget {
  // const View_Media({super.key});
  Details user;
  View_Media(this.user);

  @override
  State<View_Media> createState() => _View_MediaState(user);
}

class _View_MediaState extends State<View_Media> {
  Details user;
  _View_MediaState(this.user);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_rounded)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

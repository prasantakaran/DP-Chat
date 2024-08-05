import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_2/pages/ChatsPages/Individual_Chat_Page.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_application_2/pages/User_Profile.dart';
import 'package:photo_view/photo_view.dart';

class UserProflieShow extends StatelessWidget {
  Details user;
  UserProflieShow(this.user);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(.9),
      // backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .6,
        height: MediaQuery.of(context).size.height * .36,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          title: Text(
                            user.name!,
                            style: TextStyle(letterSpacing: 0.4),
                          ),
                          elevation: 0.5,
                          backgroundColor: Colors.transparent,
                        ),
                        body: Material(
                          color: Colors.transparent,
                          child: Container(
                            child: user.photo != ""
                                ? PhotoView(
                                    maxScale: 4.0,
                                    minScale: 0.1,
                                    imageProvider: NetworkImage(user.photo!))
                                : const Center(
                                    child: Text(
                                      "No image",
                                      // textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 0.5,
                                          color: Colors.white54,
                                          fontSize: 20),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: user.photo != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .50),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundImage: NetworkImage(user.photo!),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(100)),
                        child: CircleAvatar(
                          // backgroundColor: Colors.black,
                          radius: 100, backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.person,
                            size: 150,
                            color: Colors.blue,
                          ),
                        ),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfile(user)));
                  },
                  child: Text(
                    "View ${user.name}'s Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.name!,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IndividualChatPage(user)));
                    },
                    icon: Icon(Icons.message_outlined))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

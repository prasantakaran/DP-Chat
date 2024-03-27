import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CurrentChatList extends StatefulWidget {
  const CurrentChatList({super.key});

  @override
  State<CurrentChatList> createState() => _CurrentChatListState();
}

class _CurrentChatListState extends State<CurrentChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "DP Chat",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'PangolinRegular',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: InkWell(
                        onTap: () {
                          // print("object");
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.pink,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Add New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 20, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search Someone...",
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600, letterSpacing: 0.5),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(color: Colors.grey.shade100)),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (Value) {
                      print(Value);
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Center(
                            child: TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.group),
                                label: Text('NewGroup')),
                          ),
                        ),
                        PopupMenuItem(
                          child: Center(
                            child: TextButton.icon(
                                onPressed: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             SettingPage(detailsobj)));
                                },
                                icon: Icon(Icons.settings),
                                label: Text('Setting')),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

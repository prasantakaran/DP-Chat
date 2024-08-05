// ignore_for_file: camel_case_types

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/main.dart';

import '../GroupPages/Widget/GroupHome.dart';
import '../ChatsPages/Widget/ChatsHome.dart';

class Conversactions_Tabs extends StatefulWidget {
  Conversactions_Tabs({super.key});

  @override
  State<Conversactions_Tabs> createState() => _Conversactions_TabsState();
}

class _Conversactions_TabsState extends State<Conversactions_Tabs>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          TabBar(
            dragStartBehavior: DragStartBehavior.start,
            controller: tabController,
            indicator: BoxDecoration(
              color: appColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: appColor,
            unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            padding: EdgeInsets.all(12),
            labelColor: Colors.white,
            labelStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.5),
            indicatorColor: appColor,
            dividerColor: Colors.transparent,
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.chat_bubble_2_fill),
                    SizedBox(
                      width: 3,
                    ),
                    AutoSizeText('Chats'),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group),
                    SizedBox(
                      width: 3,
                    ),
                    AutoSizeText('Groups'),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                ChatsHome(),
                GroupsRoomDisplay(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';

class ListViewPage extends StatefulWidget {
  // const ListViewPage({super.key});
  // Details detailsobj;
  // ListViewPage(this.detailsobj);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  // Details detailsobj;
  // _ListViewPageState(this.detailsobj);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Text(detailsobj.name),
            // Text(detailsobj.bio),
            // Text(detailsobj.email)
          ],
        ),
      ),
    );
  }
}

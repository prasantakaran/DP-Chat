// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Controller/ChatController.dart';
import 'package:flutter_application_2/Controller/Contact_Controller.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/pages/ProfileShow.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../Controller/GroupController.dart';
import 'SelectedMember.dart';

class AddNewMember extends StatefulWidget {
  AddNewMember({super.key, required this.group_id});
  String group_id = '';

  @override
  State<AddNewMember> createState() => _AddNewMemberState();
}

class _AddNewMemberState extends State<AddNewMember> {
  // List<Details> userlist = [];
  List<Details> filtedContacts = [];
  final _searchController = TextEditingController();
  bool isSearch = false;
  final ContactController _contactController = Get.put(ContactController());
  final MessageController msgControler = Get.put(MessageController());
  final GroupController _groupController = Get.put(GroupController());

  void _filterItems(String query) {
    query = query.toLowerCase();
    setState(() {
      filtedContacts.clear();
    });
    if (query.isEmpty) {
      setState(() {
        _contactController.userlist;
      });
    } else {
      List<Details> filteredList = [];
      filteredList.addAll(
        _contactController.userlist.where(
          (item) =>
              item.name!.toLowerCase().contains(query.toLowerCase()) ||
              item.phone!.contains(query),
        ),
      );
      setState(() {
        filtedContacts = filteredList;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _groupController.selectMember.value = [];
    _groupController.countSelectedMember.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: appColor,
        title: Text(
          'Add member',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchController.text = value;
                  isSearch = !isSearch;
                });
                _filterItems(value.trim());
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(10),
                // ),
                hintText: 'Search contact',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: appColor.withOpacity(0.8),
                ),
                suffixIcon: _searchController.text.isEmpty
                    ? SizedBox()
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(Icons.close),
                      ),
                prefixIcon: Icon(Icons.search),

                // suffixIcon: Icon(Icons.close),
              ),
            ),
            Obx(
              () => _groupController.selectMember.isNotEmpty
                  ? Row(
                      children: [
                        AutoSizeText(
                          'Selected members (${_groupController.countSelectedMember.value})',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  : SizedBox(),
            ),
            const SelectedMember(),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => _groupController.selectMember.isNotEmpty
                  ? SizedBox(
                      width: double.infinity,
                      child: Divider(
                        height: 1,
                        color: Color(0xff444444),
                      ),
                    )
                  : SizedBox(),
            ),
            Expanded(
              child: Obx(
                () => Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: _contactController.userlist.isNotEmpty
                      ? _searchController.text.isNotEmpty &&
                              filtedContacts.isEmpty
                          ? Center(
                              child: Text(
                                'No contact found for "${_searchController.text}"',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _searchController.text.isEmpty
                                  ? _contactController.userlist.length
                                  : filtedContacts.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                if (_contactController.userlist.isEmpty) {
                                  return Center(
                                    child: Text('No User Found'),
                                  );
                                }
                                final contacts = _searchController.text.isEmpty
                                    ? _contactController.userlist[index]
                                    : filtedContacts[index];
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              UserProflieShow(contacts),
                                        );
                                      },
                                      child: contacts.photo!.isNotEmpty
                                          ? CircleAvatar(
                                              radius: 28,
                                              child: CachedNetworkImage(
                                                imageUrl: contacts.photo!,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 25,
                                              child: Icon(Icons.person),
                                            ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        onTap: () {
                                          if (!_groupController.selectMember
                                              .contains(contacts)) {
                                            _groupController
                                                .selectGroupMember(contacts);
                                            _groupController
                                                .countSelectedMember.value++;
                                          }
                                        },
                                        title: Row(
                                          children: [
                                            Text(
                                              contacts.name!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                            Spacer(),
                                            contacts.uid ==
                                                    msgControler
                                                        .auth.currentUser!.uid
                                                ? AutoSizeText(
                                                    'You',
                                                    style: TextStyle(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: appColor),
                                                  )
                                                : AutoSizeText(''),
                                          ],
                                        ),
                                        subtitle: AutoSizeText(
                                          contacts.phone!,
                                          style: TextStyle(
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitSpinningLines(
                              lineWidth: 3,
                              color: appColor,
                              size: 50,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Please wait...',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: appColor,
                ),
                onPressed: () {
                  _groupController.addNewGroupMember(
                      widget.group_id, _groupController.selectMember);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 27,
                ),
                label: Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

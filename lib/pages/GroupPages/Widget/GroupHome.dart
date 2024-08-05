import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Controller/GroupController.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:flutter_application_2/pages/GroupPages/Widget/NewGroup.dart';
import 'package:flutter_application_2/pages/GroupPages/individual_group_chat.dart';
import 'package:flutter_application_2/main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../ModelClass/GroupModel.dart';

class GroupsRoomDisplay extends StatefulWidget {
  const GroupsRoomDisplay({super.key});

  @override
  State<GroupsRoomDisplay> createState() => _GroupsRoomDisplayState();
}

class _GroupsRoomDisplayState extends State<GroupsRoomDisplay> {
  final GroupController _groupController = Get.put(GroupController());
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<GroupModel>>(
        stream: _groupController.getGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No groups found.'),
            );
          } else {
            List<GroupModel> groups = snapshot.data!;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                String _formatedTime = '';
                GroupModel group = groups[index];
                if (group.lastMessageTime != null &&
                    group.lastMessageTime!.isNotEmpty) {
                  DateTime _timeStamp = DateTime.parse(group.lastMessageTime!);
                  _formatedTime = DateFormat('hh:mm a').format(_timeStamp);
                }
                return Card(
                  color: Colors.white,
                  elevation: 0,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    onTap: () {
                      Get.to(() => individualGroupChat(group));
                    },
                    leading: Container(
                      decoration: BoxDecoration(
                        color: appColor,
                        border: Border.all(color: appColor),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      height: 55,
                      width: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            group.profileUrl != null && group.profileUrl! != ''
                                ? CachedNetworkImage(
                                    imageUrl: group.profileUrl!,
                                    fit: BoxFit.cover,
                                    width: 55,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : const Icon(Icons.person,
                                    size: 30, color: Colors.white),
                      ),
                    ),
                    title: Text(
                      group.name ?? 'Unnamed Group',
                      style: TextStyle(
                        fontSize: 17,
                        color: appColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "${group.lastMessageBy == _profileController.currentUser.value.name ? 'You' : group.lastMessageBy ?? ''} : ${group.lastMessage ?? ''}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13),
                    ),
                    trailing: Text(
                      _formatedTime,
                      style:
                          const TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'New Group',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          CupertinoIcons.group_solid,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewGroupCreate(),
            ),
          );
        },
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        highlightElevation: 100,
        backgroundColor: appColor,
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:flutter_application_2/ModelClass/GroupModel.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../ModelClass/Message_model.dart';

class GroupController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxList<Details> selectMember = <Details>[].obs;
  final storage = FirebaseStorage.instance;
  RxBool isLoading = false.obs;
  var uuid = Uuid();
  ProfileController _profileController = Get.put(ProfileController());
  RxList<GroupModel> groupList = <GroupModel>[].obs;
  RxString groupChatImage = ''.obs;
  RxInt countSelectedMember = 0.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await getGroups();
  }

  void selectGroupMember(Details userInfo) {
    if (selectMember.contains(userInfo)) {
      selectMember.remove(userInfo);
    } else {
      selectMember.add(userInfo);
    }
  }

  Future<void> createGroup(String groupName, File? groupImageFile) async {
    var groupId = uuid.v4(); // Fix: Use v4 for a proper UUID
    isLoading.value = true;
    String imageUrl = "";
    try {
      if (groupImageFile != null) {
        imageUrl =
            await _profileController.uploadGroupImage(groupImageFile.path);
      }

      selectMember.add(
        Details(
          uid: auth.currentUser!.uid,
          name: _profileController.currentUser.value.name,
          photo: _profileController.currentUser.value.photo,
          email: _profileController.currentUser.value.email,
          phone: _profileController.currentUser.value.phone,
          bio: _profileController.currentUser.value.bio,
          role: "admin",
        ),
      );

      await db.collection('groups').doc(groupId).set({
        "id": groupId,
        "name": groupName,
        "profileUrl": imageUrl,
        "members": selectMember.map((e) => e.toJson()).toList(),
        "createdAt": DateTime.now().toString(),
        "createdBy": auth.currentUser!.uid,
        "timeStamp": DateTime.now().toString(),
      });
      isLoading.value = false;
    } catch (e) {
      print('error is:' + e.toString());
    }
  }

  Future<void> addNewGroupMember(String groupId, List<Details> newUsers) async {
    isLoading.value = true;
    List<Map<String, dynamic>> newUsersJson =
        newUsers.map((user) => user.toJson()).toList();

    try {
      await db.collection('groups').doc(groupId).update({
        "members": FieldValue.arrayUnion(newUsersJson),
      });
      await getGroups();
    } catch (e) {
      print("Error adding new members: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> addNewGroupMember(String groupId, Details newUser) async {
  //   isLoading.value = true;
  //   await db.collection('groups').doc(groupId).update({
  //     "members": FieldValue.arrayUnion([newUser.toJson()]),
  //   });
  //   await getGroups();
  //   isLoading.value = false;
  // }

  Stream<List<GroupModel>> getGroups() {
    return db.collection('groups').snapshots().map((snapshot) {
      List<GroupModel> tempGroup =
          snapshot.docs.map((doc) => GroupModel.fromJson(doc.data())).toList();
      List<GroupModel> filteredGroups = tempGroup.where((group) {
        return group.members!
            .any((member) => member.uid == auth.currentUser!.uid);
      }).toList();

      return filteredGroups;
    });
  }

  // Future<void> sendGroupMessage(String message, groupId) async {
  //   isLoading.value = true;
  //   String groupChat_Id = uuid.v6();
  //   RxString tmp_GroupChatImage = ''.obs;
  //   if (groupChatImage.value.isNotEmpty) {
  //     tmp_GroupChatImage.value =
  //         await _profileController.uploadGroupImage(groupChatImage.value);
  //   }
  //   var newMsg = ChatInfo(
  //     id: groupChat_Id,
  //     message: message,
  //     imageUrl: tmp_GroupChatImage.value,
  //     senderId: auth.currentUser!.uid,
  //     senderName: _profileController.currentUser.value.name,
  //     timestamp: DateTime.now().toString(),
  //   );
  //   await db
  //       .collection('groups')
  //       .doc(groupId)
  //       .collection('messages')
  //       .doc(groupChat_Id)
  //       .set(newMsg.toJson());
  //   groupChatImage.value = '';
  //   isLoading.value = false;
  // }

  Future<void> sendGroupMessage(String message, String groupId) async {
    isLoading.value = true;
    String groupChatId = uuid.v6();
    RxString tmpGroupChatImage = ''.obs;

    if (groupChatImage.value.isNotEmpty) {
      tmpGroupChatImage.value =
          await _profileController.uploadGroupImage(groupChatImage.value);
    }

    var newMsg = ChatInfo(
      id: groupChatId,
      message: message,
      imageUrl: tmpGroupChatImage.value,
      senderId: auth.currentUser!.uid,
      senderName: _profileController.currentUser.value.name,
      timestamp: DateTime.now().toString(),
    );

    WriteBatch batch = db.batch();

    DocumentReference messageRef = db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(groupChatId);

    DocumentReference groupRef = db.collection('groups').doc(groupId);

    batch.set(messageRef, newMsg.toJson());

    batch.update(groupRef, {
      'lastMessage': message,
      'lastMessageTime': newMsg.timestamp,
      'lastMessageBy': newMsg.senderName,
    });

    await batch.commit();

    groupChatImage.value = '';
    isLoading.value = false;
  }

  Stream<List<ChatInfo>> getGroupMessages(String groupId) {
    return db
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (msg) => msg.docs
              .map(
                (e) => ChatInfo.fromJson(e.data()),
              )
              .toList(),
        );
  }
}

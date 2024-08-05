// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/Controller/Contact_Controller.dart';
import 'package:flutter_application_2/Controller/ProfileController.dart';
import 'package:flutter_application_2/ModelClass/Message_model.dart';
import 'package:flutter_application_2/ModelClass/chats_room_model.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MessageController extends GetxController {
  late SharedPreferences sp;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  final ProfileController _profileController = Get.put(ProfileController());
  final ContactController _contactController = Get.put(ContactController());
  var uuid = Uuid();
  RxString chat_Image = ''.obs;

  RxList<ChatRoomModel> currentChatsPerson = <ChatRoomModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _contactController.getContact().whenComplete(() {
      _contactController.getUserDetails().whenComplete(
            (() => getCurrentChatsRoom()),
          );
      update();
    });
    // await getCurrentChatsRoom();
  }

  //for genarate random id
  String? getRoomId(String targetUserId) {
    String currentUserId = auth.currentUser!.uid;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return '$currentUserId$targetUserId';
    } else {
      return '$targetUserId$currentUserId';
    }
  }

  Details getSender(Details currentUser, Details targetUser) {
    String currentUserId = currentUser.uid!;
    String targetUserId = targetUser.uid!;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return currentUser;
    } else {
      return targetUser;
    }
  }

  Details getReceiver(Details currentUser, Details targetUser) {
    String currentUserId = currentUser.uid!;
    String targetUserId = targetUser.uid!;
    if (currentUserId[0].codeUnitAt(0) > targetUserId[0].codeUnitAt(0)) {
      return targetUser;
    } else {
      return currentUser;
    }
  }

  Future<void> sendMessage(
      String targetUserId, message, Details receiverUser) async {
    isLoading.value = true;
    String messageId = uuid.v6();
    String? roomId = getRoomId(targetUserId);
    DateTime _timeStamp = DateTime.now();
    String _formatedTime = DateFormat('hh:mm a').format(_timeStamp);

    Details _sender =
        getSender(_profileController.currentUser.value, receiverUser);
    Details _receiver =
        getReceiver(_profileController.currentUser.value, receiverUser);
    RxString chatImageUrl = ''.obs;
    if (chat_Image.value.isNotEmpty) {
      chatImageUrl.value = await _profileController.sendImage(chat_Image.value);
    }

    var newMsg = ChatInfo(
      id: messageId,
      message: message,
      imageUrl: chatImageUrl.value,
      senderId: auth.currentUser!.uid,
      receiverId: targetUserId,
      senderName: _profileController.currentUser.value.name,
      timestamp: DateTime.now().toString(),
      readStatus: 'unread',
    );

    var roomDetails = ChatRoomModel(
      id: roomId,
      lastMessage: message,
      lastMessageTimestamp: _formatedTime,
      timestamp: DateTime.now().toString(),
      sender: _sender,
      receiver: _receiver,
      unReadMessNo: 0, // Add this field
    );
    try {
      await db
          .collection("chats")
          .doc(roomId)
          .collection("messages")
          .doc(messageId)
          .set(newMsg.toJson());
      await db
          .collection("chats")
          .doc(roomId)
          .set(roomDetails.toJson()); //for getting chatlist User
      await _contactController.saveContact(receiverUser); //for make Group
      chat_Image.value = '';
    } catch (e) {
      print(e.toString());
    }
    isLoading.value = false;
  }

  Stream<List<ChatInfo>> getAllMessages(String targetUserId) {
    String? roomId = getRoomId(targetUserId);

    if (roomId == null) {
      return Stream.value([]);
    }

    return db
        .collection("chats")
        .doc(roomId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .handleError((error) {
      // Log the error
      print("Error fetching messages: $error");
    }).map((snapshot) {
      try {
        return snapshot.docs
            .map((doc) {
              final data = doc.data();
              if (data != null) {
                return ChatInfo.fromJson(data as Map<String, dynamic>);
              }
              return null;
            })
            .where((chatInfo) => chatInfo != null)
            .map((chatInfo) => chatInfo as ChatInfo)
            .toList();
      } catch (e) {
        print("Error parsing messages: $e");
        return <ChatInfo>[];
      }
    });
  }

  // Stream<List<ChatRoomModel>> getCurrentChatsRoom() {
  //   return db
  //       .collection('chats')
  //       .orderBy("timestamp", descending: true)
  //       .snapshots()
  //       .asyncMap((snapshot) async {
  //     List<ChatRoomModel> chatRooms = [];
  //     for (var doc in snapshot.docs) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  //       // Fetch the sender and receiver details
  //       Map<String, dynamic> senderData = data['sender'];
  //       Map<String, dynamic> receiverData = data['receiver'];

  //       // Get the contact names
  //       String senderPhone = senderData['phone'];
  //       String receiverPhone = receiverData['phone'];

  //       String senderContactName =
  //           _contactController.getContactNameByPhone(senderPhone);
  //       String receiverContactName =
  //           _contactController.getContactNameByPhone(receiverPhone);

  //       // Update the sender and receiver details with the contact names
  //       senderData['name'] = senderContactName;
  //       receiverData['name'] = receiverContactName;

  //       // Update the data map
  //       data['sender'] = senderData;
  //       data['receiver'] = receiverData;

  //       // Convert the updated data to ChatRoomModel
  //       ChatRoomModel chatRoom = ChatRoomModel.fromJson(data);

  //       // Check if the chat room ID contains the current user ID
  //       if (chatRoom.id!.contains(auth.currentUser!.uid)) {
  //         chatRooms.add(chatRoom);
  //       }
  //     }
  //     return chatRooms;
  //   });
  // }

  Stream<List<ChatRoomModel>> getCurrentChatsRoom() {
    return db
        .collection('chats')
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatRoomModel.fromJson(doc.data()))
              .where((chatRoom) => chatRoom.id!.contains(auth.currentUser!.uid))
              .toList(),
        );
  }

  Stream<Details> getStatus(String userId) {
    return db.collection('users').doc(userId).snapshots().map((event) {
      return Details.fromJson(event.data()!);
    });
  }

  Future<void> updateReadStatus(String targetUserId, String messageId) async {
    String? roomId = getRoomId(targetUserId);

    try {
      await db
          .collection("chats")
          .doc(roomId)
          .collection("messages")
          .doc(messageId)
          .update({'readStatus': 'read'});
    } catch (e) {
      print("Error updating read status: $e");
    }
  }
}

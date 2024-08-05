import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/ChatController.dart';
import '../../../ModelClass/chats_room_model.dart';
import '../../../main.dart';
import '../../Contact_Access.dart';
import '../Individual_Chat_Page.dart';

class ChatsHome extends StatelessWidget {
  const ChatsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final MessageController _msgRoomController = Get.put(MessageController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<ChatRoomModel>>(
          stream: _msgRoomController.getCurrentChatsRoom(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error is: ' + snapshot.error.toString()),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('There is no available person.'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatItem = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        transition: Transition.leftToRightWithFade,
                        () => IndividualChatPage(
                          chatItem.receiver!.uid ==
                                  _msgRoomController.auth.currentUser!.uid
                              ? chatItem.sender!
                              : chatItem.receiver!,
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
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
                            child: (chatItem.receiver!.uid ==
                                            _msgRoomController
                                                .auth.currentUser!.uid
                                        ? chatItem.sender!.photo
                                        : chatItem.receiver!.photo)!
                                    .isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: chatItem.receiver!.uid ==
                                            _msgRoomController
                                                .auth.currentUser!.uid
                                        ? chatItem.sender!.photo!
                                        : chatItem.receiver!.photo!,
                                    fit: BoxFit.fill,
                                    width: 55,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        title: Text(
                          chatItem.receiver!.uid ==
                                  _msgRoomController.auth.currentUser!.uid
                              ? chatItem.sender!.name!
                              : chatItem.receiver!.name!,
                          style: TextStyle(
                            fontSize: 17,
                            color: appColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          chatItem.lastMessage!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: Text(
                          chatItem.lastMessageTimestamp!,
                          style: const TextStyle(
                              fontSize: 10, color: Colors.black87),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          'New Chat',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.message_rounded,
          color: Colors.white,
        ),
        heroTag: null,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactAccess(),
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

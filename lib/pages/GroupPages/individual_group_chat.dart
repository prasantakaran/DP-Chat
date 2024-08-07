// ignore_for_file: curly_braces_in_flow_control_structures, must_be_immutable, no_logic_in_create_state, avoid_unnecessary_containers, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/Controller/GroupController.dart';
import 'package:flutter_application_2/ModelClass/GroupModel.dart';
import 'package:flutter_application_2/pages/GroupPages/Widget/GroupProfile.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../ChatsPages/Widget/Chats_Display.dart';
import '../../Controller/ProfileController.dart';
import 'Widget/GroupChat_Display.dart';

class individualGroupChat extends StatefulWidget {
  GroupModel groupUser;
  individualGroupChat(this.groupUser);

  @override
  State<individualGroupChat> createState() =>
      _individualGroupChatState(groupUser);
}

class _individualGroupChatState extends State<individualGroupChat> {
  GroupModel groupUser;
  _individualGroupChatState(this.groupUser);

  ImagePicker _picker = ImagePicker();
  XFile? file;
  File? compressedImage;

  bool isMsgEnable = false;
  late TextEditingController msgcontroller;
  final addimgcaption = TextEditingController();

  bool isEmojishow = false;
  FocusNode focusNode = FocusNode();
  GroupController _groupController = Get.put(GroupController());

  void stopMonitoringConnectivity() {
    subscription.cancel();
  }

  startMonitoringConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (mounted)
        setState(() {
          if (result == ConnectivityResult.none) {
            connectionStatus = 'No internet connection';
            Fluttertoast.showToast(msg: connectionStatus);
          } else if (result == ConnectivityResult.wifi) {
            connectionStatus = 'Connected to Wi-Fi';
            Fluttertoast.showToast(msg: connectionStatus);
          } else if (result == ConnectivityResult.mobile) {
            connectionStatus = 'Connected to mobile data';
            Fluttertoast.showToast(msg: connectionStatus);
          }
        });
    });
    return connectionStatus;
  }

  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Unknown';
  @override
  void initState() {
    msgcontroller = TextEditingController();
    super.initState();
    startMonitoringConnectivity();
    focusNode.addListener(() {
      if (focusNode.hasFocus) if (mounted)
        setState(() {
          isEmojishow = false;
        });
    });
  }

  @override
  void dispose() {
    file = null;
    msgcontroller.dispose();
    addimgcaption.dispose();
    stopMonitoringConnectivity();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProfileController _profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appColor,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 10,
        title: InkWell(
          onTap: () {
            Get.to(
              () => GroupProfile(groupModel: groupUser),
            );
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            groupUser.profileUrl!.isNotEmpty
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(groupUser.profileUrl!),
                  )
                : CircleAvatar(
                    child: Icon(
                      Icons.person_2,
                      size: 27,
                    ),
                  ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupUser.name!,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                AutoSizeText(
                  'online',
                  style: TextStyle(fontSize: 11.5, color: Colors.white60),
                ),
              ],
            ),
          ]),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 5, top: 10, left: 10, right: 10),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: _groupController.getGroupMessages(groupUser.id!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data == null) {
                      return Center(
                        child: AutoSizeText('There is no messages.'),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final userMessages = snapshot.data![index];

                          DateTime _timeStamp =
                              DateTime.parse(userMessages.timestamp!);
                          String _formatTime =
                              DateFormat('hh:mm a').format(_timeStamp);
                          return GroupChatsDisplay(
                            senderName: userMessages.senderName!,
                            message: userMessages.message!,
                            isComming: userMessages.senderId !=
                                _profileController.currentUser.value.uid,
                            time: _formatTime,
                            status: 'read',
                            imageUrl: userMessages.imageUrl ?? "",
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: TextField(
                              textAlign: TextAlign.start,
                              cursorHeight: 23,
                              cursorColor: Colors.blue[10000],
                              focusNode: focusNode,
                              controller: msgcontroller,
                              maxLines: 4,
                              minLines: 1,
                              onChanged: (value) {
                                setState(() {
                                  isMsgEnable = value.isNotEmpty;
                                });
                              },
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.emoji_emotions,
                                  ),
                                  onPressed: () {
                                    focusNode.unfocus();
                                    focusNode.canRequestFocus = false;
                                    if (mounted)
                                      setState(
                                        () {
                                          isEmojishow = !isEmojishow;
                                        },
                                      );
                                  },
                                ),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            constraints: BoxConstraints(
                                                minHeight: 170, maxHeight: 180),
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (builder) =>
                                                bottomsheet(context),
                                          );
                                        },
                                        icon: Icon(Icons.attach_file_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await _pickImage(ImageSource.camera);
                                        },
                                        icon: Icon(Icons.camera_alt_outlined),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: "Type message...",
                                hintStyle: TextStyle(
                                  color: appColor,
                                  letterSpacing: 0.5,
                                  fontSize: 14,
                                ),
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          backgroundColor: appColor,
                          radius: 25,
                          child: IconButton(
                            onPressed: () async {
                              if (msgcontroller.text.isNotEmpty) {
                                _groupController.sendGroupMessage(
                                  msgcontroller.text.trim(),
                                  groupUser.id!,
                                );
                                msgcontroller.clear();
                                setState(() {
                                  isMsgEnable = false;
                                });
                              }
                            },
                            icon: msgcontroller.text.isNotEmpty
                                ? Icon(
                                    Icons.send_outlined,
                                    color: Colors.greenAccent,
                                    size: 26,
                                  )
                                : Icon(
                                    Icons.mic_none_outlined,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ],
                    ),
                    isEmojishow ? emojipicker() : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onBackspacePressed() {
    msgcontroller
      ..text = msgcontroller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: msgcontroller.text.length),
      );
  }

  Widget emojipicker() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .35,
      child: EmojiPicker(
        onBackspacePressed: _onBackspacePressed,
        textEditingController: msgcontroller,
        onEmojiSelected: (category, emoji) {
          if (mounted)
            setState(() {
              // isEmojishow == true && msgcontroller.text.isNotEmpty
              //     ? isMsgEnable = true
              //     : isMsgEnable = false;
            });
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    file = await _picker.pickImage(source: source);
    if (file != null) {
      _groupController.groupChatImage.value = file!.path;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => imagesend(),
      );
    }
  }

  Widget bottomsheet(BuildContext context) {
    return SizedBox(
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconselect(
                    Icons.camera_alt,
                    Colors.pink,
                    "Camera",
                    () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.camera);
                    },
                  ),
                  iconselect(
                    Icons.insert_photo_outlined,
                    Colors.purple,
                    "Gallery",
                    () async {
                      Navigator.pop(context);
                      await _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconselect(IconData icon, Color color, String text, tap) {
    return InkWell(
      // onTap: ontap,
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 30,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
                color: appColor, fontWeight: FontWeight.bold, fontSize: 13),
          )
        ],
      ),
    );
  }

  Widget imagesend() {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appColor,
            title: Row(
              children: [
                Text(
                  groupUser.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    file = null;
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.file(
                  File(file!.path),
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    Container(
                      color: Colors.black38,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        controller: addimgcaption,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                        decoration: InputDecoration(
                          hintText: 'Type message',
                          border: InputBorder.none,
                          prefixIcon: IconButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await _pickImage(ImageSource.gallery);
                              },
                              icon: Icon(
                                color: Colors.white,
                                size: 30,
                                Icons.add_photo_alternate,
                              )),
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          suffixIcon: CircleAvatar(
                            backgroundColor: appColor,
                            radius: 26,
                            child: IconButton(
                              onPressed: () {
                                if (file != null) {
                                  _groupController.isLoading.value = true;
                                  _groupController
                                      .sendGroupMessage(
                                    addimgcaption.text.trim(),
                                    groupUser.id!,
                                  )
                                      .then((value) {
                                    _groupController.isLoading.value = false;
                                    Navigator.pop(context);
                                  });
                                  addimgcaption.clear();
                                }
                              },
                              icon: _groupController.isLoading.value
                                  ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.send,
                                      size: 23,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_groupController.isLoading.value)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: appColor,
                      ),
                      AutoSizeText(
                        'Please wait..',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: appColor),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

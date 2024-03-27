// ignore_for_file: curly_braces_in_flow_control_structures, must_be_immutable, no_logic_in_create_state, avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/User_Profile.dart';
import 'package:flutter_application_2/pages/chat_information.dart';
import 'package:flutter_application_2/pages/chatcontroler.dart';
import 'package:flutter_application_2/pages/User_Details_Model.dart';
import 'package:flutter_application_2/util/myurl.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path_provider/path_provider.dart' as path_provider;

class IndividualChatPage extends StatefulWidget {
  // const IndividualChatPage({super.key});
  Details user;
  IndividualChatPage(this.user);

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState(user);
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  Details user;
  _IndividualChatPageState(this.user);

  ImagePicker _picker = ImagePicker();
  XFile? file;
  File? com_img;

  bool isMsgEnable = false;
  late TextEditingController msgcontroller;
  // List<Message> messages = [];
  ChatControler messagesobj = ChatControler();
  late SharedPreferences sp;
  String senderid = '';
  final scrollController = ScrollController();
  // int poptime = 0;
  String attach = '';
  final addimgcaption = TextEditingController();
  StreamController<List<Message>> msglist = StreamController();
  late Stream<List<Message>> msgstream;
  Timer? timer;
  bool isEmojishow = false;
  FocusNode focusNode = FocusNode();

  String time = DateFormat("HH:mm:ss").format(DateTime.now()).substring(0, 4);
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());

  Future getMasseges(String senderid, String receiverid) async {
    Map data = {'sender_id': senderid, 'receiver_id': receiverid};
    // print(data);
    var response = await http
        .post(Uri.http(Myurl.mainurl, Myurl.suburl + "getmsg.php"), body: data);
    var jsondata = jsonDecode(response.body);
    if (jsondata['status'] == true) {
      messagesobj.chatmessage.clear();
      for (int i = 0; i < jsondata['data'].length; i++) {
        Message message = Message(
            send_id: jsondata['data'][i]['sender_id'],
            reci_id: jsondata['data'][i]['receiver_id'],
            msg_date: jsondata['data'][i]['msg_date'],
            msg_time: jsondata['data'][i]['msg_time'],
            content: jsondata['data'][i]['content'],
            attach: jsondata['data'][i]['attachment']);
        messagesobj.chatmessage.add(message);
      }
      msglist.add(messagesobj.chatmessage);
      // _posts = Stream<List<Message>>.fromIterable(<List<Message>>[messages]);
      if (mounted) setState(() {});
      // return messagesobj.chatmessage;
    }
  }

  Future MessegeInsert(String send_id, String receiver_id, String msg_date,
      String msg_time, String content, File? attach) async {
    try {
      var response = await http.MultipartRequest(
        "POST",
        Uri.parse(Myurl.fullurl + "msg_send.php"),
      );
      if (attach != null) {
        response.files.add(await http.MultipartFile.fromBytes(
            'attach', attach.readAsBytesSync(),
            filename: attach.path.split("/").last));
      }
      response.fields['send_id'] = send_id;
      response.fields['reci_id'] = receiver_id;
      response.fields['msg_date'] = msg_date;
      response.fields['msg_time'] = msg_time;
      response.fields['content'] = content;
      var responce = await response.send();
      var res = await http.Response.fromStream(responce);
      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        this.attach = jsondata['attachdata'].toString();
        print("Message Send Successfully");
      } else {
        print("not Send");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

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
    getSenderId().whenComplete(() {
      connect();
      getMasseges(senderid, user.uid).whenComplete(() {
        scrollToEnd();
      });
    });

    msgstream = msglist.stream.asBroadcastStream();
    // print(msgstream);
    focusNode.addListener(() {
      if (focusNode.hasFocus) if (mounted)
        setState(() {
          isEmojishow = false;
        });
    });
  }

  Future getSenderId() async {
    sp = await SharedPreferences.getInstance();
    senderid = sp.getString('uid') ?? "";
  }

  Future scrollToEnd() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          // );
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    msgcontroller.dispose();
    addimgcaption.dispose();
    socket.disconnect();
    socket.dispose();
    stopMonitoringConnectivity();
    super.dispose();
    // timer!.cancel();
  }

  late IO.Socket socket;
  void connect() {
    socket = IO.io("http://192.168.0.107:5000", <String, dynamic>{
      "transports": ["websocket"],
      // "reconnection": true,
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("dashboard", senderid);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message-recived", (data) {
        print(data);
        messagesobj.chatmessage.add(Message.fromJosn(data["message"]));
        scrollToEnd();
      });
    });
    print(socket.connected);
    socket.onDisconnect((_) {
      print("Disconnected Successfull");
    });
  }

  void checkImageSize() async {
    final byts = await file!.readAsBytes();
    final kb = byts.length / 1024;
    final mb = kb / 1024;

    final newbyts = await com_img!.readAsBytes();
    final newkb = newbyts.length / 1024;
    final newmb = newkb / 1024;

    print("Before compreesed  ${mb}");
    print("After compreesed  ${newmb}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 10,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserProfile(user)));
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              // mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                user.photo != ""
                    ? CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            Myurl.fullurl + Myurl.imageurl + user.photo),
                      )
                    : const CircleAvatar(
                        child: Icon(Icons.person_2),
                      ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ]),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            color: Color.fromARGB(255, 234, 248, 255),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              Expanded(
                child: WillPopScope(
                  child: StreamBuilder<List<Message>>(
                    stream: msgstream,
                    builder: (context, snapshot) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (scrollController.hasClients) {
                          // print(snapshot);
                          scrollController.jumpTo(
                              scrollController.position.maxScrollExtent);
                        } else {
                          if (mounted) setState(() {});
                        }
                      });
                      return Obx(
                        () => InkWell(
                          onLongPress: () {
                            print("press done");
                          },
                          child: ListView.builder(
                            // physics: const BouncingScrollPhysics(),
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: messagesobj.chatmessage.length,
                            itemBuilder: ((context, index) {
                              if (index == messagesobj.chatmessage.length) {
                                scrollToEnd();
                              }
                              //Check Sender Part :-
                              if (messagesobj.chatmessage[index].send_id ==
                                  senderid) {
                                //Check Attachment is not blank
                                if (messagesobj.chatmessage[index].attach ==
                                    '') {
                                  return Align(
                                      alignment: Alignment.centerRight,
                                      child: sendermsgview(
                                          msg: messagesobj
                                              .chatmessage[index].content,
                                          time: messagesobj
                                              .chatmessage[index].msg_time));
                                } else {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: sendernetworkimageview(
                                        imagefile: messagesobj
                                            .chatmessage[index].attach,
                                        msg: messagesobj
                                            .chatmessage[index].content),
                                  );
                                }
                                //Check Receiver Part :-
                              } else {
                                //Check Attachment is not blank
                                if (messagesobj.chatmessage[index].attach ==
                                    '') {
                                  return Align(
                                      alignment: Alignment.centerLeft,
                                      child: receivermsgview(
                                          msg: messagesobj
                                              .chatmessage[index].content,
                                          time: messagesobj
                                              .chatmessage[index].msg_time));
                                } else {
                                  return Align(
                                      alignment: Alignment.centerLeft,
                                      child: receiverimageview(
                                          imagefile: messagesobj
                                              .chatmessage[index].attach,
                                          msg: messagesobj
                                              .chatmessage[index].content));
                                }
                              }
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  onWillPop: () {
                    if (isEmojishow) {
                      if (mounted)
                        setState(() {
                          isEmojishow = !isEmojishow;
                        });
                      return Future.value(false);
                    } else {
                      return Future.value(true);
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                // child: Container(
                // height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Card(
                            margin:
                                EdgeInsets.only(left: 2, right: 2, bottom: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: TextFormField(
                              textAlign: TextAlign.start,
                              cursorHeight: 23,
                              cursorColor: Colors.blue[10000],
                              focusNode: focusNode,
                              controller: msgcontroller,
                              maxLines: 4,
                              minLines: 1,
                              onChanged: (value) {
                                value.isEmpty
                                    ? setState(() => isMsgEnable = false)
                                    : setState(() => isMsgEnable = true);
                              },
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.emoji_emotions),
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (bulider) =>
                                                    bottonsheet());
                                          },
                                          icon:
                                              Icon(Icons.attach_file_outlined),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              file = await _picker.pickImage(
                                                  source: ImageSource.camera);
                                              final dir = await path_provider
                                                  .getTemporaryDirectory();
                                              final terget_path =
                                                  '${dir.absolute.path}/temp.jpg';
                                              final Com_file =
                                                  await FlutterImageCompress
                                                      .compressAndGetFile(
                                                          file!.path,
                                                          terget_path,
                                                          minHeight: 1080,
                                                          minWidth: 1080,
                                                          quality: 90);
                                              com_img = File(Com_file!.path);

                                              checkImageSize();
                                              if (com_img != null)
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) =>
                                                        imagesend());
                                            },
                                            icon:
                                                Icon(Icons.camera_alt_outlined))
                                      ],
                                    ),
                                  ),
                                  hintText: "Type message...",
                                  hintStyle: TextStyle(
                                      letterSpacing: 0.5, fontSize: 18),
                                  contentPadding: EdgeInsets.all(5)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                          child: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            radius: 25,
                            child: IconButton(
                                onPressed: () async {
                                  if (msgcontroller.text.trim() != '') {
                                    var messagejosn = {
                                      "send_id": senderid,
                                      "reci_id": user.uid,
                                      "msg_date": date,
                                      "msg_time": time,
                                      "content": msgcontroller.text.trim(),
                                      "attach": ''
                                    };
                                    print(messagejosn);
                                    socket.emit("message", {
                                      "message": messagejosn,
                                      "send_id": senderid,
                                      "reci_id": user.uid
                                    });

                                    MessegeInsert(senderid, user.uid, date,
                                        time, msgcontroller.text.trim(), null);
                                    messagesobj.chatmessage
                                        .add(Message.fromJosn(messagejosn));
                                    if (mounted)
                                      setState(() {
                                        msgcontroller.text = '';
                                        isMsgEnable = false;
                                        scrollToEnd();
                                      });
                                  }
                                },
                                icon: isMsgEnable
                                    ? Icon(
                                        Icons.send_outlined,
                                        // color: Colors.greenAccent,
                                      )
                                    : Icon(Icons.mic_none_outlined)),
                          ),
                        ),
                      ],
                    ),
                    isEmojishow ? emojipicker() : Container(),
                  ],
                ),
                // ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  _onBackspacePressed() {
    msgcontroller
      ..text = msgcontroller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: msgcontroller.text.length));
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
              isEmojishow == true && msgcontroller.text.isNotEmpty
                  ? isMsgEnable = true
                  : isMsgEnable = false;
            });
        },
        config: Config(
          columns: 7,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        ),
      ),
    );
  }

  Widget bottonsheet() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // iconselect(Icons.insert_drive_file, Colors.indigo, "Document",
                  //     () {}),
                  iconselect(Icons.camera_alt, Colors.pink, "Camera", () async {
                    Navigator.pop(context);
                    file = await _picker.pickImage(source: ImageSource.camera);

                    final dir = await path_provider.getTemporaryDirectory();
                    final terget_path = '${dir.absolute.path}/temp.jpg';
                    final Com_file =
                        await FlutterImageCompress.compressAndGetFile(
                            file!.path, terget_path,
                            minHeight: 1080, minWidth: 1080, quality: 90);
                    com_img = File(Com_file!.path);

                    checkImageSize();

                    if (com_img != null)
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => imagesend(),
                      );
                  }),
                  iconselect(
                      Icons.insert_photo_outlined, Colors.purple, "Gallery",
                      () async {
                    Navigator.pop(context);
                    file = await _picker.pickImage(source: ImageSource.gallery);

                    final dir = await path_provider.getTemporaryDirectory();
                    final terget_path = '${dir.absolute.path}/temp.jpg';
                    final Com_file =
                        await FlutterImageCompress.compressAndGetFile(
                            file!.path, terget_path,
                            minHeight: 1080, minWidth: 1080, quality: 90);
                    com_img = File(Com_file!.path);

                    checkImageSize();
                    if (com_img != null)
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => imagesend());
                  }),
                ],
              ),
              SizedBox(
                height: 25,
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
          Text(text)
        ],
      ),
    );
  }

  Widget imagesend() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          user.name,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.crop_rotate, size: 27),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.emoji_emotions_outlined, size: 27),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.title, size: 27),
          // ),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.edit, size: 27),
          // ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.file(
                File(com_img!.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Container(
                    color: Colors.black38,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: addimgcaption,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      decoration: InputDecoration(
                          hintText: 'Add caption',
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                            size: 27,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 17),
                          suffixIcon: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            radius: 26,
                            child: IconButton(
                                onPressed: () {
                                  if (com_img != null) {
                                    Navigator.pop(context);

                                    MessegeInsert(
                                            senderid,
                                            user.uid,
                                            date,
                                            time,
                                            addimgcaption.text,
                                            File(com_img!.path))
                                        .whenComplete(() {
                                      var messagejosn = {
                                        "send_id": senderid,
                                        "reci_id": user.uid,
                                        "msg_date": date,
                                        "msg_time": time,
                                        "content": addimgcaption.text.trim(),
                                        "attach": attach,
                                      };
                                      print(messagejosn);
                                      socket.emit("message", {
                                        "message": messagejosn,
                                        "send_id": senderid,
                                        "reci_id": user.uid
                                      });
                                      if (mounted)
                                        setState(() {
                                          messagesobj.chatmessage.add(
                                              Message.fromJosn(messagejosn));
                                          scrollToEnd();
                                          // com_img = null;
                                          attach = '';
                                          addimgcaption.text = '';
                                        });
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  size: 25,
                                )),
                          )),
                    ),
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

class sendermsgview extends StatelessWidget {
  sendermsgview({super.key, required this.msg, required this.time});
  String msg;
  String time;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 45,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            // bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(30),
          ),
        ),
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Colors.greenAccent,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.deepPurpleAccent, width: 2),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                // bottomRight: Radius.circular(25),
              )),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 60, top: 5, bottom: 20),
                child: Text(
                  msg,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (msg.isNotEmpty)
                      Icon(
                        Icons.done_all,
                        size: 20,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class receivermsgview extends StatelessWidget {
  receivermsgview({super.key, required this.msg, required this.time});
  String msg;
  String time;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 45,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            // topLeft: Radius.circular(25),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
        ),
        elevation: 10,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        color: Color.fromARGB(255, 221, 245, 255),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 2),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                // topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 60, top: 5, bottom: 20),
                child: Text(
                  msg,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class receiverimageview extends StatelessWidget {
  receiverimageview({super.key, required this.imagefile, required this.msg});
  String imagefile;
  String msg;
  @override
  Widget build(BuildContext context) {
    if (imagefile != '' && msg != '') {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 100,
        ),
        // padding: const EdgeInsets.only(right: 110, left: 10, bottom: 10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .03,
                vertical: MediaQuery.of(context).size.width * .01),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(width: 3, color: Colors.greenAccent),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                // topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Container(
                                child: PhotoView(
                              maxScale: 2.0,
                              minScale: 0.5,
                              imageProvider: NetworkImage(
                                Myurl.fullurl + Myurl.msgimageurl + imagefile,
                              ),
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      Myurl.fullurl + Myurl.msgimageurl + imagefile,
                      width: 250,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  msg,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 100,
          ),
          // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            // height: MediaQuery.of(context).size.height / 2.7,
            // width: MediaQuery.of(context).size.width / 1.8,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .03,
                vertical: MediaQuery.of(context).size.width * .01),
            decoration: BoxDecoration(
              color: Colors.teal,
              border: Border.all(width: 3, color: Colors.greenAccent),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                // topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Container(
                            child: PhotoView(
                          maxScale: 2.0,
                          minScale: 0.2,
                          imageProvider: NetworkImage(
                            Myurl.fullurl + Myurl.msgimageurl + imagefile,
                          ),
                        )));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  Myurl.fullurl + Myurl.msgimageurl + imagefile,
                  // height: 300,
                  // width: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class sendernetworkimageview extends StatelessWidget {
  sendernetworkimageview(
      {super.key, required this.imagefile, required this.msg});
  String imagefile;
  String msg;
  @override
  Widget build(BuildContext context) {
    if (imagefile != '' && msg != '') {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 100,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          // child: Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .03,
                vertical: MediaQuery.of(context).size.width * .01),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(width: 3, color: Colors.greenAccent),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(30),
                // bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Container(
                        child: PhotoView(
                            maxScale: 5.0,
                            minScale: 0.5,
                            imageProvider: NetworkImage(
                                Myurl.fullurl + Myurl.msgimageurl + imagefile)),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      Myurl.fullurl + Myurl.msgimageurl + imagefile,
                      width: 250,
                      height: 300,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(msg),
              ],
            ),
          ),
        ),
      );
    } else {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 100,
        ),
        // padding: const EdgeInsets.only(left: 110),
        child: Align(
          alignment: Alignment.centerRight,
          // child: Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .03,
                vertical: MediaQuery.of(context).size.width * .01),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(width: 2, color: Colors.greenAccent),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(30),
                // bottomRight: Radius.circular(30),
              ),
            ),
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Container(
                          child: PhotoView(
                              maxScale: 3.0,
                              minScale: 0.3,
                              imageProvider: NetworkImage(Myurl.fullurl +
                                  Myurl.msgimageurl +
                                  imagefile)),
                        ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  Myurl.fullurl + Myurl.msgimageurl + imagefile,
                  // width: 500,
                  // height: 500,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        // ),
      );
    }
  }
}

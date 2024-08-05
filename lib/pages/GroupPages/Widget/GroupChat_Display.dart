// ignore_for_file: prefer_const_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_2/main.dart';

class GroupChatsDisplay extends StatelessWidget {
  final String message;
  final bool isComming;
  final String time;
  final String status;
  final String imageUrl;
  final String senderName;

  const GroupChatsDisplay(
      {super.key,
      required this.message,
      required this.isComming,
      required this.time,
      required this.status,
      required this.imageUrl,
      required this.senderName});

  @override
  Widget build(BuildContext context) {
    final txtStyle = TextStyle(fontSize: 5);
    final msgTxtStyle = TextStyle(
        color: isComming ? Colors.black : Colors.white,
        fontSize: 14.5,
        fontWeight: FontWeight.w500);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment:
            isComming ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          isComming
              ? AutoSizeText(
                  senderName,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : SizedBox(),
          Container(
            padding: EdgeInsets.all(11),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.3),
            decoration: BoxDecoration(
              color: isComming ? chatColor.withOpacity(0.5) : appColor,
              borderRadius: isComming
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(10),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(0),
                    ),
            ),
            child: imageUrl == ""
                ? AutoSizeText(
                    message,
                    style: msgTxtStyle,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                          errorWidget: (context, url, error) {
                            return Icon(Icons.error);
                          },
                        ),
                      ),
                      message.isEmpty ? Container() : SizedBox(height: 5),
                      message.isEmpty
                          ? Container()
                          : AutoSizeText(message, style: msgTxtStyle),
                    ],
                  ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment:
                isComming ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              isComming
                  ? AutoSizeText(
                      time,
                      style: txtStyle,
                    )
                  : Row(
                      children: [
                        AutoSizeText(
                          time,
                          style: txtStyle,
                        ),
                        Icon(
                          Icons.done_all,
                          size: 17,
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

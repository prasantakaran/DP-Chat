import 'package:flutter_application_2/ModelClass/Message_model.dart';
import 'package:flutter_application_2/ModelClass/User_Details_Model.dart';

class ChatRoomModel {
  String? id;
  Details? sender;
  Details? receiver;
  List<ChatInfo>? messages;
  int? unReadMessNo;
  String? toUnreadCount;
  String? fromUnreadCount;
  String? lastMessage;
  String? lastMessageTimestamp;
  String? timestamp;

  ChatRoomModel(
      {this.id,
      this.sender,
      this.receiver,
      this.messages,
      this.unReadMessNo,
      this.toUnreadCount,
      this.fromUnreadCount,
      this.lastMessage,
      this.lastMessageTimestamp,
      this.timestamp});

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["sender"] is Map) {
      sender = json["sender"] == null ? null : Details.fromJson(json["sender"]);
    }
    if (json["receiver"] is Map) {
      receiver =
          json["receiver"] == null ? null : Details.fromJson(json["receiver"]);
    }
    if (json["messages"] is List) {
      messages = json["messages"] ?? [];
    }
    if (json["unReadMessNo"] is int) {
      unReadMessNo = json["unReadMessNo"];
    }
    if (json["toUnreadCount"] is String) {
      toUnreadCount = json["toUnreadCount"];
    }
    if (json["fromUnreadCount"] is String) {
      fromUnreadCount = json["fromUnreadCount"];
    }
    if (json["lastMessage"] is String) {
      lastMessage = json["lastMessage"];
    }
    if (json["lastMessageTimestamp"] is String) {
      lastMessageTimestamp = json["lastMessageTimestamp"];
    }
    if (json["timestamp"] is String) {
      timestamp = json["timestamp"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (sender != null) {
      _data["sender"] = sender?.toJson();
    }
    if (receiver != null) {
      _data["receiver"] = receiver?.toJson();
    }
    if (messages != null) {
      _data["messages"] = messages;
    }
    _data["unReadMessNo"] = unReadMessNo;
    _data["toUnreadCount"] = toUnreadCount;
    _data["fromUnreadCount"] = fromUnreadCount;
    _data["lastMessage"] = lastMessage;
    _data["lastMessageTimestamp"] = lastMessageTimestamp;
    _data["timestamp"] = timestamp;
    return _data;
  }
}

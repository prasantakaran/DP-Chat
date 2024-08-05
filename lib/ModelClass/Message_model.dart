class ChatInfo {
  String? id;
  String? message;
  String? senderName;
  String? senderId;
  String? receiverId;
  String? timestamp;
  String? readStatus;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? documentsUrl;
  List<String>? reaction;
  List<dynamic>? replies;

  ChatInfo(
      {this.id,
      this.message,
      this.senderName,
      this.senderId,
      this.receiverId,
      this.timestamp,
      this.readStatus,
      this.imageUrl,
      this.videoUrl,
      this.audioUrl,
      this.documentsUrl,
      this.reaction,
      this.replies});

  ChatInfo.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      id = json['id'].toString();
    }
    if (json['message'] is String) {
      message = json['message'].toString();
    }
    if (json['senderName'] is String) {
      senderName = json['senderName'].toString();
    }
    if (json['senderId'] is String) {
      senderId = json['senderId'].toString();
    }
    if (json['receiverId'] is String) {
      receiverId = json['receiverId'].toString();
    }
    if (json['timestamp'] is String) {
      timestamp = json['timestamp'].toString();
    }
    if (json['readStatus'] is String) {
      readStatus = json['readStatus'].toString();
    }
    if (json['imageUrl'] is String) {
      imageUrl = json['imageUrl'].toString();
    }
    if (json['videoUrl'] is String) {
      videoUrl = json['videoUrl'].toString();
    }
    if (json['audioUrl'] is String) {
      audioUrl = json['audioUrl'].toString();
    }
    if (json['documentsUrl'] is String) {
      documentsUrl = json['documentsUrl'].toString();
    }
    if (json['reaction'] is List) {
      reaction =
          json['reaction'] == null ? null : List<String>.from(json['reaction']);
    }
    if (json['replies'] is List) {
      replies = json['replies'] ?? [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['senderName'] = senderName;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['timestamp'] = timestamp;
    data['readStatus'] = readStatus;
    data['imageUrl'] = imageUrl;
    data['videoUrl'] = videoUrl;
    data['audioUrl'] = audioUrl;
    data['documentsUrl'] = documentsUrl;
    if (reaction != null) {
      data['reaction'] = reaction;
    }
    if (replies != null) {
      data['replies'] = replies;
    }
    return data;
  }
}

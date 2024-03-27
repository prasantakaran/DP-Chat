class Message {
  String id = '',
      send_id = '',
      reci_id = '',
      msg_date = '',
      msg_time = '',
      content = '',
      attach = '';
  Message(
      {required this.send_id,
      required this.reci_id,
      required this.msg_date,
      required this.msg_time,
      required this.content,
      required this.attach,
      this.id = "0"});
  factory Message.fromJosn(Map<String, dynamic> josn) {
    return Message(
        send_id: josn["send_id"],
        reci_id: josn["reci_id"],
        msg_date: josn["msg_date"],
        msg_time: josn["msg_time"],
        content: josn["content"],
        attach: josn["attach"]);
  }
}

class Attachment {
  String attach = '';
  Attachment({required this.attach});
}

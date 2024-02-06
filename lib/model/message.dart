class Message {
  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.fromId,
    required this.type,
  });

  late String toId;
  late String msg;
  late String read;
  late String sent;
  late String fromId;
  late Type type;

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['sent'] = sent;
    data['fromId'] = fromId;
    data['type'] = type == Type.image ? Type.image.name : Type.text.name;
    return data;
  }
}

enum Type {
  text,
  image,
}

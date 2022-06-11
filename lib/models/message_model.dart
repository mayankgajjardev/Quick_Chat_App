class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdAt;

  MessageModel({
    this.messageId,
    this.sender,
    this.text,
    this.seen,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdAt': createdAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'],
      sender: map['sender'],
      text: map['text'],
      seen: map['seen'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}

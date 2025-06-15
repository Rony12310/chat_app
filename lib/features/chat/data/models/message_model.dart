import '../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String id,
    required String senderId,
    required String content,
    required DateTime timestamp,
  }) : super(id: id, senderId: senderId, content: content, timestamp: timestamp);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

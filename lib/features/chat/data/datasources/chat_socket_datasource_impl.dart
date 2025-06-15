import 'dart:convert';

import '../../domain/entities/message.dart';
import '../models/message_model.dart';
import '../../../../core/network/socket_manager.dart';

class ChatSocketDataSourceImpl {
  final SocketManager socketManager;

  ChatSocketDataSourceImpl(this.socketManager);

  Stream<Message> getMessages() {
    return socketManager.messageStream.map((jsonString) {
      final jsonMap = json.decode(jsonString);
      return MessageModel.fromJson(jsonMap);
    });
  }

  void sendMessage(Message message) {
    final messageModel = MessageModel(
      id: message.id,
      senderId: message.senderId,
      content: message.content,
      timestamp: message.timestamp,
    );
    socketManager.sendMessage(messageModel.toJson());
  }
}

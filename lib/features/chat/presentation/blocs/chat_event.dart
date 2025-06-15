import '../../domain/entities/message.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final Message message;
  SendMessageEvent(this.message);
}

class ReceiveMessageEvent extends ChatEvent {
  final Message message;
  ReceiveMessageEvent(this.message);
}

import '../entities/message.dart';

abstract class ChatRepository {
  Stream<Message> getMessages();
  Future<void> sendMessage(Message message);
}

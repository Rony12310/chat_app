import '../repositories/chat_repository.dart';
import '../entities/message.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call(Message message) {
    return repository.sendMessage(message);
  }
}

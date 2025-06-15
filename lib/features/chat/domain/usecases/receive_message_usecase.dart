import '../repositories/chat_repository.dart';
import '../entities/message.dart';

class ReceiveMessagesUseCase {
  final ChatRepository repository;

  ReceiveMessagesUseCase(this.repository);

  Stream<Message> call() {
    return repository.getMessages();
  }
}

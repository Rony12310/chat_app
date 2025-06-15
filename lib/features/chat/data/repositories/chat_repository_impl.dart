import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_socket_datasource_impl.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketDataSourceImpl dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Stream<Message> getMessages() {
    return dataSource.getMessages();
  }

  @override
  Future<void> sendMessage(Message message) async {
    dataSource.sendMessage(message);
  }
}

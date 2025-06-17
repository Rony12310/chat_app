import 'package:get_it/get_it.dart';

import '../../features/chat/data/datasources/chat_socket_datasource_impl.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/receive_message_usecase.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/presentation/blocs/chat_bloc.dart';
import '../network/socket_manager.dart';

final sl = GetIt.instance;

Future<void> init(String url) async {
  // Register socket manager singleton and connect immediately
  final socketManager = SocketManager();
  socketManager.connect(url);
  sl.registerSingleton<SocketManager>(socketManager);

  // Data Source
  sl.registerLazySingleton<ChatSocketDataSourceImpl>(
    () => ChatSocketDataSourceImpl(sl<SocketManager>()),
  );

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<ChatSocketDataSourceImpl>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => ReceiveMessagesUseCase(sl()));

  // Bloc
  sl.registerFactoryParam<ChatBloc, String, String>(
    (deviceId, deviceName) =>
        ChatBloc(sl<SocketManager>(), deviceId, deviceName),
  );
}

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
  // Register SocketManager singleton
  sl.registerLazySingleton<SocketManager>(() => SocketManager());

  // Await the socket connection before proceeding
  sl<SocketManager>().connect(url);

  // Register data source using SocketManager instance
  sl.registerLazySingleton<ChatSocketDataSourceImpl>(
        () => ChatSocketDataSourceImpl(sl<SocketManager>()),
  );

  // Register repository
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(sl<ChatSocketDataSourceImpl>()),
  );

  // Register use cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl<ChatRepository>()));
  sl.registerLazySingleton(() => ReceiveMessagesUseCase(sl<ChatRepository>()));

  // FIXED: Register bloc with correct constructor (only SocketManager)
  sl.registerFactory(() => ChatBloc(sl<SocketManager>()));
}

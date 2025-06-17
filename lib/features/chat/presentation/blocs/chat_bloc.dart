import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/socket_manager.dart';
import '../../domain/entities/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SocketManager socketManager;
  final String deviceId;
  final String deviceName; // <--- Add deviceName here
  late StreamSubscription<String> _socketSubscription;

  ChatBloc(this.socketManager, this.deviceId, this.deviceName)
    : super(ChatState.initial()) {
    _socketSubscription = socketManager.messageStream.listen((data) {
      try {
        final map = jsonDecode(data);
        final message = Message(
          id: map['id'],
          senderId: map['senderId'],
          senderName: map['senderName'] ?? 'Unknown',
          content: map['content'],
          timestamp: DateTime.parse(map['timestamp']),
        );
        add(ReceiveMessageEvent(message));
      } catch (e) {
        print('ChatBloc: Error parsing message: $e');
      }
    });

    on<SendMessageEvent>((event, emit) {
      final newMessages = List<Message>.from(state.messages)
        ..add(event.message);
      emit(state.copyWith(messages: newMessages));
      socketManager.sendMessage({
        "id": event.message.id,
        "senderId": event.message.senderId,
        "senderName": event.message.senderName,
        "content": event.message.content,
        "timestamp": event.message.timestamp.toIso8601String(),
      });
    });

    on<ReceiveMessageEvent>((event, emit) {
      final newMessages = List<Message>.from(state.messages)
        ..add(event.message);
      emit(state.copyWith(messages: newMessages));
    });
  }

  @override
  Future<void> close() {
    _socketSubscription.cancel();
    socketManager.dispose();
    return super.close();
  }
}

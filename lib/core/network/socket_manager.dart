import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class SocketManager {
  WebSocketChannel? _channel;
  final _messageController = StreamController<String>.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  void connect(String url) {
    print('SocketManager: Connecting to $url');
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((data) {
      print('SocketManager: Received data: $data');
      if (data is String) {
        _messageController.add(data);
      } else if (data is List<int>) {
        _messageController.add(utf8.decode(data));
      }
    }, onDone: () {
      print('SocketManager: WebSocket closed');
    }, onError: (error) {
      print('SocketManager: WebSocket error: $error');
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    final jsonString = jsonEncode(message);
    if (_channel != null) {
      print('SocketManager: Sending message: $jsonString');
      _channel!.sink.add(jsonString);
    } else {
      print('SocketManager: WebSocket not connected');
    }
  }

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}

final socketManager = SocketManager();

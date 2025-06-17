import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketManager {
  WebSocketChannel? _channel;
  final _messageController = StreamController<String>.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  void connect(String url) {
    print('✅ Connected to $url');
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (data) {
        if (data is String) {
          print('📥 Received: $data');
          _messageController.add(data);
        } else if (data is List<int>) {
          final decoded = utf8.decode(data);
          print('📥 Received: $decoded');
          _messageController.add(decoded);
        }
      },

      onDone: () => print('Socket closed'),
      onError: (error) => print('Socket error: $error'),
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    final jsonString = jsonEncode(message);
    if (_channel != null) {
      print('📤 Sending: $jsonString');
      _channel!.sink.add(jsonString);
    }
  }

  void dispose() {
    _channel?.sink.close();
    _messageController.close();
  }
}

final socketManager = SocketManager();

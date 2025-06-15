import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'core/network/socket_manager.dart';
import 'features/chat/presentation/blocs/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  socketManager.connect('ws://192.168.1.7:3000'); // Replace with your server URL

  const uuid = Uuid();
  final deviceId = uuid.v4();

  // Change this manually per device:
  final deviceName = 'Device 1'; // On second device, set to 'Device 2'

  runApp(MyApp(deviceId: deviceId, deviceName: deviceName));
}

class MyApp extends StatelessWidget {
  final String deviceId;
  final String deviceName;

  const MyApp({Key? key, required this.deviceId, required this.deviceName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: BlocProvider(
        create: (_) => ChatBloc(socketManager, deviceId),
        child: ChatPage(deviceId: deviceId, deviceName: deviceName),
      ),
    );
  }
}

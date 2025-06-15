import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- For SystemChrome
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/socket_manager.dart';
import 'features/chat/presentation/blocs/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Make the app fullscreen, edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Optional: set transparent status bar & navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  socketManager.connect('ws://192.168.1.6:3000'); // Replace with your server URL

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ChatBloc(socketManager),
        child: const ChatPage(),
      ),
    );
  }
}

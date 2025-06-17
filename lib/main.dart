import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'core/di/injection_container.dart';
import 'features/chat/presentation/blocs/chat_bloc.dart';
import 'features/chat/presentation/pages/chat_page.dart';

// Conditional import for platform check
import 'src/platform_stub.dart' if (dart.library.io) 'src/platform_io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final deviceInfo = await getOrCreateDeviceInfo();
  final deviceId = deviceInfo['deviceId']!;
  final deviceName = deviceInfo['deviceName']!;

  const String serverHost = kIsWeb
      ? 'ws://localhost:3000'
      : 'ws://192.168.1.7:3000';

  await init(serverHost);

  runApp(MyApp(deviceId: deviceId, deviceName: deviceName));
}

class MyApp extends StatelessWidget {
  final String deviceId;
  final String deviceName;

  const MyApp({super.key, required this.deviceId, required this.deviceName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: BlocProvider(
        create: (_) => sl<ChatBloc>(param1: deviceId, param2: deviceName),
        child: ChatPage(deviceId: deviceId, deviceName: deviceName),
      ),
    );
  }
}

Future<Map<String, String>> getOrCreateDeviceInfo() async {
  final prefs = await SharedPreferences.getInstance();

  String? deviceId = prefs.getString('deviceId');
  String? deviceName = prefs.getString('deviceName');

  if (deviceId == null || deviceName == null) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    deviceId = 'device_$timestamp';

    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      deviceName = 'Web Browser';
    } else if (isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      final brand = androidInfo.brand;
      final model = androidInfo.model;
      deviceName = '$brand $model';
    } else if (isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      final name = iosInfo.name;
      final model = iosInfo.utsname.machine;
      deviceName = '$name ($model)';
    } else if (isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      deviceName = windowsInfo.computerName;
    } else if (isMacOS) {
      final macInfo = await deviceInfo.macOsInfo;
      deviceName = macInfo.computerName;
    } else {
      deviceName = 'Unknown Device';
    }

    await prefs.setString('deviceId', deviceId);
    await prefs.setString('deviceName', deviceName);
  }

  return {'deviceId': deviceId, 'deviceName': deviceName};
}

import 'dart:io';

void main() {
  final dirs = [
    'lib/core/network',
    'lib/features/chat/domain/entities',
    'lib/features/chat/presentation/blocs',
    'lib/features/chat/presentation/pages',
    'lib/features/chat/presentation/widgets',
  ];

  final files = {
    'lib/core/network/socket_manager.dart': '',
    'lib/features/chat/domain/entities/message.dart': '',
    'lib/features/chat/presentation/blocs/chat_bloc.dart': '',
    'lib/features/chat/presentation/blocs/chat_event.dart': '',
    'lib/features/chat/presentation/blocs/chat_state.dart': '',
    'lib/features/chat/presentation/pages/chat_page.dart': '',
    'lib/features/chat/presentation/widgets/message_bubble.dart': '',
    'lib/main.dart': '',
  };

  for (var dir in dirs) {
    Directory(dir).createSync(recursive: true);
    print('Created directory: $dir');
  }

  for (var path in files.keys) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
      print('Created file: $path');
    }
  }

  print('\nProject structure created! Now paste your code into these files.');
}

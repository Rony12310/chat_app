import 'package:chat_application/features/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChatPage renders and can send a message', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChatPage(
          deviceId: 'test-device-id',
          deviceName: 'Test Device',
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello Test!');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('Hello Test!'), findsNothing);
  });
}

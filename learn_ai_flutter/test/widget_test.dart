// Basic Flutter widget test for the Learn AI streaming screen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:learn_ai_flutter/main.dart';

void main() {
  testWidgets('Streaming screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LearnAIApp());

    // App shows the streaming screen with title and Start streaming button.
    expect(find.text('Fake AI Streamer'), findsOneWidget);
    expect(find.text('Start streaming'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });
}

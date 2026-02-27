import 'package:flutter/material.dart';

import 'package:learn_ai_flutter/core/domain/ai_streamer.dart';
import 'package:learn_ai_flutter/features/streaming/presentation/streaming_screen.dart';

/// **Design pattern: Composition root (receives dependencies from [main]).**
///
/// Root widget for the Learn AI Flutter app. [aiStreamer] is injected so
/// we can swap fake vs real without changing app code — scalability.
class LearnAIApp extends StatelessWidget {
  const LearnAIApp({super.key, required this.aiStreamer});

  final AIStreamer aiStreamer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn AI - Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamingScreen(streamer: aiStreamer),
    );
  }
}

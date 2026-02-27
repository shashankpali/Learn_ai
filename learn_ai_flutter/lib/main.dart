import 'package:flutter/material.dart';

import 'package:learn_ai_flutter/app.dart';
import 'package:learn_ai_flutter/features/streaming/data/fake_ai_streamer.dart';

/// **Design pattern: Composition root (single place where dependencies are created).**
///
/// All injectable dependencies are built here. When we add real API, config, or
/// state, we add them here (or a dedicated `injection.dart`) and pass down.
/// This keeps the app scalable and testable.
void main() {
  final aiStreamer = FakeAIStreamer();
  runApp(LearnAIApp(aiStreamer: aiStreamer));
}

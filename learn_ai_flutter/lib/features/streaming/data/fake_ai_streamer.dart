import 'dart:async';

import 'package:learn_ai_flutter/core/domain/ai_streamer.dart';

/// **Design pattern: Strategy (concrete implementation).**
///
/// Simulates an AI streaming response by emitting text character by character.
/// Use for Phase 1 and tests; swap for real API implementation in Phase 2.
final class FakeAIStreamer implements AIStreamer {
  /// Streams [prompt] one character at a time with optional [delay] between chunks.
  @override
  Stream<String> streamResponse(
    String prompt, {
    Duration delay = const Duration(milliseconds: 40),
  }) async* {
    String current = '';
    for (final char in prompt.runes) {
      current += String.fromCharCode(char);
      yield current;
      await Future.delayed(delay);
    }
  }
}

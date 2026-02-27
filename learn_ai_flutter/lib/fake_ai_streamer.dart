import 'dart:async';

/// Simulates an AI streaming response by emitting text character by character.
/// Use this to practice streaming UI before connecting a real AI API.
class FakeAIStreamer {
  /// Streams [text] one character at a time with optional [delay] between chunks.
  /// Listen to the stream to update your UI as each chunk arrives.
  Stream<String> streamResponse(
    String text, {
    Duration delay = const Duration(milliseconds: 50),
  }) async* {
    String current = '';
    for (int i = 0; i < text.length; i++) {
      current += text[i];
      yield current;
      await Future.delayed(delay);
    }
  }
}

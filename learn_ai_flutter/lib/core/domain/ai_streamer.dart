/// **Design pattern: Strategy (abstraction).**
///
/// Contract for AI streaming so fake and real implementations are swappable.
/// Implementations: [FakeAIStreamer] (Phase 1), real API streamer (Phase 2).
abstract interface class AIStreamer {
  /// Streams a response for the given [prompt], yielding cumulative text chunks.
  ///
  /// Listeners receive growing strings (e.g. "H", "He", "Hel", ...) until
  /// the response is complete or the stream is cancelled.
  Stream<String> streamResponse(String prompt);
}

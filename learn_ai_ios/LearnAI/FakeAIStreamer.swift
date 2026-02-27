import Foundation

/// Simulates an AI streaming response by emitting text character by character.
/// Use this to practice streaming UI before connecting a real AI API.
final class FakeAIStreamer {

    private var currentTask: Task<Void, Never>?

    /// Streams `text` one character at a time, calling `onUpdate` with the accumulated string
    /// and `onComplete` when done. Uses `chunkDelay` between characters.
    func streamResponse(
        text: String,
        chunkDelay: TimeInterval = 0.05,
        onUpdate: @escaping (String) -> Void,
        onComplete: @escaping () -> Void
    ) {
        currentTask = Task {
            var current = ""
            for char in text {
                if Task.isCancelled { return }
                current.append(char)
                await MainActor.run { onUpdate(current) }
                try? await Task.sleep(nanoseconds: UInt64(chunkDelay * 1_000_000_000))
            }
            if !Task.isCancelled {
                await MainActor.run { onComplete() }
            }
        }
    }

    /// Cancels any ongoing stream.
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}

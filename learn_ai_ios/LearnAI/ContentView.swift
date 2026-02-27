import SwiftUI

struct ContentView: View {
    @State private var streamedText = ""
    @State private var isStreaming = false

    private let streamer = FakeAIStreamer()
    private let sampleMessage = "Hello! This is a streaming AI response. You will see this text appear gradually."

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step 1: Streaming mental model")
                        .font(.headline)
                    Text("Tap \"Start streaming\" to simulate an AI typing response. Cancel mid-stream to practice cancellation.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Response")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    ScrollView {
                        Text(streamedText.isEmpty ? "…" : streamedText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                HStack(spacing: 12) {
                    Button {
                        startStreaming()
                    } label: {
                        Label("Start streaming", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isStreaming)

                    Button {
                        cancelStreaming()
                    } label: {
                        Label("Cancel", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isStreaming)
                }
            }
            .padding(24)
            .navigationTitle("Fake AI Streamer")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func startStreaming() {
        guard !isStreaming else { return }
        isStreaming = true
        streamedText = ""

        streamer.streamResponse(
            text: sampleMessage,
            chunkDelay: 0.04,
            onUpdate: { partial in
                streamedText = partial
            },
            onComplete: {
                isStreaming = false
            }
        )
    }

    private func cancelStreaming() {
        streamer.cancel()
        isStreaming = false
    }
}

#Preview {
    ContentView()
}

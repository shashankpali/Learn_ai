import 'dart:async';

import 'package:flutter/material.dart';
import 'fake_ai_streamer.dart';

void main() {
  runApp(const LearnAIApp());
}

class LearnAIApp extends StatelessWidget {
  const LearnAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn AI - Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StreamingScreen(),
    );
  }
}

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  final FakeAIStreamer _streamer = FakeAIStreamer();
  String _streamedText = '';
  bool _isStreaming = false;
  StreamSubscription<String>? _subscription;

  void _startStreaming() {
    if (_isStreaming) return;
    setState(() {
      _isStreaming = true;
      _streamedText = '';
    });

    _subscription = _streamer
        .streamResponse(
          'Hello! This is a streaming AI response. You will see this text appear gradually.',
          delay: const Duration(milliseconds: 40),
        )
        .listen(
          (partial) => setState(() => _streamedText = partial),
          onDone: () => setState(() => _isStreaming = false),
          onError: (_) => setState(() => _isStreaming = false),
        );
  }

  void _cancelStreaming() {
    _subscription?.cancel();
    setState(() => _isStreaming = false);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake AI Streamer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Step 1: Streaming mental model',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap "Start streaming" to simulate an AI typing response. '
              'Cancel mid-stream to practice cancellation.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _streamedText.isEmpty ? '…' : _streamedText,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isStreaming ? null : _startStreaming,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start streaming'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isStreaming ? _cancelStreaming : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

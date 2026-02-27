import 'dart:async';

import 'package:flutter/material.dart';

import 'package:learn_ai_flutter/core/domain/ai_streamer.dart';
import 'package:learn_ai_flutter/features/streaming/data/fake_ai_streamer.dart';

/// **Design pattern: Dependency injection (constructor), Separation of concerns (UI only).**
///
/// Presents streaming AI response; [streamer] is injected so we can use
/// FakeAIStreamer or a real API implementation without changing this screen.
class StreamingScreen extends StatefulWidget {
  StreamingScreen({super.key, AIStreamer? streamer})
      : _streamer = streamer ?? FakeAIStreamer();

  final AIStreamer _streamer;

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  String _streamedText = '';
  bool _isStreaming = false;
  StreamSubscription<String>? _subscription;

  void _startStreaming() {
    if (_isStreaming) return;
    setState(() {
      _isStreaming = true;
      _streamedText = '';
    });

    const String message =
        'Hello! This is a streaming AI response. You will see this text appear gradually.';
    _subscription = widget._streamer.streamResponse(message).listen(
      (partial) {
        if (!mounted) return;
        setState(() => _streamedText = partial);
      },
      onDone: () {
        if (!mounted) return;
        setState(() => _isStreaming = false);
      },
      onError: (_) {
        if (!mounted) return;
        setState(() => _isStreaming = false);
      },
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake AI Streamer'),
        backgroundColor: colorScheme.surfaceContainerHighest,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Step 1: Streaming mental model',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Start streaming" to simulate an AI typing response. '
              'Cancel mid-stream to practice cancellation.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _streamedText.isEmpty ? '…' : _streamedText,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
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

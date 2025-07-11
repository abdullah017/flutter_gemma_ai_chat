
import 'package:flutter/material.dart';
import '../../data/services/gemma_service.dart';
import 'modern_chat_screen.dart';

class ModelDownloadProgressScreen extends StatefulWidget {
  final String apiKey;

  const ModelDownloadProgressScreen({super.key, required this.apiKey});

  @override
  State<ModelDownloadProgressScreen> createState() => _ModelDownloadProgressScreenState();
}

class _ModelDownloadProgressScreenState extends State<ModelDownloadProgressScreen> {
  final GemmaService _gemmaService = GemmaService();
  double _downloadProgress = 0.0;
  String? _downloadError;

  @override
  void initState() {
    super.initState();
    _startModelDownload();
  }

  void _startModelDownload() async {
    try {
      await _gemmaService.initialize(
        apiKey: widget.apiKey,
        onProgress: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );
      // Download complete, navigate to chat screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ModernChatScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _downloadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloading Model'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_downloadError == null)
                Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16.0),
                    Text('Downloading model: ${(_downloadProgress * 100).toStringAsFixed(1)}%'),
                    const SizedBox(height: 16.0),
                    LinearProgressIndicator(value: _downloadProgress),
                  ],
                )
              else
                Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48.0),
                    const SizedBox(height: 16.0),
                    Text(
                      'Model download failed: $_downloadError',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Optionally, allow retrying download or going back to API key screen
                        Navigator.pop(context); // Go back to API key input
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

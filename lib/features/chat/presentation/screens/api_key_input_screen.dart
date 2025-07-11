
import 'package:flutter/material.dart';
import 'package:flutter_local_gemma/features/chat/presentation/screens/model_download_progress_screen.dart';

class ApiKeyInputScreen extends StatefulWidget {
  const ApiKeyInputScreen({super.key});

  @override
  State<ApiKeyInputScreen> createState() => _ApiKeyInputScreenState();
}

class _ApiKeyInputScreenState extends State<ApiKeyInputScreen> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter API Key'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Please enter your Hugging Face API Key.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                hintText: 'Hugging Face API Key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (_apiKeyController.text.trim().isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModelDownloadProgressScreen(
                        apiKey: _apiKeyController.text.trim(),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter your API Key.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Download Model'),
            ),
          ],
        ),
      ),
    );
  }
}

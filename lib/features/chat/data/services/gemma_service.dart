import 'dart:io';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/core/chat.dart';
import 'package:flutter_gemma/core/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';

class GemmaService {
  static final GemmaService _instance = GemmaService._internal();
  
  factory GemmaService() {
    return _instance;
  }
  
  GemmaService._internal();
  
  final FlutterGemmaPlugin _gemma = FlutterGemmaPlugin.instance;
  InferenceModel? _model;
  InferenceChat? _chat;
  bool _isModelReady = false;
  String? _currentLanguage;

  bool get isModelReady => _isModelReady;
  String? get currentLanguage => _currentLanguage;

  Future<void> initialize({
    required String apiKey,
    required String language,
    Function(double)? onProgress,
  }) async {
    if (_isModelReady && _currentLanguage == language) return;

    try {
      final modelFilename = AppConstants.modelFileName;
      final directory = await getApplicationDocumentsDirectory();
      final modelPath = '${directory.path}/$modelFilename';
      final modelFile = File(modelPath);

      if (!modelFile.existsSync()) {
        debugPrint("Model not found locally, downloading...");
        await _downloadModel(modelFile, apiKey, onProgress);
      } else {
        debugPrint("Model already exists locally.");
      }

      debugPrint("Setting model path: $modelPath");
      await _gemma.modelManager.setModelPath(modelPath);

      debugPrint("Creating model...");
      _model = await _gemma.createModel(
        modelType: ModelType.gemmaIt,
      );
      
      debugPrint("Creating chat...");
      _chat = await _model!.createChat();
      
      // Set system prompt based on language
      debugPrint("Setting system prompt for language: $language");
      await _setSystemPrompt(language);
      
      debugPrint("Model and chat initialized successfully");
      _isModelReady = true;
      _currentLanguage = language;
    } catch (e) {
      debugPrint("Error initializing model: $e");
      rethrow;
    }
  }

  Future<void> _downloadModel(File modelFile, String apiKey, Function(double)? onProgress) async {
    final modelUrl = AppConstants.modelUrl;
    IOSink? fileSink;
    
    try {
      final request = http.Request('GET', Uri.parse(modelUrl));
      if (apiKey.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $apiKey';
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final contentLength = response.contentLength;
        if (contentLength == null) {
          debugPrint("Content-Length header missing. Cannot track progress.");
        }

        fileSink = modelFile.openWrite();
        int receivedBytes = 0;

        await for (final chunk in response.stream) {
          fileSink.add(chunk);
          receivedBytes += chunk.length;
          if (contentLength != null && onProgress != null) {
            onProgress(receivedBytes / contentLength);
          }
        }
        debugPrint("Model downloaded successfully.");
      } else {
        debugPrint("Failed to download model. Status code: ${response.statusCode}");
        throw Exception("Failed to download model.");
      }
    } catch (e) {
      debugPrint("Error during model download: $e");
      rethrow;
    } finally {
      await fileSink?.close();
    }
  }

  Future<void> _setSystemPrompt(String language) async {
    if (_chat == null) return;
    
    final languageName = AppConstants.languageNames[language] ?? 'English';
    final systemPrompt = '''
You are a helpful AI assistant. Please follow these guidelines:
1. Respond in $languageName language
2. Be friendly, helpful, and informative
3. Simple greetings like 'hello', 'hi', 'selam', 'hola' are normal conversation starters
4. Provide accurate and relevant information
5. If you don't know something, say so honestly
6. Keep responses conversational and engaging
7. For technical questions, provide clear explanations
8. Always maintain a respectful and professional tone
''';

    await _chat!.addQueryChunk(Message.text(
      text: systemPrompt,
      isUser: false,
    ));
  }

  Future<String> getResponse(String message, String language) async {
    debugPrint("getResponse called with message: $message, language: $language");
    debugPrint("_isModelReady: $_isModelReady");
    debugPrint("_chat is null: ${_chat == null}");
    
    if (_chat == null) {
      debugPrint("Error: Gemma Chat is not initialized.");
      return "Error: Gemma Chat is not initialized.";
    }

    // If language changed, reinitialize with new language
    if (_currentLanguage != language) {
      debugPrint("Language changed from $_currentLanguage to $language, reinitializing...");
      // Note: This would require the API key, which we don't have here
      // In a real scenario, you might want to store the API key or handle this differently
    }

    try {
      debugPrint("Adding query chunk...");
      
      // Format the message based on language
      final languageName = AppConstants.languageNames[language] ?? 'English';
      String formattedMessage = "User message: $message\n\nPlease respond in $languageName in a helpful and friendly way.";
      
      await _chat!.addQueryChunk(Message.text(text: formattedMessage, isUser: true));
      debugPrint("Generating chat response...");
      final response = await _chat!.generateChatResponse();
      debugPrint("Response received: $response");
      return response;
    } catch (e) {
      debugPrint("Error getting response from model: $e");
      return 'Error: $e';
    }
  }

  Future<void> clearChat() async {
    if (_chat != null && _model != null) {
      _chat = await _model!.createChat();
      if (_currentLanguage != null) {
        await _setSystemPrompt(_currentLanguage!);
      }
    }
  }

  void dispose() {
    _model = null;
    _chat = null;
    _isModelReady = false;
    _currentLanguage = null;
  }
}
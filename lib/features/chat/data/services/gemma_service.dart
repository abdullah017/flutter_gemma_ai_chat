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
    Function(double)? onProgress,
  }) async {
    if (_isModelReady) return;

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
      
      debugPrint("Model and chat initialized successfully");
      _isModelReady = true;
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
    
    // Skip system prompt for now - it might be causing issues
    // Just rely on per-message language instructions
    debugPrint("Skipping system prompt to test basic functionality");
  }

  Future<String> getResponse(String message) async {
    debugPrint("getResponse called with message: $message");
    debugPrint("_isModelReady: $_isModelReady");
    debugPrint("_chat is null: ${_chat == null}");
    
    if (_chat == null) {
      debugPrint("Error: Gemma Chat is not initialized.");
      return "Error: Gemma Chat is not initialized.";
    }

    try {
      // Use a very simple approach - just add the user message
      debugPrint("Adding user message: $message");
      await _chat!.addQueryChunk(Message.text(text: message, isUser: true));
      
      debugPrint("Generating chat response...");
      
      // Try to get response
      final response = await _chat!.generateChatResponse();
      
      debugPrint("Response received: '$response'");
      debugPrint("Response length: ${response.length}");
      
      if (response.isEmpty || response.trim().isEmpty) {
        debugPrint("Empty response received");
        return 'I apologize, but I cannot generate a response right now. Please try a different message.';
      }
      
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
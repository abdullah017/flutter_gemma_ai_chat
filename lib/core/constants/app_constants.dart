class AppConstants {
  // App Info
  static const String appName = 'Gemma AI Chat';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Local AI Chat with Gemma Model';
  
  // Storage Keys
  static const String apiKeyStorageKey = 'gemma_api_key';
  static const String languageStorageKey = 'selected_language';
  static const String themeStorageKey = 'selected_theme';
  static const String chatHistoryStorageKey = 'chat_history';
  
  // Database
  static const String databaseName = 'gemma_chat.db';
  static const int databaseVersion = 1;
  
  // Model Info
  static const String modelName = 'Gemma3-1B-IT';
  static const String modelFileName = 'Gemma3-1B-IT_multi-prefill-seq_q4_ekv2048.task';
  static const String modelUrl = 'https://huggingface.co/litert-community/Gemma3-1B-IT/resolve/main/Gemma3-1B-IT_multi-prefill-seq_q4_ekv2048.task';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;
  
  // Animation Durations
  static const int defaultAnimationDuration = 300;
  static const int quickAnimationDuration = 150;
  static const int slowAnimationDuration = 500;
  
  // Supported Languages
  static const List<String> supportedLanguages = [
    'en', // English
    'tr', // Turkish
    'es', // Spanish
    'fr', // French
    'de', // German
    'it', // Italian
    'pt', // Portuguese
    'ru', // Russian
    'ja', // Japanese
    'ko', // Korean
    'zh', // Chinese
    'ar', // Arabic
  ];
  
  // Language Names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'tr': 'Türkçe',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ru': 'Русский',
    'ja': '日本語',
    'ko': '한국어',
    'zh': '中文',
    'ar': 'العربية',
  };
}
import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../data/repositories/chat_repository.dart';
import '../../../../core/services/storage_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;
  
  ChatProvider(this._chatRepository);

  // State
  List<ChatConversation> _conversations = [];
  ChatConversation? _currentConversation;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isModelInitialized = false;
  bool _isGeneratingResponse = false;
  String? _error;
  String _selectedLanguage = 'en';
  
  // Getters
  List<ChatConversation> get conversations => _conversations;
  ChatConversation? get currentConversation => _currentConversation;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isModelInitialized => _isModelInitialized;
  bool get isGeneratingResponse => _isGeneratingResponse;
  String? get error => _error;
  String get selectedLanguage => _selectedLanguage;
  
  // Initialize
  Future<void> initialize() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Load saved language
      final savedLanguage = await StorageService.getLanguage();
      if (savedLanguage != null) {
        _selectedLanguage = savedLanguage;
      }
      
      // Load conversations
      await loadConversations();
      
      // Initialize model if API key exists
      final apiKey = await StorageService.getApiKey();
      if (apiKey != null && apiKey.isNotEmpty) {
        await _initializeModel(apiKey);
      }
    } catch (e) {
      _setError('Failed to initialize: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Model initialization
  Future<void> initializeModel(String apiKey) async {
    _setLoading(true);
    _clearError();
    
    try {
      await StorageService.saveApiKey(apiKey);
      await _initializeModel(apiKey);
    } catch (e) {
      _setError('Failed to initialize model: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _initializeModel(String apiKey) async {
    await _chatRepository.initialize(apiKey, _selectedLanguage);
    _isModelInitialized = true;
    notifyListeners();
  }
  
  // Language management
  Future<void> setLanguage(String languageCode) async {
    if (_selectedLanguage == languageCode) return;
    
    _selectedLanguage = languageCode;
    await StorageService.saveLanguage(languageCode);
    
    // Re-initialize model with new language if already initialized
    if (_isModelInitialized) {
      final apiKey = await StorageService.getApiKey();
      if (apiKey != null) {
        await _initializeModel(apiKey);
      }
    }
    
    notifyListeners();
  }
  
  // Conversation management
  Future<void> loadConversations() async {
    try {
      _conversations = await _chatRepository.getConversations();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load conversations: $e');
    }
  }
  
  Future<void> createNewConversation({String? title}) async {
    _clearError();
    
    try {
      final conversation = ChatConversation(
        title: title ?? 'New Chat',
        language: _selectedLanguage,
      );
      
      await _chatRepository.createConversation(conversation);
      await loadConversations();
      await selectConversation(conversation.id);
    } catch (e) {
      _setError('Failed to create conversation: $e');
    }
  }
  
  Future<void> selectConversation(String conversationId) async {
    _clearError();
    
    try {
      _currentConversation = await _chatRepository.getConversation(conversationId);
      if (_currentConversation != null) {
        _messages = await _chatRepository.getMessages(conversationId);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to select conversation: $e');
    }
  }
  
  Future<void> deleteConversation(String conversationId) async {
    _clearError();
    
    try {
      await _chatRepository.deleteConversation(conversationId);
      await loadConversations();
      
      // Clear current conversation if it was deleted
      if (_currentConversation?.id == conversationId) {
        _currentConversation = null;
        _messages = [];
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to delete conversation: $e');
    }
  }
  
  Future<void> updateConversationTitle(String conversationId, String newTitle) async {
    _clearError();
    
    try {
      final conversation = await _chatRepository.getConversation(conversationId);
      if (conversation != null) {
        final updatedConversation = conversation.copyWith(
          title: newTitle,
          updatedAt: DateTime.now(),
        );
        await _chatRepository.updateConversation(updatedConversation);
        await loadConversations();
        
        // Update current conversation if it's the one being updated
        if (_currentConversation?.id == conversationId) {
          _currentConversation = updatedConversation;
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Failed to update conversation title: $e');
    }
  }
  
  // Message management
  Future<void> sendMessage(String content) async {
    if (_currentConversation == null || !_isModelInitialized) return;
    
    _clearError();
    _isGeneratingResponse = true;
    notifyListeners();
    
    try {
      // Create user message
      final userMessage = ChatMessage(
        conversationId: _currentConversation!.id,
        content: content,
        isUser: true,
      );
      
      // Add user message to database and UI
      await _chatRepository.insertMessage(userMessage);
      _messages.add(userMessage);
      notifyListeners();
      
      // Generate AI response
      final aiResponse = await _chatRepository.generateResponse(content, _selectedLanguage);
      
      // Create AI message
      final aiMessage = ChatMessage(
        conversationId: _currentConversation!.id,
        content: aiResponse,
        isUser: false,
      );
      
      // Add AI message to database and UI
      await _chatRepository.insertMessage(aiMessage);
      _messages.add(aiMessage);
      
      // Update conversation timestamp
      await _chatRepository.updateConversation(
        _currentConversation!.copyWith(updatedAt: DateTime.now()),
      );
      
      // Update title if this is the first message
      if (_messages.length == 2) { // User message + AI response
        final title = _generateConversationTitle(content);
        await updateConversationTitle(_currentConversation!.id, title);
      }
      
    } catch (e) {
      _setError('Failed to send message: $e');
    } finally {
      _isGeneratingResponse = false;
      notifyListeners();
    }
  }
  
  Future<void> deleteMessage(String messageId) async {
    _clearError();
    
    try {
      await _chatRepository.deleteMessage(messageId);
      _messages.removeWhere((message) => message.id == messageId);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete message: $e');
    }
  }
  
  Future<void> clearConversation() async {
    if (_currentConversation == null) return;
    
    _clearError();
    
    try {
      await _chatRepository.deleteAllMessages(_currentConversation!.id);
      _messages.clear();
      notifyListeners();
    } catch (e) {
      _setError('Failed to clear conversation: $e');
    }
  }
  
  // Utility methods
  String _generateConversationTitle(String firstMessage) {
    // Generate a title based on the first message
    final words = firstMessage.split(' ');
    if (words.length > 5) {
      return '${words.take(5).join(' ')}...';
    }
    return firstMessage;
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  void clearError() {
    _clearError();
  }
  
  @override
  void dispose() {
    _chatRepository.dispose();
    super.dispose();
  }
}
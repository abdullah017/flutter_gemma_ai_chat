import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_conversation.dart';
import '../services/gemma_service.dart';
import '../../../../core/services/database_service.dart';

class ChatRepository {
  final GemmaService _gemmaService;
  final DatabaseService _databaseService;
  
  ChatRepository(this._gemmaService, this._databaseService);
  
  // Model initialization
  Future<void> initialize(String apiKey) async {
    await _gemmaService.initialize(apiKey: apiKey);
  }
  
  // Response generation
  Future<String> generateResponse(String message) async {
    return await _gemmaService.getResponse(message);
  }
  
  // Conversation management
  Future<String> createConversation(ChatConversation conversation) async {
    return await _databaseService.createConversation(conversation);
  }
  
  Future<List<ChatConversation>> getConversations() async {
    return await _databaseService.getConversations();
  }
  
  Future<ChatConversation?> getConversation(String id) async {
    return await _databaseService.getConversation(id);
  }
  
  Future<void> updateConversation(ChatConversation conversation) async {
    await _databaseService.updateConversation(conversation);
  }
  
  Future<void> deleteConversation(String id) async {
    await _databaseService.deleteConversation(id);
  }
  
  // Message management
  Future<void> insertMessage(ChatMessage message) async {
    await _databaseService.insertMessage(message);
  }
  
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    return await _databaseService.getMessages(conversationId);
  }
  
  Future<void> deleteMessage(String messageId) async {
    await _databaseService.deleteMessage(messageId);
  }
  
  Future<void> deleteAllMessages(String conversationId) async {
    await _databaseService.deleteAllMessages(conversationId);
  }
  
  // Cleanup
  void dispose() {
    _gemmaService.dispose();
  }
}
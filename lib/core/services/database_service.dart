import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';
import '../../features/chat/domain/entities/chat_message.dart';
import '../../features/chat/domain/entities/chat_conversation.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() => _instance;
  
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, AppConstants.databaseName);
    
    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create conversations table
    await db.execute('''
      CREATE TABLE conversations (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        language TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create messages table
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        content TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (conversation_id) REFERENCES conversations (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes
    await db.execute('''
      CREATE INDEX idx_messages_conversation_id ON messages(conversation_id)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_messages_created_at ON messages(created_at)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Add migration logic here when needed
    }
  }

  // Conversation methods
  Future<String> createConversation(ChatConversation conversation) async {
    final db = await database;
    await db.insert(
      'conversations',
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return conversation.id;
  }

  Future<List<ChatConversation>> getConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      orderBy: 'updated_at DESC',
    );
    
    return List.generate(maps.length, (i) {
      return ChatConversation.fromMap(maps[i]);
    });
  }

  Future<ChatConversation?> getConversation(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return ChatConversation.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateConversation(ChatConversation conversation) async {
    final db = await database;
    await db.update(
      'conversations',
      conversation.toMap(),
      where: 'id = ?',
      whereArgs: [conversation.id],
    );
  }

  Future<void> deleteConversation(String id) async {
    final db = await database;
    await db.delete(
      'conversations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Message methods
  Future<void> insertMessage(ChatMessage message) async {
    final db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'created_at ASC',
    );
    
    return List.generate(maps.length, (i) {
      return ChatMessage.fromMap(maps[i]);
    });
  }

  Future<void> deleteMessage(String messageId) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  Future<void> deleteAllMessages(String conversationId) async {
    final db = await database;
    await db.delete(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
    );
  }

  // Utility methods
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('messages');
    await db.delete('conversations');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
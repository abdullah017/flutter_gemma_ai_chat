import 'package:uuid/uuid.dart';

class ChatMessage {
  final String id;
  final String conversationId;
  final String content;
  final bool isUser;
  final DateTime createdAt;

  ChatMessage({
    String? id,
    required this.conversationId,
    required this.content,
    required this.isUser,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? content,
    bool? isUser,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'content': content,
      'is_user': isUser ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      conversationId: map['conversation_id'],
      content: map['content'],
      isUser: map['is_user'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, content: $content, isUser: $isUser, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.conversationId == conversationId &&
        other.content == content &&
        other.isUser == isUser &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        conversationId.hashCode ^
        content.hashCode ^
        isUser.hashCode ^
        createdAt.hashCode;
  }
}
import 'package:uuid/uuid.dart';

class ChatConversation {
  final String id;
  final String title;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation({
    String? id,
    required this.title,
    required this.language,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  ChatConversation copyWith({
    String? id,
    String? title,
    String? language,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'language': language,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    return ChatConversation(
      id: map['id'],
      title: map['title'],
      language: map['language'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  @override
  String toString() {
    return 'ChatConversation(id: $id, title: $title, language: $language, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatConversation &&
        other.id == id &&
        other.title == title &&
        other.language == language &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        language.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
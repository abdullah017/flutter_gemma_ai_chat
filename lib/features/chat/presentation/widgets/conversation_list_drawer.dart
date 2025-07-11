import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/chat_provider.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class ConversationListDrawer extends StatelessWidget {
  const ConversationListDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: _buildConversationList(context),
          ),
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.smart_toy,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          const Text(
            AppConstants.appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              final languageName = AppConstants.languageNames[chatProvider.selectedLanguage] ?? 'English';
              return Text(
                'Language: $languageName',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final conversations = chatProvider.conversations;
        
        if (conversations.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                'No conversations yet.\nCreate a new chat to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        
        return ListView.builder(
          itemCount: conversations.length,
          itemBuilder: (context, index) {
            final conversation = conversations[index];
            final isSelected = chatProvider.currentConversation?.id == conversation.id;
            
            return _buildConversationTile(
              context,
              conversation,
              isSelected,
              chatProvider,
            ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
          },
        );
      },
    );
  }

  Widget _buildConversationTile(
    BuildContext context,
    ChatConversation conversation,
    bool isSelected,
    ChatProvider chatProvider,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          child: Icon(
            Icons.chat_bubble_outline,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            size: 20,
          ),
        ),
        title: Text(
          conversation.title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppTheme.primaryColor : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDate(conversation.updatedAt),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handleConversationAction(
            context,
            conversation,
            value,
            chatProvider,
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'rename',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16),
                  SizedBox(width: 8),
                  Text('Rename'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          chatProvider.selectConversation(conversation.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    chatProvider.createNewConversation();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Chat'),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Version ${AppConstants.appVersion}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _handleConversationAction(
    BuildContext context,
    ChatConversation conversation,
    String action,
    ChatProvider chatProvider,
  ) {
    switch (action) {
      case 'rename':
        _showRenameDialog(context, conversation, chatProvider);
        break;
      case 'delete':
        _showDeleteDialog(context, conversation, chatProvider);
        break;
    }
  }

  void _showRenameDialog(
    BuildContext context,
    ChatConversation conversation,
    ChatProvider chatProvider,
  ) {
    final controller = TextEditingController(text: conversation.title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Conversation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Conversation Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                chatProvider.updateConversationTitle(conversation.id, newTitle);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ChatConversation conversation,
    ChatProvider chatProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Conversation'),
        content: Text('Are you sure you want to delete "${conversation.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              chatProvider.deleteConversation(conversation.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
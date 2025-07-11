import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/chat_provider.dart';
import '../../domain/entities/chat_message.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/conversation_list_drawer.dart';

class ModernChatScreen extends StatefulWidget {
  const ModernChatScreen({super.key});

  @override
  State<ModernChatScreen> createState() => _ModernChatScreenState();
}

class _ModernChatScreenState extends State<ModernChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.initialize();
    
    // Create a new conversation if none exists
    if (chatProvider.conversations.isEmpty) {
      await chatProvider.createNewConversation();
    } else if (chatProvider.currentConversation == null) {
      await chatProvider.selectConversation(chatProvider.conversations.first.id);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: AppConstants.defaultAnimationDuration),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    _messageController.clear();
    await chatProvider.sendMessage(message);
    
    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ConversationListDrawer(),
      appBar: _buildAppBar(),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading && !chatProvider.isModelInitialized) {
            return _buildLoadingView();
          }

          if (!chatProvider.isModelInitialized) {
            return _buildApiKeyInputView(chatProvider);
          }

          if (chatProvider.currentConversation == null) {
            return _buildNoConversationView();
          }

          return _buildChatView(chatProvider);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatProvider.currentConversation?.title ?? AppConstants.appName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              if (chatProvider.isGeneratingResponse)
                const Text(
                  'AI is typing...',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
            ],
          );
        },
      ),
      actions: [
        Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            return PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value, chatProvider),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'new_chat',
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('New Chat'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_chat',
                  child: Row(
                    children: [
                      Icon(Icons.clear_all),
                      SizedBox(width: 8),
                      Text('Clear Chat'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Initializing AI model...'),
        ],
      ),
    );
  }

  Widget _buildApiKeyInputView(ChatProvider chatProvider) {
    final apiKeyController = TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.smart_toy,
            size: 80,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 24),
          const Text(
            'Welcome to Gemma AI Chat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Enter your Hugging Face API key to get started',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: apiKeyController,
            decoration: const InputDecoration(
              labelText: 'Hugging Face API Key',
              hintText: 'hf_xxxxxxxxxx',
              prefixIcon: Icon(Icons.key),
            ),
            obscureText: true,
            onSubmitted: (_) => _initializeModel(chatProvider, apiKeyController.text),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _initializeModel(chatProvider, apiKeyController.text),
            child: const Text('Initialize AI Model'),
          ),
          if (chatProvider.error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  chatProvider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNoConversationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No conversation selected',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a new conversation to start chatting',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).createNewConversation();
            },
            child: const Text('Start New Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatView(ChatProvider chatProvider) {
    return Column(
      children: [
        Expanded(
          child: _buildMessageList(chatProvider),
        ),
        if (chatProvider.isGeneratingResponse)
          const TypingIndicator().animate().fadeIn(),
        ChatInputField(
          controller: _messageController,
          onSendPressed: _sendMessage,
          enabled: !chatProvider.isGeneratingResponse,
        ),
      ],
    );
  }

  Widget _buildMessageList(ChatProvider chatProvider) {
    if (chatProvider.messages.isEmpty) {
      return _buildEmptyMessageList();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: chatProvider.messages.length,
      itemBuilder: (context, index) {
        final message = chatProvider.messages[index];
        return MessageBubble(
          message: message,
          onLongPress: () => _showMessageOptions(message, chatProvider),
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: index * 50))
            .slideX(begin: message.isUser ? 1 : -1);
      },
    );
  }

  Widget _buildEmptyMessageList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Start a conversation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            'Messages will appear in English',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, ChatProvider chatProvider) {
    switch (action) {
      case 'new_chat':
        chatProvider.createNewConversation();
        break;
      case 'clear_chat':
        _showClearChatDialog(chatProvider);
        break;
      case 'share':
        _shareConversation(chatProvider);
        break;
    }
  }


  void _showClearChatDialog(ChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              chatProvider.clearConversation();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showMessageOptions(ChatMessage message, ChatProvider chatProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Copy'),
            onTap: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(text: message.content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message copied to clipboard')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              Share.share(message.content);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              chatProvider.deleteMessage(message.id);
            },
          ),
        ],
      ),
    );
  }

  void _shareConversation(ChatProvider chatProvider) {
    final messages = chatProvider.messages;
    if (messages.isEmpty) return;

    final conversation = messages.map((message) {
      final sender = message.isUser ? 'You' : 'AI';
      return '$sender: ${message.content}';
    }).join('\n\n');

    Share.share(conversation);
  }

  Future<void> _initializeModel(ChatProvider chatProvider, String apiKey) async {
    if (apiKey.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your API key')),
      );
      return;
    }

    await chatProvider.initializeModel(apiKey);
  }
}
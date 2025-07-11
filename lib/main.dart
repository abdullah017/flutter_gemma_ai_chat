import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/services/database_service.dart';
import 'features/chat/data/services/gemma_service.dart';
import 'features/chat/data/repositories/chat_repository.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/chat/presentation/screens/modern_chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseService().database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<GemmaService>(
          create: (_) => GemmaService(),
        ),
        ProxyProvider2<GemmaService, DatabaseService, ChatRepository>(
          update: (_, gemmaService, databaseService, __) => 
              ChatRepository(gemmaService, databaseService),
        ),
        ChangeNotifierProxyProvider<ChatRepository, ChatProvider>(
          create: (context) => ChatProvider(
            Provider.of<ChatRepository>(context, listen: false),
          ),
          update: (_, chatRepository, __) => ChatProvider(chatRepository),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const ModernChatScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}